#!/bin/sh

SQUID_CACHE_DIR=/var/spool/squid/

/opt/e2guardian/sbin/e2guardian 
tail -f /opt/e2guardian/var/log/e2guardian/access.log
