#!/bin/bash
tunctl -g netdev -t tap0

ifconfig tap0 10.0.3.72
ifconfig tap0 netmask 255.255.255.252
ifconfig broadcast 10.0.3.75

ifconfig tap0 up

iptables -t -A POSTROUTING -o wifi0 -j MASQUERADE

iptables -A FORWARD -i tap0 -j ACCEPT 

sysctl -w net.ipv4.ip_forward=1

route add -net 10.0.3.0/26 gw 10.0.3.74 dev tap0
route add -net 10.0.2.0/24 gw 10.0.3.74 dev tap0
route add -net 10.0.0.0/23 gw 10.0.3.74 dev tap0