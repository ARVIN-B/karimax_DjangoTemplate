from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):
    dependencies = [
        ("users", "0115_orgunit_employee_alter_orgunit_unit_type"),
    ]

    operations = [
        migrations.CreateModel(
            name="BackgroundJob",
            fields=[
                ("id", models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name="ID")),
                ("job_id", models.CharField(db_index=True, max_length=64, unique=True)),
                ("handler_name", models.CharField(max_length=120)),
                ("status", models.CharField(choices=[("PENDING", "Pending"), ("WAITING", "Waiting"), ("RUNNING", "Running"), ("SUCCESS", "Success"), ("FAILED", "Failed"), ("RETRYING", "Retrying"), ("CANCELLED", "Cancelled")], default="PENDING", max_length=20)),
                ("retry_count", models.PositiveIntegerField(default=0)),
                ("error_message", models.TextField(blank=True, null=True)),
                ("created_at", models.DateTimeField(auto_now_add=True)),
                ("started_at", models.DateTimeField(blank=True, null=True)),
                ("finished_at", models.DateTimeField(blank=True, null=True)),
                ("celery_task_id", models.CharField(blank=True, db_index=True, max_length=128, null=True)),
                ("participation", models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name="background_jobs", to="users.participation")),
            ],
            options={
                "verbose_name": "Background Job",
                "verbose_name_plural": "Background Jobs",
                "indexes": [models.Index(fields=["job_id", "status"], name="users_back_job_id_8b9d9c_idx")],
            },
        ),
    ]
