FROM jeffthorne/python:3.7-slim
MAINTAINER Jeff Thorne

ENV FLASK_APP=flasky.py
ENV FLASK_DEBUG=1
ENV FLASK_ENV=default
WORKDIR /app
EXPOSE 8088
ENTRYPOINT ["flask"]
CMD ["run", "--host", "0.0.0.0", "--port", "8088"]

#RUN apt-get update



ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

#COPY app/requirements.txt /
##RUN pip install -r /requirements.txt
COPY app /app


#RUN pip install PyYAML==5.1b5
#RUN pip install PyYAML==3.12
#COPY base.html /app/app/templates/



