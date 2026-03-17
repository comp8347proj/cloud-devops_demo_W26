# 1. Base image: official Python image
FROM python:3.12-slim

# 2. Avoid Python writing .pyc files and make output unbuffered (good for logs)
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Set working directory inside the container
WORKDIR /app

# 4. Install system dependencies (optional, simple case – skip extra libs)
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 5. Copy requirements and install Python deps
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copy the rest of the project into the container
COPY . /app/

# 7. Expose port 8000 (Django dev server)
#EXPOSE 8000
ENV PORT=8000


# 8. Command to run the app in the container
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
CMD gunicorn mysite.wsgi:application --bind 0.0.0.0:${PORT}

