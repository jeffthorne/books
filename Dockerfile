FROM python:3.7


LABEL maintainer="Jeff Thorne jeff.thorne@lacework.net"

#setup env
ENV FLASK_APP=app.py
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
COPY app /app

#RUN pipenv install PyYAML==5.4
#RUN addgroup -g 1000 -S web && adduser -u 1000 -S web -G web
#USER web


COPY base.html /app/templates/




