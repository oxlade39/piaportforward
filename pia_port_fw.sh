#!/bin/ash
# Get forward port info from PIA server

client_id=$(head -n 100 /dev/urandom | sha256sum | tr -d " -")
url="http://209.222.18.222:2000/?client_id=$client_id"

echo "Making port forward request..."
sleep 1
#curl --interface $(cat /tmp/vpnint) $url 2>/dev/null > /tmp/vpnportfwhttp
#wget -qO- http://209.222.18.222:2000/?client_id=$client_id
curl $url 2>/dev/null > /tmp/vpnportfwhttp

if [ $? -eq 0 ]; then
  port_fw=$(grep -o '[0-9]\+' /tmp/vpnportfwhttp)
  [ -f /tmp/vpnportfw ] && rm /tmp/vpnportfw
  echo $port_fw > /tmp/vpnportfw
  echo "Forwarded port is $port_fw"
  echo "Forwarded port is in file /tmp/vpnportfw"
else
  echo "Curl failed to get forwarded PIA port in some way"
  exit 1
fi
