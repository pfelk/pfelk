echo "pfELK: Generating pfELK Error Data"
printf "$(uname -srm)\n$(cat /etc/os-release)\n" | cat >> /data/pfELK/error.pfelk
find /data/ | cat >> /data/pfELK/error.pfelk
cat /data/pfELK/filters/*.conf >> /data/pfELK/error.pfelk 
tail -20 /data/pfELK/logs/logstash-plain.log | cat >> /data/pfELK/test.pfelk
java -version | cat >> /data/pfELK/test.pfelk
journalctl -u elasticsearch -n 50 | cat >> /data/pfELK/error.pfelk
systemctl status logstash.service -q | cat >> /data/pfELK/error.pfelk
systemctl status kibana.service -q | cat >> /data/pfELK/error.pfelk
