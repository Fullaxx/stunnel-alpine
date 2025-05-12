#!/bin/ash

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
cfgadd()
{
  FILEPATH="/certs/$2"
  if [ ! -r ${FILEPATH} ]; then
    bail "${FILEPATH} is not readable!"
  fi
  echo "$1 = ${FILEPATH}" >>${CONFIG}
}

if [ -n "${CERTFILE}" ]; then
  cfgadd "cert" "${CERTFILE}"
fi

if [ -n "${KEYFILE}" ]; then
  cfgadd "key" "${KEYFILE}"
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

# Debugging/Logging
echo "foreground = yes" >>${CONFIG}
if [ -n "${DEBUG}" ]; then
  echo "debug = ${DEBUG}" >>${CONFIG}
fi
if [ -n "${LOGFILE}" ]; then
  chown stunnel:stunnel /log
  echo "output = /log/${LOGFILE}" >>${CONFIG}
fi

# Service-level configuration
echo "[server]" >>${CONFIG}
echo "accept = ${ACCEPT}" >>${CONFIG}
echo "connect = ${CONNECT}" >>${CONFIG}
echo "TIMEOUTclose = 0" >>${CONFIG}

mkdir /run/stunnel
chown stunnel:stunnel /run/stunnel
exec /usr/bin/stunnel ${CONFIG}
