#!/bin/bash

# Run migrations
python manage.py migrate --noinput

# Start gunicorn
exec gunicorn _core.wsgi:application --bind 0.0.0.0:${PORT:-8000} --workers 2 --timeout 120 --access-logfile -