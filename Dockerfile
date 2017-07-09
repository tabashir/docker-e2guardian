FROM alpine as builder
WORKDIR /root/buid
RUN apk add --update autoconf automake gcc cmake
RUN apk add g++
RUN apk add zlib zlib-dev
RUN apk add pcre2 pcre2-dev
RUN apk add build-base gcc abuild binutils binutils-doc gcc-doc
RUN apk add pcre pcre-dev
COPY v4.1.2.tar.gz .
RUN tar zxvf v4.1.2.tar.gz && cd e2guardian-4.1.2 && ./autogen.sh && ./configure --prefix=/opt/e2guardian && make && make install

FROM alpine
MAINTAINER vincent@vin0x64.fr
WORKDIR /
RUN apk add --update pcre libgcc libstdc++ && \
	rm -rf /var/cache/apk/*
COPY --from=builder /opt/e2guardian/ /opt/e2guardian
RUN chmod a+rw /opt/e2guardian/var/log/e2guardian
COPY entrypoint.sh /sbin/
EXPOSE 8081/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]
