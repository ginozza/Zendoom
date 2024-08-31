#!/bin/bash

MAX_CONNECTIONS=100
TIME_WINDOW=10
BAN_DURATION=600
LOG_FILE="/var/log/zendoom.log"
BLOCKED_IPS_FILE="/var/log/zendoom_blocked_ips.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_activity() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

detect_ddos() {
  netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | while read count ip; do
    if [ "$count" -gt "$MAX_CONNECTIONS" ]; then
      log_activity "Possible DDoS attack detected from $ip with $count connections."
      if ! iptables -L INPUT -v -n | grep -q "$ip"; then
        iptables -A INPUT -s $ip -j DROP
        echo "$ip" >>$BLOCKED_IPS_FILE
        log_activity "IP $ip blocked for $BAN_DURATION seconds."
        (
          sleep $BAN_DURATION
          unblock_ip $ip
        ) &
      fi
    fi
  done
}

unblock_ip() {
  ip=$1
  iptables -D INPUT -s $ip -j DROP
  sed -i "/$ip/d" $BLOCKED_IPS_FILE
  log_activity "IP $ip unblocked."
}

list_blocked_ips() {
  echo -e "${YELLOW}Currently blocked IPs:${NC}"
  cat $BLOCKED_IPS_FILE
}

show_logs() {
  less $LOG_FILE
}

show_help() {
  echo -e "${GREEN}zendoom${NC} - A powerful CLI for mitigating DDoS attacks"
  echo ""
  echo "Usage: zendoom [command] [options]"
  echo ""
  echo "Commands:"
  echo "  start               Starts DDoS detection with the current parameters"
  echo "  set-max <num>       Sets the maximum number of connections allowed per IP (default: 100)"
  echo "  set-window <num>    Sets the time window in seconds for counting connections (default: 10)"
  echo "  set-ban <num>       Sets the ban duration in seconds (default: 600)"
  echo "  list                Lists the currently blocked IPs"
  echo "  unblock <ip>        Manually unblocks a specific IP"
  echo "  logs                Displays the activity logs"
  echo "  help                Displays this help message"
  echo ""
  echo "Examples:"
  echo "  zendoom start"
  echo "  zendoom set-max 150"
  echo "  zendoom unblock 192.168.1.100"
}

case $1 in
start)
  echo -e "${GREEN}Starting zendoom with the following parameters:${NC}"
  echo "  Max Connections: $MAX_CONNECTIONS"
  echo "  Time Window: $TIME_WINDOW seconds"
  echo "  Ban Duration: $BAN_DURATION seconds"
  while true; do
    detect_ddos
    sleep $TIME_WINDOW
  done
  ;;
set-max)
  if [ -n "$2" ]; then
    MAX_CONNECTIONS=$2
    echo -e "${GREEN}Max Connections updated to $MAX_CONNECTIONS${NC}"
  else
    echo -e "${RED}Please provide a valid number for Max Connections.${NC}"
  fi
  ;;
set-window)
  if [ -n "$2" ]; then
    TIME_WINDOW=$2
    echo -e "${GREEN}Time Window updated to $TIME_WINDOW seconds${NC}"
  else
    echo -e "${RED}Please provide a valid number for Time Window.${NC}"
  fi
  ;;
set-ban)
  if [ -n "$2" ]; then
    BAN_DURATION=$2
    echo -e "${GREEN}Ban Duration updated to $BAN_DURATION seconds${NC}"
  else
    echo -e "${RED}Please provide a valid number for Ban Duration.${NC}"
  fi
  ;;
list)
  list_blocked_ips
  ;;
unblock)
  if [ -n "$2" ]; then
    unblock_ip $2
  else
    echo -e "${RED}Please provide a valid IP to unblock.${NC}"
  fi
  ;;
logs)
  show_logs
  ;;
help | *)
  show_help
  ;;
esac
