FROM alpine as builder
WORKDIR /root/buid
RUN apk add --update autoconf automake gcc cmake g++ zlib zlib-dev pcre2 pcre2-dev build-base gcc abuild binutils binutils-doc gcc-doc pcre pcre-dev git openssl-dev
RUN git clone https://github.com/e2guardian/e2guardian.git && \
	cd e2guardian && ./autogen.sh && \
	 ./configure --prefix=/opt/e2guardian --enable-sslmitm=yes --enable-email=yes --enable-pcre=yes && \
	make && make install

FROM alpine
MAINTAINER vincent@vin0x64.fr
WORKDIR /
RUN apk add --update pcre libgcc libstdc++ rsync && \
	rm -rf /var/cache/apk/*
COPY --from=builder /opt/e2guardian/ /opt/e2guardian
RUN chmod a+rw /opt/e2guardian/var/log/e2guardian
RUN mkdir -p /etc/e2guardian/ssl/generatedcerts
RUN chmod a+rw /etc/e2guardian/ssl/generatedcerts


RUN echo "cacertificatepath = '/etc/e2guardian/ssl/my_rootCA.crt'" >> /opt/e2guardian/etc/e2guardian/e2guardianf1.conf 
RUN echo "caprivatekeypath = '/etc/e2guardian/ssl/private_root.pem'" >> /opt/e2guardian/etc/e2guardian/e2guardianf1.conf 
RUN echo "certprivatekeypath = '/etc/e2guardian/ssl/private_cert.pem'" >> /opt/e2guardian/etc/e2guardian/e2guardianf1.conf 
RUN echo "generatedcertpath = '/etc/e2guardian/ssl/generatedcerts'" >> /opt/e2guardian/etc/e2guardian/e2guardianf1.conf 
RUN echo "sslmitm = on" >> /opt/e2guardian/etc/e2guardian/e2guardianf1.conf 
RUN echo "enablessl = on" >> /opt/e2guardian/etc/e2guardian/e2guardian.conf 

RUN rsync -avP /opt/e2guardian/etc/e2guardian/ /opt/e2guardian/original_etc/

WORKDIR /opt/e2guardian/original_ssl
RUN apk add --update openssl
RUN openssl genrsa 4096 > private_root.pem
RUN openssl req -new -x509 -days 3650 -key private_root.pem -out my_rootCA.crt -subj "/C=UK/O=E2Guardian"
RUN openssl x509 -in my_rootCA.crt -outform DER -out my_rootCA.der
RUN openssl genrsa 4096 > private_cert.pem

WORKDIR /
COPY entrypoint.sh /sbin/
EXPOSE 8080/tcp
EXPOSE 8081/tcp
EXPOSE 8443/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]
