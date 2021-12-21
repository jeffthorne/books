FROM 192.168.1.41:5000/log4shell-vulnerable-app:v1

LABEL maintainer="Jeff Thorne jeff.thorne@lacework.net"

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






#RUN pipenv install PyYAML==5.4
#RUN addgroup -g 1000 -S web && adduser -u 1000 -S web -G web
#USER web


COPY base.html /app/app/templates/


