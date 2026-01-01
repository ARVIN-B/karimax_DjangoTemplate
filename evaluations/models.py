from django.db import models
from users.models import Employee

class EvaluationCriteria(models.Model):
    name = models.CharField(max_length=100, verbose_name="نام معیار")
    description = models.TextField(blank=True, verbose_name="توضیحات")
    weight = models.FloatField(default=1.0, verbose_name="وزن")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="تاریخ ایجاد")
    
    class Meta:
        verbose_name = "معیار ارزیابی"
        verbose_name_plural = "معیارهای ارزیابی"
    
    def __str__(self):
        return self.name

class EmployeeEvaluation(models.Model):
    employee = models.ForeignKey(Employee, on_delete=models.CASCADE, related_name='evaluations', verbose_name="کارمند")
    evaluator = models.ForeignKey(Employee, on_delete=models.SET_NULL, null=True, related_name='given_evaluations', verbose_name="ارزیاب")
    criteria = models.ForeignKey(EvaluationCriteria, on_delete=models.CASCADE, related_name='evaluations', verbose_name="معیار")
    comments = models.TextField(blank=True, verbose_name="نظرات")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="تاریخ ایجاد")
    
    class Meta:
        verbose_name = "ارزیابی کارمند"
        verbose_name_plural = "ارزیابی‌های کارمند"
    
    def __str__(self):
        return f"ارزیابی {self.employee.full_name} - {self.criteria.name}"

class EvaluationScore(models.Model):
    evaluation = models.ForeignKey(EmployeeEvaluation, on_delete=models.CASCADE, related_name='scores', verbose_name="ارزیابی")
    score = models.FloatField(verbose_name="امتیاز")
    scored_by = models.ForeignKey(Employee, on_delete=models.SET_NULL, null=True, related_name='given_scores', verbose_name="امتیازدهنده")
    comments = models.TextField(blank=True, verbose_name="نظرات")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="تاریخ ایجاد")
    
    class Meta:
        verbose_name = "امتیاز ارزیابی"
        verbose_name_plural = "امتیازات ارزیابی"
    
    def __str__(self):
        return f"امتیاز {self.score} برای {self.evaluation}"