#!/bin/bash
#
# Version    | 22.03c
# Email      | support@pfelk.com
# Website    | https://pfelk.com
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
###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                   pfELK - Install Required Templates                                                                            #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################
#
### component>>template>>pfelk-mappings-ecs
wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-mappings-ecs -P /tmp/pfELK/templates && cat /tmp/pfELK/templates/pfelk-mappings-ecs | sed '1d' > /tmp/pfELK/templates/pfelk-mappings-ecs.3tmp && curl -X PUT -H "Content-Type: application/json" -d @/tmp/pfELK/templates/pfelk-mappings-ecs.3tmp localhost:9200/_component_template/pfelk-mappings-ecs?pretty

### ilm>>pfelk 
wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-ilm -P /tmp/pfELK/templates && cat /tmp/pfELK/templates/pfelk-ilm | sed '1d' > /tmp/pfELK/templates/pfelk-ilm.3tmp && curl -X PUT -H "Content-Type: application/json" -d @/tmp/pfELK/templates/pfelk-ilm.3tmp localhost:9200/_ilm/policy/pfelk?pretty

### index>>template>>pfelk
wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk -P /tmp/pfELK/templates && cat /tmp/pfELK/templates/pfelk | sed '1d' > /tmp/pfELK/templates/pfelk.3tmp && curl -X PUT -H "Content-Type: application/json" -d @/tmp/pfELK/templates/pfelk.3tmp localhost:9200/_index_template/pfelk?pretty

### index>>template>>pfelk-dhcp
wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-dhcp -P /tmp/pfELK/templates && cat /tmp/pfELK/templates/pfelk-dhcp | sed '1d' > /tmp/pfELK/templates/pfelk-dhcp.3tmp && curl -X PUT -H "Content-Type: application/json" -d @/tmp/pfELK/templates/pfelk-dhcp.3tmp localhost:9200/_index_template/pfelk-dhcp?pretty

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                   pfELK - Optional Templates                                                                                    #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

### index>>template>>pfelk-haproxy
wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-haproxy -P /tmp/pfELK/templates && cat /tmp/pfELK/templates/pfelk-haproxy | sed '1d' > /tmp/pfELK/templates/pfelk-haproxy.3tmp && curl -X PUT -H "Content-Type: application/json" -d @/tmp/pfELK/templates/pfelk-haproxy.3tmp localhost:9200/_index_template/pfelk-haproxy?pretty

### index>>template>>pfelk-nginx
wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-nginx -P /tmp/pfELK/templates && cat /tmp/pfELK/templates/pfelk-nginx | sed '1d' > /tmp/pfELK/templates/pfelk-nginx.3tmp && curl -X PUT -H "Content-Type: application/json" -d @/tmp/pfELK/templates/pfelk-nginx.3tmp localhost:9200/_index_template/pfelk-nginx?pretty

### pfelk-suricata
wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-suricata -P /tmp/pfELK/templates && cat /tmp/pfELK/templates/pfelk-suricata | sed '1d' > /tmp/pfELK/templates/pfelk-suricata.3tmp && curl -X PUT -H "Content-Type: application/json" -d @/tmp/pfELK/templates/pfelk-suricata.3tmp localhost:9200/_index_template/pfelk-suricata?pretty
