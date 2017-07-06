FROM ubuntu

LABEL net.codepoints.version="0.1"

# Add tini
ENV TINI_VERSION v0.15.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Install dependencies
RUN apt update && apt upgrade -y && apt install -y \
    apt-utils \
    bc \
    bsdtar \
    curl \
    fontforge \
    jq \
    libcurl3-gnutls \
    libmariadb-client-lgpl-dev \
    libmariadb-client-lgpl-dev-compat \
    libsaxonb-java \
    make \
    mariadb-client \
    mariadb-server \
    openjdk-9-jre \
    python3 \
    python3-pip \
    virtualenv

# set up infrastructure
RUN service mysql start
RUN mkdir -p /u2m/cache

ENV LANG C.UTF-8

COPY bin/* /u2m/bin/
COPY data/* /u2m/data/
COPY Makefile /u2m/Makefile
COPY requirements.txt /u2m/requirements.txt
COPY sql/* /u2m/sql/

RUN chmod +x /bin/*
RUN ln -s /usr/bin/mariadb_config /usr/bin/mysql_config

# make virtualenv
RUN virtualenv --python=/usr/bin/python3 /u2m/virtualenv
RUN /u2m/virtualenv/bin/pip install -r /u2m/requirements.txt
RUN /u2m/virtualenv/bin/python -m nltk.downloader wordnet stopwords

WORKDIR /u2m
CMD service mysql start && make -j -O
