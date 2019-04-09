#!/bin/ash
# script used by OpenVPN to setup a route on Linux.
# used in conjunction with OpenVPN config file options
# script-security 2, route-noexec, route-up
# script also requires route table rt2
# sudo bash -c 'echo "1 rt2" >> /etc/iproute2/rt_tables

# openvpn variables passed in via env vars
ovpnpia="/etc/openvpn/pia"
int=$dev
iplocal=$ifconfig_local
ipremote=$ifconfig_remote
gw=$route_vpn_gateway

if [ -z $int ] || [ -z $iplocal ] || [ -z $ipremote ] || [ -z $gw ]; then
  echo "No env vars found. Use this script with an OpenVPN config file "
  exit 1
fi

help() {
  echo "For setting OpenVPN routes on Linux."
  echo "Usage: $0 up or down"
}

down() {
  echo "NOOP"
}

up() {
  # using OpenVPN env vars that get set when it starts, see man page
  echo "Tunnel on interface $int. File /config/vpnint"
  echo $int > /config/vpnint
  echo "Local IP is         $iplocal. File /config/vpnip"
  echo $iplocal > /config/vpnip
  echo "Remote IP is        $ipremote"
  echo "Gateway is          $gw"

  # PIA port forwarding, only works with certain gateways
  # No US locations, closest US is Toronto and Montreal
  # no network traffic works during exec of this script
  # things like curl hang if not backgrounded
  $ovpnpia/pia_port_fw.sh &
}

case $1 in
  "up") up;;
  "down") down;;
  *) help;;
esac
