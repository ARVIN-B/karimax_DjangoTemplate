from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("users", "0117_rename_users_back_job_id_8b9d9c_idx_users_backg_job_id_0f8173_idx_and_more"),
    ]

    operations = [
        migrations.AddField(
            model_name="backgroundjob",
            name="message_id",
            field=models.CharField(blank=True, db_index=True, max_length=128, null=True),
        ),
        migrations.AddField(
            model_name="backgroundjob",
            name="queue",
            field=models.CharField(blank=True, max_length=120, null=True),
        ),
        migrations.AddField(
            model_name="backgroundjob",
            name="correlation_id",
            field=models.CharField(blank=True, db_index=True, max_length=128, null=True),
        ),
        migrations.AddField(
            model_name="backgroundjob",
            name="worker_hostname",
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
    ]
