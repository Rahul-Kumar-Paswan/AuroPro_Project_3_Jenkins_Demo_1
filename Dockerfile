FROM python
COPY . /app
WORKDIR /app
RUN python setup.py sdist bdist_wheel
RUN pip install -r requirements.txt
RUN pip install dist/flask_app-*.tar.gz  
RUN pip install dist/flask_app-*.whl  
EXPOSE  5000
# Define environment variables
ENV MYSQL_HOST=mysql
ENV MYSQL_USER=root
ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=my_db
CMD ["python", "-m" ,"app"]