from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.core.exceptions import PermissionDenied
from .models import EvaluationCriteria, EmployeeEvaluation, EvaluationScore
from users.models import Employee, Department
from django.db.models import Avg, Count

@login_required
def criteria_list(request):
    if not request.user.has_perm('evaluations.can_manage_criteria'):
        raise PermissionDenied("شما اجازه مدیریت معیارها را ندارید.")
    criteria = EvaluationCriteria.objects.all()
    return render(request, 'evaluations/criteria_list.html', {'criteria': criteria})

@login_required
def criteria_create(request):
    if not request.user.has_perm('evaluations.can_manage_criteria'):
        raise PermissionDenied("شما اجازه افزودن معیار را ندارید.")
    if request.method == 'POST':
        name = request.POST.get('name')
        description = request.POST.get('description')
        weight = request.POST.get('weight')
        if name and weight:
            EvaluationCriteria.objects.create(name=name, description=description, weight=weight)
            messages.success(request, 'معیار با موفقیت اضافه شد.')
            return redirect('evaluations:criteria_list')
        else:
            messages.error(request, 'لطفاً تمام فیلدها را پر کنید.')
    return render(request, 'evaluations/criteria_create.html', {})

@login_required
def criteria_detail(request, pk):
    if not request.user.has_perm('evaluations.can_manage_criteria'):
        raise PermissionDenied("شما اجازه مشاهده جزئیات معیار را ندارید.")
    criterion = get_object_or_404(EvaluationCriteria, pk=pk)
    return render(request, 'evaluations/criteria_detail.html', {'criterion': criterion})

@login_required
def employee_evaluation(request, employee_id):
    if not request.user.can_evaluate:
        raise PermissionDenied("شما اجازه ارزیابی پرسنل را ندارید.")
    employee = get_object_or_404(Employee, id=employee_id)
    if request.method == 'POST':
        criteria_id = request.POST.get('criteria_id')
        score = request.POST.get('score')
        comments = request.POST.get('comments')
        if criteria_id and score:
            criteria = get_object_or_404(EvaluationCriteria, id=criteria_id)
            EmployeeEvaluation.objects.create(
                employee=employee,
                evaluator=request.user,
                criteria=criteria,
                comments=comments
            )
            EvaluationScore.objects.create(
                evaluation=EmployeeEvaluation.objects.last(),
                score=score,
                scored_by=request.user
            )
            messages.success(request, 'ارزیابی با موفقیت ثبت شد.')
            return redirect('evaluations:employee_evaluation', employee_id=employee_id)
        else:
            messages.error(request, 'لطفاً تمام فیلدها را پر کنید.')
    criteria = EvaluationCriteria.objects.all()
    evaluations = EmployeeEvaluation.objects.filter(employee=employee).select_related('criteria')
    return render(request, 'evaluations/employee_evaluation.html', {
        'employee': employee,
        'criteria': criteria,
        'evaluations': evaluations
    })

@login_required
def evaluation_reports(request):
    if not request.user.can_view_reports:
        raise PermissionDenied("شما اجازه مشاهده گزارش‌ها را ندارید.")
    department = request.user.department if not request.user.can_access_all_departments else None
    evaluations = EmployeeEvaluation.objects.all().select_related('employee', 'criteria')
    if department:
        evaluations = evaluations.filter(employee__department=department)
    report_data = evaluations.aggregate(
        avg_score=Avg('evaluationscore__score'),
        total_evaluations=Count('id')
    )
    return render(request, 'evaluations/evaluation_reports.html', {
        'report_data': report_data,
        'evaluations': evaluations
    })