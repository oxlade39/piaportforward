#!/bin/ash

exitOnError(){
  # $1 must be set to $?
  status=$1
  message=$2
  [ "$message" != "" ] || message="Error!"
  if [ $status != 0 ]; then
    printf "$message (status $status)\n"
    exit $status
  fi
}

cat "/etc/openvpn/pia/$REGION.ovpn" &> /dev/null
exitOnError $? "/etc/openvpn/pia/$REGION.ovpn is not accessible"

CONNECTIONSTRING=$(grep -i "/etc/openvpn/pia/$REGION.ovpn" -e 'privateinternetaccess.com')
exitOnError $?
PORT=$(echo $CONNECTIONSTRING | cut -d' ' -f3)
if [ "$PORT" = "" ]; then
  printf "Port not found in /etc/openvpn/pia/$REGION.ovpn\n"
  exit 1
fi
PIADOMAIN=$(echo $CONNECTIONSTRING | cut -d' ' -f2)
if [ "$PIADOMAIN" = "" ]; then
  printf "Domain not found in /etc/openvpn/pia/$REGION.ovpn\n"
  exit 1
fi

echo "using remote ${PIADOMAIN} ${PORT}"

echo "remote ${PIADOMAIN} ${PORT}" > /etc/openvpn/pia/remote.conf

openvpn --config /etc/openvpn/pia/proto.conf  --config  /etc/openvpn/pia/pia.conf --config /etc/openvpn/pia/remote.conf
