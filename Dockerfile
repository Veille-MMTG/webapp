FROM python:3.11

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the application files to the container
COPY . /app

# Install the application dependencies
RUN pip install --no-cache-dir -r requirements.txt && \ 
    chmod +x /app/start.sh

# Set the environment variables
ENV FLASK_APP=app.py
ENV FLASK_DEBUG=0

# Start the application server using Gunicorn
ENTRYPOINT ["/app/start.sh"]
