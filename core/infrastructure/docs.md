# Background Infrastructure

This package provides a technology-agnostic foundation for cache and queue based background processing.

## Design

- Application code depends on abstract contracts only.
- Concrete backends are selected via settings and factories.
- Serialization is safe JSON only.
- The in-memory backend is suitable for tests.

## Settings

Configure the selected backends in `pmss/settings.py`:

```python
BACKGROUND_CACHE = "redis"
BACKGROUND_QUEUE = "celery"
BACKGROUND_CACHE_ALIAS = "default"
BACKGROUND_QUEUE_NAMESPACE = "background"
BACKGROUND_CACHE_TTL_SECONDS = 300
BACKGROUND_QUEUE_POLL_INTERVAL_SECONDS = 0.2
CELERY_BROKER_URL = "redis://localhost:6379/0"
CELERY_RESULT_BACKEND = "redis://localhost:6379/1"
CELERY_TASK_DEFAULT_QUEUE = "background"
CELERY_TASK_SERIALIZER = "json"
CELERY_RESULT_SERIALIZER = "json"
CELERY_ACCEPT_CONTENT = ["json"]
CELERY_TASK_DEFAULT_RETRY_DELAY_SECONDS = 5
CELERY_TASK_MAX_RETRIES = 5
CELERY_TASK_SOFT_TIME_LIMIT_SECONDS = 300
CELERY_TASK_TIME_LIMIT_SECONDS = 330
CELERY_WORKER_PREFETCH_MULTIPLIER = 1
CELERY_WORKER_CONCURRENCY = 1
CELERY_BROKER_TRANSPORT_OPTIONS_VISIBILITY_TIMEOUT = 3600
BACKGROUND_JOB_RETENTION_DAYS = 30
REDIS_CACHE_URL = "redis://localhost:6379/2"
```

## Celery Integration

- `pmss/celery.py` creates the Celery application and loads Django settings.
- `core.infrastructure.queue.celery.CeleryQueueBackend` publishes JSON-only job payloads to Celery, with Redis as the broker.
- `core.infrastructure.tasks.cleanup_expired_background_jobs` removes completed job metadata after the retention window.
- The application layer still talks to the queue abstraction, not Celery directly.

## Extending

Register a new backend in the relevant factory registry and point the setting to the new name.

## Worker lifecycle

Workers consume a batch, deserialize payloads, execute handlers, and acknowledge or retry messages.
