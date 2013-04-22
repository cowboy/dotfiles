# IP addresses
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"
alias whois="whois -h whois-servers.net"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

# View HTTP traffic
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Renew DHCP
alias renewdhcp="sudo ipconfig set en0 DHCP"

# ssh to a dev machine.
s() {
    local SSH_TARGET=$1; if [[ -z $SSH_TARGET ]]; then SSH_TARGET="dev"; fi
    sc $SSH_TARGET
}


