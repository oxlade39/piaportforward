#!/bin/ash
# Get forward port info from PIA server

client_id=$(head -n 100 /dev/urandom | sha256sum | tr -d " -")
url="http://209.222.18.222:2000/?client_id=$client_id"

echo "Making port forward request..."
sleep 1
curl $url 2>/dev/null > /config/vpnportfwhttp

if [ $? -eq 0 ]; then
  port_fw=$(grep -o '[0-9]\+' /config/vpnportfwhttp)
  [ -f /config/vpnportfw ] && rm /config/vpnportfw
  echo $port_fw > /config/vpnportfw
  echo "Forwarded port is $port_fw"
  echo "Forwarded port is in file /config/vpnportfw"
else
  echo "Curl failed to get forwarded PIA port in some way"
fi
