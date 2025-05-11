#!/bin/bash

bail()
{
  echo $1
  exit 1
}

if [ -z "${ACCEPT}" ]; then
  bail "ACCEPT is empty!"
fi

if [ -z "${CONNECT}" ]; then
  bail "CONNECT is empty!"
fi

CONFIG="/etc/stunnel/stunnel.conf"

# Certificate/Key is needed in server mode and optional in client mode
if [ -n "${CERTKEYFILE}" ]; then
  CERTKEYPATH="/certs/${CERTKEYFILE}"
  if [ ! -r ${CERTKEYPATH} ]; then
    bail "${CERTKEYPATH} is not readable!"
  fi
  echo "cert = ${CERTKEYPATH}" >>${CONFIG}
  echo "key = ${CERTKEYPATH}" >>${CONFIG}
elif [ -n "${CERTFILE}" ] && [ -n "${KEYFILE}" ]; then
  CERTPATH="/certs/${CERTFILE}"
  KEYPATH="/certs/${KEYFILE}"
  if [ ! -r ${CERTPATH} ]; then
    bail "${CERTPATH} is not readable!"
  fi
  if [ ! -r ${KEYPATH} ]; then
    bail "${KEYPATH} is not readable!"
  fi
  echo "cert = ${CERTPATH}" >>${CONFIG}
  echo "key = ${KEYPATH}" >>${CONFIG}
else
  bail "Unknown Configuration!"
fi

# Security
if [ "${RUNSTUNNELASROOT}" == "1" ]; then
  echo "setuid = root" >>${CONFIG}
  echo "setgid = root" >>${CONFIG}
else
  echo "setuid = stunnel" >>${CONFIG}
  echo "setgid = stunnel" >>${CONFIG}
fi
echo "pid = /run/stunnel/stunnel.pid" >>${CONFIG}

# Some performance tunings
echo "socket = l:TCP_NODELAY=1" >>${CONFIG}
echo "socket = r:TCP_NODELAY=1" >>${CONFIG}

# Some debugging stuff useful for troubleshooting
echo "foreground = yes" >>${CONFIG}
#echo "debug = 7" >>${CONFIG}
#echo "output = stunnel.log" >>${CONFIG}

# Service-level configuration
echo "[server]" >>${CONFIG}
echo "accept = ${ACCEPT}" >>${CONFIG}
echo "connect = ${CONNECT}" >>${CONFIG}
echo "TIMEOUTclose = 0" >>${CONFIG}

mkdir /run/stunnel
chown stunnel:stunnel /run/stunnel
exec /usr/bin/stunnel ${CONFIG}
