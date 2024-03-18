FROM ubuntu:23.10

LABEL net.codepoints.unicode2mysql.version="15.1"

ENV LANG C.UTF-8
ENV TARGET all
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
        pkg-config \
        python3 \
        python3-pip \
        tini \
        virtualenv
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
    /usr/bin/virtualenv --python=/usr/bin/python3 /virtualenv
    curl -fsSL https://get.docker.com | bash -
EOF

# prepare virtualenv
COPY requirements.txt /requirements.txt
RUN /virtualenv/bin/pip install -r /requirements.txt

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD sleep 5 && make -j -O PYTHON=/virtualenv/bin/python "$TARGET"
