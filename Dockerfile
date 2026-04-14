FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system-level packages
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Django dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Node / Tailwind
COPY package.json package-lock.json ./
RUN npm ci

# Project files
COPY . .

# Build minify CSS and collectstatic
RUN npm run minify && python manage.py collectstatic --noinput --verbosity 3 || (echo "=== COLLECTSTATIC FAILED ===" && exit 1)
EXPOSE 8000

# Daphne (ASGI)
CMD sh -c "python manage.py migrate && daphne -b 0.0.0.0 -p $PORT _core.asgi:application"