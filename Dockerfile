# Use an official Python runtime as a parent image
FROM python:3.11-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy requirements.txt into the container
COPY requirements.txt ./

# Install any needed packages specified in requirements.txt
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        musl-dev \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del .build-deps

# Use a lightweight base image
FROM python:3.11-alpine

# Set the working directory
WORKDIR /app

# Copy only the necessary files needed for production
COPY app.py requirements.txt ./

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Create a non-root user to run the application
RUN adduser --disabled-password --gecos "" myuser
USER myuser

# Copy the installed packages from the builder image
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

# Use Waitress to run the application
CMD ["waitress-serve", "--port=80", "app:app"]
