FROM python:3.9-alpine

MAINTAINER Jeff Thorne

#setup env
ENV FLASK_APP=flasky.py
ENV FLASK_DEBUG=1
ENV FLASK_ENV=default
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
WORKDIR /app
EXPOSE 8088
ENTRYPOINT ["flask"]
CMD ["run", "--host", "0.0.0.0", "--port", "8088"]

COPY Pipfile Pipfile.lock ./

RUN apk --update add python3-dev 
RUN pip install pipenv 
RUN pipenv install --deploy --system 
#RUN apk del gcc python3-dev libressl-dev
#RUN pip uninstall pipenv -y


COPY app /app

#RUN pipenv install PyYAML==5.3.1

RUN pipenv install PyYAML==5.4
RUN addgroup -g 1000 -S web && adduser -u 1000 -S web -G web
USER web


COPY base.html /app/app/templates/



