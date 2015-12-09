FROM heroku/cedar:14

COPY bin/build /usr/bin/build
COPY bin/profile /usr/bin/profile
COPY bin/start /usr/bin/start
COPY buildkit /buildkit

ENV CURL_TIMEOUT 600
ENV STACK cedar-14

RUN apt-get -y update && apt-get install -y sudo && apt-get clean && \
    adduser --disabled-password --gecos '' --ingroup sudo app && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ONBUILD ENTRYPOINT ["/usr/bin/profile"]

ONBUILD EXPOSE 3000
ONBUILD ENV PORT 3000

ONBUILD USER app
ONBUILD ENV HOME /app
ONBUILD WORKDIR /app

ONBUILD COPY . /build

ONBUILD RUN sudo mkdir -p /cache && \
  sudo chown -R app /build /cache && \
  /usr/bin/build /build /cache && \
  sudo rm -rf /app && \
  sudo mv /build /app

