import os

# لاگ در پوشه پروژه
log_dir = os.path.join(os.path.dirname(__file__), "var/logs/gunicorn")
os.makedirs(log_dir, exist_ok=True)

bind = "127.0.0.1:8000"
workers = 4
timeout = 14400
wsgi_app = "pmss.wsgi:application"

accesslog = os.path.join(log_dir, "access.log")
errorlog = os.path.join(log_dir, "error.log")
loglevel = "info"
