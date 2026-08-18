FROM python:3.11-slim
WORKDIR /app
COPY swarali-web-app.py .
RUN pip install flask
EXPOSE 5000
CMD ["python","swarali-web-app.py"]