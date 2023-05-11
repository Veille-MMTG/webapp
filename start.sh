#!/bin/sh

# Exit script if any command fails
set -e

# Run the application
exec gunicorn -b 0.0.0.0:${PORT:-80} app:app
