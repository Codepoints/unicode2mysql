FROM ubuntu

LABEL net.codepoints.version="0.1"

ENV LANG C.UTF-8
WORKDIR /app

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD service mariadb start && make -j -O PYTHON=/virtualenv/bin/python

RUN <<EOF
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt update
    apt install -y \
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
        mariadb-client \
        mariadb-server \
        nodejs \
        pkg-config \
        python3 \
        python3-pip \
        tini \
        virtualenv
    ln -s /usr/bin/mariadb_config /usr/bin/mysql_config
    /usr/bin/virtualenv --python=/usr/bin/python3 /virtualenv
EOF

# prepare virtualenv
COPY requirements.txt /requirements.txt
RUN /virtualenv/bin/pip install -r /requirements.txt
