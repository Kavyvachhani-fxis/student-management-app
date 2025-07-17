FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /code

# Install system dependencies required by psycopg2 and Pillow
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    build-essential \
    python3-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies (no requirements.txt)
RUN pip install --no-cache-dir \
    Django==3.1.1 \
    mysql-connector==2.2.9 \
    virtualenv==20.0.31 \
    dj-database-url==0.5.0 \
    gunicorn==20.0.4 \
    psycopg2-binary==2.9.9 \
    whitenoise==5.2.0 \
    Pillow==7.2.0 \
    requests==2.24.0

COPY . .

RUN python manage.py collectstatic --noinput || echo "collectstatic skipped"

CMD ["gunicorn", "student_management_system.wsgi:application", "--bind", "0.0.0.0:8000"]
