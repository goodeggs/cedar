FROM heroku/cedar:14

RUN apt-get -y update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:vbernat/haproxy-1.6 && \
    apt-get -y update && \
    apt-get install -y haproxy sudo && \
    apt-get clean && \
    adduser --disabled-password --gecos '' --ingroup sudo app && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY bin/start /start
COPY bin/build /usr/bin/build
COPY bin/profile /usr/bin/profile
COPY bin/gen-cert /usr/bin/gen-cert
COPY bin/web /usr/bin/web
COPY buildkit /buildkit
COPY conf/haproxy.cfg /etc/cedar/haproxy.cfg

ENV CURL_TIMEOUT 600
ENV STACK cedar-14

