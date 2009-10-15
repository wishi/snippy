#! /bin/zsh

## MacOS ipfw setup script for initial launchd startup
#  agent. Use Lingon to set that up ;). It rocks.
#  Do not just copy these rules. 

ipfw flush

# Use " " as a separator for other DHCPs
DHCP=(192.168.1.1) 

# stateful packet inspection
/sbin/ipfw add 00100 check-state

# loopback interface allowed by default (lo*)
/sbin/ipfw add 01000 allow all from any to any via lo0

# deny spoofing loopback
/sbin/ipfw add 01100 deny all from any to 127.0.0.0/8 in
/sbin/ipfw add 01110 deny all from 127.0.0.0/8 to any in

# stateful inspection add state
/sbin/ipfw add 01200 allow ip from me to any out keep-state

# DHCP
i=1

while [ $i -le ${#DHCP} ] ; do
   /sbin/ipfw add 0200$i allow log udp from 0.0.0.0 68 to 255.255.255.255 67 out
   /sbin/ipfw add 0201$i allow log udp from $DHCP[$i] 67 to 255.255.255.255 68 in 
   i=$i+1
 done


# ipfw add deny ip from 224.0.0.0/3 to any in
# ipfw add deny tcp from any to 224.0.0.0/3 in

ipfw add allow ip from any to me dst-port 20, 21, 22, 80, 443 in

ipfw add allow tcp from any to any out
ipfw add allow tcp from any to any established
ipfw add deny ip from any to any ipoptions rr
ipfw add deny ip from any to any ipoptions ts
ipfw add deny ip from any to any ipoptions lsrr
ipfw add deny ip from any to any ipoptions ssrr
ipfw add deny tcp from any to any tcpflags syn,fin
ipfw add deny tcp from any to any tcpflags syn,rst
ipfw add deny tcp from any 0 to any
ipfw add deny tcp from any to any dst-port 0
ipfw add deny udp from any 0 to any
ipfw add deny udp from any to any dst-port 0

# ipfw add deny ip from 224.0.0.0/4 to any in
# ipfw add deny ip from 0.0.0.0/8 to any

ipfw add deny tcp from any to any
ipfw add allow ip from any to any

# log ping  
/sbin/ipfw add 60000 allow log icmp from any to me icmptypes 8

# not a server box
/sbin/ipfw add 65000 deny log tcp from any to any 
/sbin/ipfw add 65001 deny log udp from any to any 
/sbin/ipfw add 65002 deny log igmp from any to any 
/sbin/ipfw add 65003 deny log icmp from any to any 
/sbin/ipfw add 65500 deny log ip from any to any

# define interface for throttle:
INTERFACE=en0

# define max-speed
MAXSPEED=46080

# ipfw rule number (1-65535)
# Rule 00070 allows throttled to coexist with the apple firewall
# and internet connection sharing.
# You may have to change this if you use certain firewall products.
RULENUM=00070

# usage: throttled [-ATLh] -s speed -r rule [-d port] [-p priority] [-i increment]
# -s speed        Max speed in bytes/second (required)
# -r rule         IPFW rule number to remove when quit (required)
# -i increment    Amount to change the throttle in bytes/sec (based on signal USR1 and USR2)
# -A              Disable ACK packet priority (not recommended)
# -L              Throttle local network (192.168.x.x and 10.x.x.x)
# -T              Enable iTunes TTL fix
# -h              This help screen
# -v              Version information
# -d port         Divert port (optional, may specify more than one)
#         -p priority     Priority for the divert port specified prior to this option.

# launch throttled with a maxspeed of $MAXSPEED
# this throttled instance has 2 priorities, this allows us to prioritize low
# bandwidth services.
# You will understand this more when you look how the rules are setup below.
# /usr/local/sbin/throttled -s $MAXSPEED -r $RULENUM -d 17778 -p 1 -d 17777 -p 2 -T || exit

# all rules below are for ipfw, there is many ways you can set this up.
# we have simplified this for new users by removing ip specific ipfw rules.
# this fixes isses for dynamic ip users, but if you want rules bound to
# a single ip you can use either of the examples below.
#
# the line below finds your ip automatically
IP=$(/sbin/ifconfig $INTERFACE inet | /usr/bin/sed -n 's/^.*inet\ \(\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\).*/\1/p' | tail -n 1) 
#
# you can also specify the ip address by doing
# IP=192.168.1.7
# IP=any

# ssh
#/sbin/ipfw add $RULENUM divert 17778 tcp from $IP 22 to any out xmit $INTERFACE
#/sbin/ipfw add $RULENUM divert 17778 tcp from $IP to any 22 out xmit $INTERFACE

# HTTP
#/sbin/ipfw add $RULENUM divert 17778 tcp from $IP 80 to any out xmit $INTERFACE
#/sbin/ipfw add $RULENUM divert 17778 tcp from $IP to any 80 out xmit $INTERFACE

# Catch All Rule
#/sbin/ipfw add $RULENUM divert 17777 ip from $IP to any out xmit $INTERFACE
