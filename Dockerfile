FROM python:3.11-slim

WORKDIR /app

# Copy your app
COPY swarali-web-app.py .

# Install dependencies
RUN pip install --no-cache-dir flask

# Expose port
EXPOSE 5000

# Run app
CMD ["python", "swarali-web-app.py"]