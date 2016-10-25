FROM buildpack-deps:trusty

ENV LC_ALL=C
ENV CURL_TIMEOUT=600 STACK=cedar-14

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

ENTRYPOINT ["/start"]
CMD ["/bin/bash"]

USER app
ENV HOME /app
WORKDIR /app

ONBUILD ARG RANCH_BUILD_ENV

ONBUILD COPY . /app

ONBUILD RUN sudo mkdir -p /cache && \
  sudo chown -R app /buildkit /app /cache && \
  /usr/bin/build /app /cache

