# PRODUCTION VALIDATION & FINAL INTEGRATION TASK

## Context

You are taking over an existing Django project that already contains a background processing infrastructure.

The original goal of this infrastructure is:

> **Run Speech-to-Text conversion completely in the background using Celery and Redis, without blocking the user request.**

The intended user flow is:

```
User uploads an audio file

↓

User clicks "Convert to Text"

↓

The View immediately returns

↓

Participation status becomes WAITING

↓

A Background Job is created

↓

Celery Worker receives the job

↓

The Dispatcher executes

↓

The TranscriptionHandler runs

↓

Speech-to-Text converts the audio

↓

Participation.text_content is updated

↓

Participation.status changes to user_review

↓

When the user refreshes the dashboard, the converted text is available.
```

This is the only success criterion.

If this workflow does not work from beginning to end, the task is NOT complete.

---

# IMPORTANT

Do NOT assume the existing implementation is correct.

Your first responsibility is to audit every modification made since the last Git commit.

Review ALL uncommitted changes.

Especially review:

* users/views.py
* process_participation()
* enqueue_transcription_job()
* BackgroundJobService
* Dispatcher
* QueueFactory
* Celery Queue Backend
* Handler Registry
* TranscriptionHandler
* Dashboard
* Job Status updates

If any implementation is incorrect, incomplete, introduces technical debt, or breaks the intended workflow, fix it.

Do not preserve incorrect code just because it was recently written.

---

# Step 1 — Git Review

Compare the current working tree against the latest commit.

Review every modified file.

For every changed file determine:

* Why it was changed
* Whether it is correct
* Whether it introduces architectural problems
* Whether it breaks existing behaviour
* Whether it should be refactored
* Whether it should be reverted

Pay special attention to:

```
users/views.py
```

The View must remain extremely thin.

The View should only:

* validate request
* enqueue background job
* update participation status
* redirect

It must never contain business logic.

---

# Step 2 — Verify Infrastructure

Audit the complete execution chain.

```
HTTP Request

↓

View

↓

BackgroundJobService

↓

QueueFactory

↓

Queue Backend

↓

Redis

↓

Celery

↓

Worker

↓

Dispatcher

↓

Handler Registry

↓

TranscriptionHandler

↓

Speech Service

↓

Database

↓

Dashboard
```

Do not assume any layer works.

Verify every layer individually.

---

# Step 3 — Redis

Verify Redis is actually installed.

Verify Redis is running.

Verify Celery connects to Redis.

Verify the broker.

Verify the result backend.

Verify queue persistence.

If Redis is not running:

Stop.

Do not continue implementing code.

Instead:

* explain the problem
* start the required services (if possible)
* configure Redis correctly
* verify connectivity

---

# Step 4 — Celery

Verify:

* Worker starts correctly
* Worker registers tasks
* Worker receives jobs
* Worker executes jobs
* Worker acknowledges jobs

Execute:

```
celery -A pmss inspect registered

celery -A pmss inspect active_queues

celery -A pmss report
```

Verify the output.

If tasks are missing, fix task discovery.

If queue names differ, fix routing.

---

# Step 5 — Execute a REAL Job

Do not rely only on unit tests.

Create a real Participation.

Upload a real audio file.

Click:

```
Convert To Text
```

Observe every stage.

Verify:

BackgroundJob created

↓

Participation.status == WAITING

↓

Worker receives task

↓

Dispatcher executes

↓

Handler executes

↓

Speech Service runs

↓

Database updated

↓

Dashboard displays converted text

If any stage fails, stop and fix it before continuing.

---

# Step 6 — Debug the Entire Pipeline

If the job remains stuck in WAITING:

Determine exactly where execution stops.

Examples:

* Queue.publish()

* Redis

* Celery Worker

* Dispatcher

* Registry

* Handler

* Speech Service

* Database update

Do not guess.

Use logs.

Trace the execution.

Find the exact failing layer.

Fix only the real root cause.

---

# Step 7 — Validate Dashboard

Refresh the dashboard.

Verify state transitions:

WAITING

↓

RUNNING

↓

SUCCESS

or

FAILED

Ensure the UI reflects the real backend state.

---

# Step 8 — Logging

Confirm that logs exist for:

Task Submitted

Task Received

Dispatcher Started

Dispatcher Finished

Handler Started

Handler Finished

Speech Started

Speech Finished

Database Updated

Retry

Failure

Execution Time

Job ID

Participation ID

Worker

Queue

Message ID

---

# Step 9 — Production Verification

The task is NOT complete until all of the following are proven by execution:

✓ Redis is running.

✓ Celery is connected.

✓ Worker receives jobs.

✓ Dispatcher executes.

✓ Handler executes.

✓ Speech-to-Text converts a real audio file.

✓ Database is updated.

✓ Dashboard shows the converted text.

✓ Refreshing the page continues the workflow correctly.

---

# Final Report

Provide:

1. Every issue found.
2. Every issue fixed.
3. Files modified.
4. Git diff summary.
5. Redis status.
6. Celery status.
7. Worker status.
8. Queue status.
9. Logs proving one successful transcription.
10. Any remaining production risks.

Do not claim success unless a REAL audio file has been converted successfully through the complete background pipeline.
