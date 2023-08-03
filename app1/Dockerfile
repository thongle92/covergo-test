FROM python:alpine
COPY app.py requirements.txt /
RUN pip install -r requirements.txt
EXPOSE 8282
CMD ["python", "app.py"]
