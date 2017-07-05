FROM ubuntu

LABEL net.codepoints.version="0.1"

# Add tini
ENV TINI_VERSION v0.15.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Install dependencies
RUN apt update && apt upgrade -y && apt install -y \
    bc \
    bsdtar \
    curl \
    fontforge \
    jq \
    libcurl3-gnutls \
    libsaxonb-java \
    make \
    mariadb-client \
    mariadb-server \
    perl \
    python3

# set up infrastructure
RUN mkdir -p /u2m/cache
WORKDIR /u2m

COPY bin/* /u2m/bin/
COPY Makefile /u2m/Makefile
COPY sql/* /u2m/sql/

RUN chmod +x /bin/*

CMD ["make", "-j", "-O"]
