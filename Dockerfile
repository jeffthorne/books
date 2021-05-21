FROM python:3.7-slim as base
MAINTAINER Jeff Thorne

#setup env
ENV FLASK_APP=flasky.py
ENV FLASK_DEBUG=1
ENV FLASK_ENV=default
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends gcc
RUN pip install pipenv

FROM base AS python-deps




WORKDIR /app
EXPOSE 8088
ENTRYPOINT ["flask"]
CMD ["run", "--host", "0.0.0.0", "--port", "8088"]


COPY Pipfile /
RUN pipenv install
COPY app /app


#RUN pip install PyYAML==5.1b5
#RUN pip install PyYAML==3.12
COPY base.html /app/app/templates/



