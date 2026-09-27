FROM ubuntu:26.04

LABEL net.codepoints.unicode2mysql.version="18.0"

ENV LANG=C.UTF-8
ENV TARGET=all
WORKDIR /app

RUN <<EOF
    apt-get update
    apt-get install -y \
        apt-utils \
        bc \
        libarchive-tools \
        curl \
        jq \
        libcurl3-gnutls \
        libmariadb-dev \
        libmariadb-dev-compat \
        libsaxonb-java \
        make \
        openjdk-25-jre \
        pkg-config \
        python3 \
        python3-pip \
        tini \
        virtualenv
    /usr/bin/virtualenv --python=/usr/bin/python3 /virtualenv
EOF

COPY --from=node:26-slim /usr/local/bin/node /usr/local/bin/node
COPY --from=node:26-slim /usr/local/bin/npm /usr/local/bin/npm
COPY --from=node:26-slim /usr/local/lib/node_modules /usr/local/lib/node_modules

# prepare virtualenv
COPY requirements.txt /requirements.txt
RUN /virtualenv/bin/pip install -r /requirements.txt

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD sleep 5 && make -j -O PYTHON=/virtualenv/bin/python "$TARGET"
