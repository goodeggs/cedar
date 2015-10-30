FROM heroku/cedar:14

COPY bin/build /usr/bin/build
COPY bin/profile /usr/bin/profile
COPY buildkit /buildkit

ENV CURL_TIMEOUT 600
ENV STACK cedar-14

RUN apt-get -y update && apt-get install -y sudo && apt-get clean && \
    adduser --disabled-password --gecos '' --ingroup sudo app && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ONBUILD ENTRYPOINT ["/usr/bin/profile"]

ONBUILD EXPOSE 3000
ONBUILD ENV PORT 3000
ONBUILD ENV HOME /app

ONBUILD COPY . /build

ONBUILD RUN mkdir -p /cache && \
  /usr/bin/build /build /cache && \
  rm -rf /app && \
  mv /build /app && \
  chown -R app /app

ONBUILD USER app
ONBUILD WORKDIR /app
