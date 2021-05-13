#!/bin/bash
git add . &&  \
git commit -m "$1" && \
git push -u origin master && \
curl -u admin:784d1438399ff46927afc30de5107f4f https://jenkins.lacework.cloud/job/jeffsbooks/build?token=getgoing
