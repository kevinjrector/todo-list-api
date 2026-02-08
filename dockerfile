FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Create a non-root user for security
RUN addgroup --system app \
    && adduser --system --ingroup app --home /home/app app

# Minimal system deps (keep lean; add build tools only if needed later)
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python deps first (better layer caching)
COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

# Copy only source code into the image
COPY src/ /app/src/

# Make "app.*" importable (since your code is in /app/src/app)
ENV PYTHONPATH=/app/src

USER app

EXPOSE 8000

# Default runtime (Compose can override to add --reload)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
