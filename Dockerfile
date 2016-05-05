FROM heroku/cedar:14

RUN apt-get -y update && \
    apt-get install -y sudo jq && \
    apt-get clean && \
    adduser --disabled-password --gecos '' --ingroup sudo app && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY bin/start /start
COPY bin/build /usr/bin/build
COPY bin/profile /usr/bin/profile
COPY buildkit /buildkit

ENV CURL_TIMEOUT 600
ENV STACK cedar-14

