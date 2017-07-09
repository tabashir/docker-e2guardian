FROM alpine as builder
WORKDIR /root/buid
RUN apk add --update autoconf automake gcc cmake g++ zlib zlib-dev pcre2 pcre2-dev build-base gcc abuild binutils binutils-doc gcc-doc pcre pcre-dev git
RUN git clone https://github.com/e2guardian/e2guardian.git && \
	cd e2guardian && ./autogen.sh && ./configure --prefix=/opt/e2guardian && make && make install

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
