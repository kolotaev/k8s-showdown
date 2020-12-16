FROM python:alpine3.7

RUN pip install flask
COPY server.py server.py
EXPOSE 8080
CMD ["python", "server.py"]
