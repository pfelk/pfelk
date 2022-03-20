#!/bin/bash
#
# Version    | 22.02
# Email      | https://github.com/pfelk/pfelk
#
###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                           Color Codes                                                                                           #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################
#
RESET='\033[0m'
WHITE_R='\033[39m'
RED='\033[1;31m' # Light Red.
GREEN='\033[1;32m' # Light Green.
#
header() {
  clear
  clear
  echo -e "${GREEN}#####################################################################################################${RESET}\\n"
}

header_red() {
  clear
  clear
  echo -e "${RED}#####################################################################################################${RESET}\\n"
}
#
# Check for root (sudo)
if [[ "$EUID" -ne 0 ]]; then
  header_red
  echo -e "${WHITE_R}#${RESET} The script need to be run as root...\\n\\n"
  echo -e "${WHITE_R}#${RESET} For Ubuntu based systems run the command below to login as root"
  echo -e "${GREEN}#${RESET} sudo -i\\n"
  echo -e "${WHITE_R}#${RESET} For Debian based systems run the command below to login as root"
  echo -e "${GREEN}#${RESET} su\\n\\n"
  exit 1
fi
#
###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                   pfELK - Download Saved Objects                                                                                #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################
wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-captive.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-dhcp.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.04-firewall.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-haproxy.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-nginx.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-snort.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-squid.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-suricata.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-unbound.ndjson -P /tmp/pfELK/
###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                   pfELK - Installing Saved Objects                                                                              #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/22.01-captive.ndjson -H 'kbn-xsrf: true' -u elastic:PASSWORDGOESHERE
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/22.01-dhcp.ndjson -H 'kbn-xsrf: true' -u elastic:PASSWORDGOESHERE
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/22.04-firewall.ndjson -H 'kbn-xsrf: true' -u elastic:PASSWORDGOESHERE
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/22.01-haproxy.ndjson -H 'kbn-xsrf: true' -u elastic:PASSWORDGOESHERE
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/22.01-nginx.ndjson -H 'kbn-xsrf: true' -u elastic:PASSWORDGOESHERE
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/22.01-snort.ndjson -H 'kbn-xsrf: true' -u elastic:PASSWORDGOESHERE
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/22.01-squid.ndjson -H 'kbn-xsrf: true' -u elastic:PASSWORDGOESHERE
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/22.01-suricata.ndjson -H 'kbn-xsrf: true' -u elastic:PASSWORDGOESHERE
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/22.01-unbound.ndjson -H 'kbn-xsrf: true' -u elastic:PASSWORDGOESHERE
