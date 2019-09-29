#!/bin/sh
ETC_DIR='/opt/e2guardian/etc/e2guardian'
SSL_DIR='/etc/e2guardian/ssl'

if [ ! -d "$ETC_DIR" ]; then
   mkdir -p "$ETC_DIR"
fi

if [ "$(find "$ETC_DIR" -type f |wc -l)" -lt 1 ]; then
   echo "Fresh installation, populating lists volume"
   rsync -avP /opt/e2guardian/original_etc/ "${ETC_DIR}/"
else
   echo "lists volume already populated"
fi

if [ ! -d "$SSL_DIR" ]; then
   mkdir -p "$SSL_DIR"
fi

if [ "$(find "$SSL_DIR" -type f |wc -l)" -lt 1 ]; then
   echo "Fresh installation, populating SSL volume"
   rsync -avP /opt/e2guardian/original_ssl/ "${SSL_DIR}/"
else
   echo "SSL volume already populated"
fi

SQUID_CACHE_DIR=/var/spool/squid/

/opt/e2guardian/sbin/e2guardian 
tail -f /opt/e2guardian/var/log/e2guardian/access.log
