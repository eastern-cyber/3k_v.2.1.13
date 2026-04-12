FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Run migrations and start gunicorn
CMD python manage.py migrate --noinput && \
    gunicorn _core.wsgi:application --bind 0.0.0.0:${PORT:-8000} --workers 2 --timeout 120
