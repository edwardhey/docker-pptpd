#!/bin/sh

set -e

echo "$username\t*\t$password\t*" > /etc/ppp/chap-secrets

# enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# configure firewall
iptables -A INPUT -i ppp+ -j ACCEPT
iptables -A OUTPUT -o ppp+ -j ACCEPT
iptables -A INPUT -p tcp --dport 1723 -j ACCEPT
iptables -A INPUT -p 47 -j ACCEPT
iptables -A OUTPUT -p 47 -j ACCEPT
iptables -F FORWARD
iptables -A FORWARD -j ACCEPT
iptables -A POSTROUTING -t nat -o $interface -j MASQUERADE
iptables -A POSTROUTING -t nat -o ppp+ -j MASQUERADE

exec "$@"
