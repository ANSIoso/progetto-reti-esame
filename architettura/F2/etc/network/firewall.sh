#!/usr/bin/sh

iptable -F
iptable -X

iptable INPUT DROP
iptable OUTPUT DROP
iptable FORWARD DROP

iptable -N green_all
iptable -N all_green

iptable -A FORWARD -s 10.0.0.0/23 -i eth0 -j green_all
iptable -A FORWARD -d 10.0.0.0/23 -o eth0 -j all_green

iptable -A green_all ACCEPT
iptable -A -m state --state ESTABLISHED,RELATED all_green ACCEPT

iptable -N dmz_red
iptable -N red_dmz

iptable -A FORWARD -s 10.0.3.0/26 -i eth1 -d 10.0.2.0/24 -o eth2 -j dmz_red
iptable -A FORWARD -s 10.0.2.0/24 -i eth2 -d 10.0.3.0/26 -o eth1 -j red_dmz

iptable -A dmz_red ACCEPT
iptable -A red_dmz -m state --state ESTABLISHED, RELATED ACCEPT