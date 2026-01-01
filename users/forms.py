import os
import re

import magic

from django import forms
from django.utils import timezone
from fontTools.subset import usage

from django.core.exceptions import ValidationError
from django.contrib.auth.password_validation import validate_password
from django.contrib.auth.forms import PasswordChangeForm

from .models import Participation, Factory, Department, Employee, Role, Evaluation, Holding, Subdepartment
from modules.security import validate_uploaded_file, clean_user_text






# forms.py
class ParticipationForm(forms.ModelForm):
    ALLOWED_EXTENSIONS = {
        '.jpg', '.jpeg', '.png', '.webp', '.gif', '.bmp', '.avif', '.heic', '.heif', # pic
        '.mp4', '.webm', '.avi', '.mov', '.mkv', '.flv', '.wmv', # video
        '.mp3', '.aac', '.ogg', '.m4a', '.opus', '.wma', '.wav', '.flac', # audio
        '.pdf', '.doc', '.docx', '.ppt', '.pptx', '.rtf', '.txt', '.odt', '.ods', '.odp', '.xls', '.xlsx', # doc
        '.pages', '.numbers', # ios
    }

    ACCEPT_ATTRIBUTE = ",".join(ALLOWED_EXTENSIONS)

    ALLOWED_MIME_MAP = {
        # تصاویر
        '.jpg': ['image/jpeg'],
        '.jpeg': ['image/jpeg'],
        '.png': ['image/png'],
        '.gif': ['image/gif'],
        '.webp': ['image/webp'],
        '.bmp': ['image/bmp', 'image/x-ms-bmp'],
        '.avif': ['image/avif'],
        '.heic': ['image/heic'],
        '.heif': ['image/heif'],

        # ویدیو
        '.mp4': ['video/mp4'],
        '.webm': ['video/webm', 'audio/webm'],
        '.avi': ['video/x-msvideo'],
        '.mov': ['video/quicktime'],
        '.mkv': ['video/x-matroska'],
        '.flv': ['video/x-flv'],
        '.wmv': ['video/x-ms-wmv'],

        # صوت
        '.mp3': ['audio/mpeg', 'audio/mp3'],
        '.wav': ['audio/wav', 'audio/x-wav'],
        '.m4a': ['audio/m4a', 'audio/mp4'],
        '.aac': ['audio/aac'],
        '.ogg': ['audio/ogg', 'video/ogg'],
        '.opus': ['audio/opus'],
        '.wma': ['audio/x-ms-wma'],
        '.flac': ['audio/flac'],

        # اسناد
        '.pdf': ['application/pdf'],
        '.doc': ['application/msword'],
        '.docx': ['application/vnd.openxmlformats-officedocument.wordprocessingml.document'],
        '.ppt': ['application/vnd.ms-powerpoint'],
        '.pptx': ['application/vnd.openxmlformats-officedocument.presentationml.presentation'],
        '.xls': ['application/vnd.ms-excel'],
        '.xlsx': ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
        '.txt': ['text/plain'],
        '.rtf': ['application/rtf', 'text/rtf'],

        # LibreOffice
        '.odt': ['application/vnd.oasis.opendocument.text'],
        '.ods': ['application/vnd.oasis.opendocument.spreadsheet'],
        '.odp': ['application/vnd.oasis.opendocument.presentation'],

        # اپل
        '.pages': ['application/x-iwork-pages'],
        '.numbers': ['application/x-iwork-numbers'],
    }
    DANGEROUS_PATTERNS = [
        r'<script[\s>]',  # <script> یا <script >
        r'</script>',  # </script>
        r'javascript:',  # javascript:alert(1)
        r'on\w+\s*=',  # onclick= onload= onmouseover= ...
        r'data:\s*text/html',  # data:text/html,...
        r'vbscript:',  # قدیمی ولی خطرناک
        r'expression\(',  # expression( در CSS
        r'@import',  # @import در CSS
        r'<iframe',  # iframe مخرب
        r'<object',  # object مخرب
        r'<embed',  # embed مخرب
        r'<link.*href.*=.*css',  # لینک به CSS مخرب
        r'src\s*=\s*["\']?[^"\'>]*\.js',  # src به فایل js
        r'href\s*=\s*["\']?javascript:',  # href="javascript:..."
    ]

    def __init__(self, *args, **kwargs):
        self.user = kwargs.pop('user', None)
        super().__init__(*args, **kwargs)

        # همیشه فقط کمیته‌ها در لیست باشند
        self.fields['subdepartment'].queryset = Subdepartment.objects.filter(is_committee=True)
        self.fields['subdepartment'].required = False
        self.fields['subdepartment'].empty_label = "یک کمیته انتخاب کنید..."
        self.fields['subdepartment'].label = "کمیته مربوطه"

        self.fields['attachment'].widget.attrs.update({
            'class': 'form-control',
            'accept': self.ACCEPT_ATTRIBUTE,  # این خط مهم است!
        })

        # فقط برای حالت اولیه (GET یا ویرایش)
        is_committee_checked = (
            self.instance.pk and self.instance.is_committee
        ) or self.data.get('is_committee') == 'on'

        self.fields['subdepartment'].required = is_committee_checked

        # هیچ style به ویجت اضافه نکن — فقط در قالب کنترل می‌کنیم
        self.fields['subdepartment'].widget.attrs.update({
            'class': 'form-select text-wrap',  # text-wrap اضافه شد
            'style': 'white-space: normal; max-width: 100%;'
        })

    class Meta:
        model = Participation
        fields = ['item_type', 'title', 'description', 'attachment', 'is_committee', 'subdepartment']
        widgets = {
            'item_type': forms.Select(attrs={'class': 'form-control'}),
            'title': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'عنوان مشارکت'}),
            'description': forms.Textarea(attrs={'class': 'form-control', 'placeholder': 'توضیحات', 'rows': 3}),
            'attachment': forms.ClearableFileInput(attrs={'class': 'form-control'}),
            'is_committee': forms.CheckboxInput(attrs={
                'class': 'form-check-input',
                'id': 'id_is_committee',
                'onclick': 'toggleCommitteeField()'
            }),
        }

    def clean(self):
        cleaned_data = super().clean()
        is_committee = cleaned_data.get('is_committee', False)
        subdepartment = cleaned_data.get('subdepartment')

        if is_committee:
            if not subdepartment:
                self.add_error('subdepartment', 'انتخاب کمیته الزامی است.')
        else:
            cleaned_data['subdepartment'] = None  # حتماً None کن

        return cleaned_data

    def clean_attachment(self):
        file = self.cleaned_data.get('attachment')
        if file:
            return validate_uploaded_file(file, user=self.user)



    def clean_title(self):
        title = self.cleaned_data.get('title', '')
        return clean_user_text(title)

    def clean_description(self):
        desc = self.cleaned_data.get('description', '')
        return clean_user_text(desc)

class ManagementFilterForm(forms.Form):
    # بعد از role اضافه کنید
    holding = forms.ModelChoiceField(queryset=Holding.objects.all(), required=False, label="هلدینگ",
                                     empty_label="همه هلدینگ‌ها")
    factory = forms.ModelChoiceField(queryset=Factory.objects.all(), required=False, label="کارخانه", empty_label="همه کارخانه‌ها")
    department = forms.ModelChoiceField(queryset=Department.objects.all(), required=False, label="بخش", empty_label="همه بخش‌ها")
    roles_filter = forms.ModelChoiceField(queryset=Role.objects.all(), required=False, label="نقش", empty_label="همه نقش‌ها")
    search_name = forms.CharField(max_length=100, required=False, label="جستجو بر اساس نام یا کد ملی", widget=forms.TextInput(attrs={'placeholder': 'نام یا کد ملی وارد کنید'}))

class UserDetailsFilterForm(forms.Form):
    factory = forms.ModelChoiceField(queryset=Factory.objects.all(), required=False, label="کارخانه", empty_label="همه کارخانه‌ها")
    department = forms.ModelChoiceField(queryset=Department.objects.all(), required=False, label="بخش", empty_label="همه بخش‌ها")
    role = forms.ModelChoiceField(queryset=Role.objects.all(), required=False, label="نقش", empty_label="همه نقش‌ها")
    search_title = forms.CharField(max_length=100, required=False, label="جستجو بر اساس عنوان", widget=forms.TextInput(attrs={'placeholder': 'عنوان مشارکت وارد کنید'}))

class EvaluationFilterForm(forms.Form):
    period = forms.ChoiceField(
        choices=[('', '---')] + list(Evaluation.TIME_PERIODS) + [('custom', 'سفارشی')],
        required=False,
        label="بازه زمانی"
    )
    factory = forms.ModelChoiceField(
        queryset=Factory.objects.all(),
        required=False,
        label="کارخانه",
        empty_label="همه کارخانه‌ها"
    )
    department = forms.ModelChoiceField(
        queryset=Department.objects.all(),
        required=False,
        label="بخش",
        empty_label="همه بخش‌ها"
    )
    employee = forms.ModelChoiceField(
        queryset=Employee.objects.all(),
        required=False,
        label="کارمند",
        empty_label="همه کارمندان"
    )
    start_date = forms.DateField(
        required=False,
        label="از تاریخ",
        widget=forms.DateInput(attrs={'type': 'date'})
    )
    end_date = forms.DateField(
        required=False,
        label="تا تاریخ",
        widget=forms.DateInput(attrs={'type': 'date'})
    )


class CustomPasswordChangeForm(PasswordChangeForm):
    # 💡 توجه: فیلدها را دوباره تعریف کردیم تا help_text به فارسی باشد
    old_password = forms.CharField(
        label='رمز عبور فعلی', strip=False, widget=forms.PasswordInput(attrs={'class': 'form-control'}),
    )
    new_password1 = forms.CharField(
        label='رمز عبور جدید', strip=False, widget=forms.PasswordInput(attrs={'class': 'form-control'}),
        help_text='رمز عبور حداقل ۱۰ کاراکتر داشته باشد.',
    )
    new_password2 = forms.CharField(
        label='تکرار رمز عبور جدید', strip=False, widget=forms.PasswordInput(attrs={'class': 'form-control'}),
        help_text='رمز عبور جدید خود را دوباره وارد کنید.',
    )

    def clean_new_password2(self):
        new_password2 = self.cleaned_data.get('new_password2')
        new_password1 = self.cleaned_data.get('new_password1')

        # 1. اعتبارسنجی داخلی جنگو (ترجمه پیام‌ها)
        try:
            validate_password(new_password2, self.user)
        except ValidationError as e:
            persian_errors = {
                "Your password can’t be too similar to your other personal information.": 'رمز عبور شما نباید بیش از حد شبیه به اطلاعات شخصی دیگرتان باشد.',
                "This password is too short. It must contain at least 10 characters.": 'رمز عبور باید حداقل ۱۰ کاراکتر داشته باشد.',
                "This password is too common.": 'این رمز عبور، یک رمز عبور متداول و ضعیف است. لطفاً از رمز قوی‌تری استفاده کنید.',
                "This password is entirely numeric.": 'رمز عبور نباید کاملاً عددی باشد.',
            }
            translated_messages = [persian_errors.get(message, message) for message in e.messages]
            raise ValidationError(translated_messages)

        # 2. خطای عدم تطابق رمز عبور
        if new_password1 and new_password2 and new_password1 != new_password2:
            # 💡 مهم: خطا را مستقیماً پرتاب می‌کنیم تا زیر فیلد new_password2 نمایش داده شود
            raise ValidationError('رمزهای عبور جدید با هم مطابقت ندارند.')

        return new_password2

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # مطمئن شوید تمام فیلدها کلاس 'form-control' را دارند
        for name, field in self.fields.items():
            field.widget.attrs['class'] = 'form-control'


class EmployeeImportForm(forms.Form):
    # نوع فایل را روی FileField تنظیم می‌کنیم
    excel_file = forms.FileField(
        label='انتخاب فایل اکسل (.xlsx)',
        widget=forms.FileInput(attrs={'class': 'form-control'}),
        help_text='فایل باید شامل ستون‌های national_id, first_name, last_name, phone_number, subdepartments_list, roles_list, password باشد.'
    )