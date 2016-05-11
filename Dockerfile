FROM buildpack-deps:trusty

RUN apt-get update && apt-get install -y --no-install-recommends \
      sudo \
      ruby \
      jq \
    && rm -rf /var/lib/apt/lists/* \
    && adduser --disabled-password --gecos '' --ingroup sudo app \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && ln -s /usr/bin/start /start

COPY bin/* /usr/bin/
COPY buildkit /buildkit

ENV CURL_TIMEOUT=600 STACK=cedar-14

