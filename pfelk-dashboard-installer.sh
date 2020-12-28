#!/bin/bash
#
# Version    | 0.1
# Email      | support@pfelk.com
# Website    | https://pfelk.3ilson.dev | https://pfelk.com
#
###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                   pfELK - Download Saved Objects                                                                                #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################
wget -q https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/v6.1%20-%20DHCP.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/v6.1%20-%20Firewall.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/v6.1%20-%20HAProxy.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/v6.1%20-%20Snort.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/v6.1%20-%20Squid.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/v6.1%20-%20Suricata.ndjson -P /tmp/pfELK/
wget -q https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/v6.1%20-%20Unbound.ndjson -P /tmp/pfELK/
###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                   pfELK - Installing Saved Objects                                                                              #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/DHCP.ndjson -H 'kbn-xsrf: true'
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/Firewall.ndjson -H 'kbn-xsrf: true'
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/HAProxy.ndjson -H 'kbn-xsrf: true'
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/Snort.ndjson -H 'kbn-xsrf: true'
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/Squid.ndjson -H 'kbn-xsrf: true'
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/Suricata.ndjson -H 'kbn-xsrf: true'
curl -X POST localhost:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/pfELK/Unbound.ndjson -H 'kbn-xsrf: true'
