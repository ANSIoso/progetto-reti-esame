iptables -F
iptables -X

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# GREEN può creare connessioni verso tutti
iptables -N green_all
iptables -N all_green

iptables -A FORWARD -i eth0 -s 10.0.0.0/23 -j green_all
iptables -A FORWARD -o eth0 -d 10.0.0.0/23 -j all_green

iptables -A green_all -j ACCEPT
iptables -A all_green -m state --state ESTABILISHED,RELATED -j ACCEPT

# DMZ può aprire connessioni solo verso red

iptables -N dmz_red
iptables -N red_dmz

iptables -A FORWARD -i eth1 -o eth2 -s 10.0.3.0/26 -d 10.0.2.0/24 -j dmz_red
iptables -A FORWARD -i eth2 -o eth1 -s 10.0.2.0/24 -d 10.0.3.0/26 -j red_dmz

iptables -A dmz_red -j ACCEPT
iptables -A red_dmz -m state --state ESTABILISHED,RELATED -j ACCEPT

# le DMZ devono permettere di accedere ai servizi  (53 dns, 25 smtp, 21 ftp)
iptables -A FORWARD -o eth2 -d 10.0.3.0/26 -p tcp --match multiport --dports 53,25,21 -j ACCEPT