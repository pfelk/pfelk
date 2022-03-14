#!/bin/bash
#
# Version    | 22.04
# Email      | https://github.com/pfelk/pfelk
#
###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                           Color Codes                                                                                           #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################
#

# Set if using Secure Elasticsearch setup with SSL
# PFELK_DOCKER_HOME=
# PASSWORD=

function install_template(){
  if [ -n "$PFELK_DOCKER_HOME" ]; then
     wget "https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/$1" -P /tmp/pfELK/templates && cat "/tmp/pfELK/templates/$1" | sed '1d' > "/tmp/pfELK/templates/$1.3tmp"
     curl -X PUT -H "Content-Type: application/json" -d "@/tmp/pfELK/templates/$1.3tmp" "https://localhost:9200/$2/$1?pretty" -u "elastic:$PASSWORD" --cacert "$PFELK_DOCKER_HOME/certs/ca/ca.crt"
  else
     wget "https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/$1" -P /tmp/pfELK/templates && cat "/tmp/pfELK/templates/$1" | sed '1d' > "/tmp/pfELK/templates/$1.3tmp"
     curl -X PUT -H "Content-Type: application/json" -d "@/tmp/pfELK/templates/$1.3tmp" "localhost:9200/$2/$1?pretty"
  fi
}

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
install_template pfelk-mappings-ecs _component_template

### ilm>>pfelk
install_template pfelk-ilm '_ilm/policy'

### index>>template>>pfelk
install_template pfelk _index_template

### index>>template>>pfelk-dhcp
install_template pfelk-dhcp _index_template

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                   pfELK - Optional Templates                                                                                    #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

### index>>template>>pfelk-haproxy
# install_template pfelk-haproxy _index_template

### index>>template>>pfelk-nginx
# install_template pfelk-nginx _index_template

### pfelk-suricata
# install_template pfelk-suricata _index_template
