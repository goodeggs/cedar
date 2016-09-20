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

ENTRYPOINT ["/start"]
CMD ["/bin/bash"]

USER app
ENV HOME /app
WORKDIR /app

ONBUILD ARG RANCH_BUILD_ENV

ONBUILD COPY . /build

ONBUILD RUN sudo mkdir -p /cache && \
  sudo chown -R app /buildkit /build /cache && \
  /usr/bin/build /build /cache && \
  sudo rm -rf /app && \
  sudo mv /build /app

