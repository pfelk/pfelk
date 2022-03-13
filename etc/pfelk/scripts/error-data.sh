# Version    | 22.04
# Email      | https://github.com/pfelk/pfelk
#
echo "pfelk: Generating pfelk Error Data"
#create log folder
sudo mkdir /etc/pfelk/logs
#remove any old pfelk error outputs
sudo rm /etc/pfelk/logs/error.pfelk.log
#create the new file
sudo touch /etc/pfelk/logs/error.pfelk.log
#add system information
echo "#####################################" >> /etc/pfelk/logs/error.pfelk.log
echo "# pfelk System Information ##########" >> /etc/pfelk/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfelk/logs/error.pfelk.log
printf "$(uname -srm)\n$(cat /etc/os-release)\n$(free -hm)\n" | cat >> /etc/pfelk/logs/error.pfelk.log
#capture directory and files structure
echo "\n#####################################" >> /etc/pfelk/logs/error.pfelk.log
echo "# Listing pfelk Directory Structure #" >> /etc/pfelk/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfelk/logs/error.pfelk.log
find /etc/pfelk/ | cat >> /etc/pfelk/logs/error.pfelk.log
find /etc/logstash/ | cat >> /etc/pfelk/logs/error.pfelk.log
find /var/lib/GeoIP/ | cat >> /etc/pfelk/logs/error.pfelk.log
#capture all config files
echo "\n#####################################" >> /etc/pfelk/logs/error.pfelk.log
echo "# pfelk Config File Details #########" >> /etc/pfelk/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfelk/logs/error.pfelk.log
cat /etc/pfelk/conf.d/*.pfelk >> /etc/pfelk/logs/error.pfelk.log
#capture all config files
echo "\n#####################################" >> /etc/pfelk/logs/error.pfelk.log
echo "# Logstash Config File Details #########" >> /etc/pfelk/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfelk/logs/error.pfelk.log
cat /etc/logstash/conf.d/*.pfelk >> /etc/pfelk/logs/error.pfelk.log
echo "\n#####################################" >> /etc/pfelk/logs/error.pfelk.log
echo "# Listing Logstash Pipelines.yml #" >> /etc/pfelk/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfelk/logs/error.pfelk.log
cat /etc/logstash/pipelines.yml >> /etc/pfelk/logs/error.pfelk.log
echo "\n#####################################" >> /etc/pfelk/logs/error.pfelk.log
echo "# Listing Logstash Logstash.yml Log Path #" >> /etc/pfelk/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfelk/logs/error.pfelk.log
cat /etc/logstash/logstash.yml | grep path.logs* >> /etc/pfelk/logs/error.pfelk.log
echo "\n#####################################" >> /etc/pfelk/logs/error.pfelk.log
echo "# Listing Kibana kibana.yml Log Path #" >> /etc/pfelk/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfelk/logs/error.pfelk.log
cat /etc/kibana/kibana.yml | grep path.logs* >> /etc/pfelk/logs/error.pfelk.log
#capture grok pattern
echo "\n#####################################" >> /etc/pfelk/logs/error.pfelk.log
echo "# grok pattern #" >> /etc/pfelk/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfelk/logs/error.pfelk.log
cat /etc/pfelk/patterns/*.grok >> /etc/pfelk/logs/error.pfelk.log
#attach logstash logs
echo "\n#####################################" >> /etc/pfelk/logs/error.pfelk.log
echo "# Appending Logstash Logs ###########" >> /etc/pfelk/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfelk/logs/error.pfelk.log
tail -20 /var/log/logstash/logstash-plain.log | cat >> /etc/pfelk/logs/error.pfelk.log
#capture systemctl status outputs to validate services running
echo "\n#####################################" >> /etc/pfelk/logs/error.pfelk.log
echo "# ELK Services Check ################" >> /etc/pfelk/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfelk/logs/error.pfelk.log
echo "\n###Elasticsearch.service:###\n" >> /etc/pfelk/logs/error.pfelk.log
systemctl status elasticsearch.service -q | cat >> /etc/pfelk/logs/error.pfelk.log
echo "\n###Logstash.service:###\n" >> /etc/pfelk/logs/error.pfelk.log
systemctl status logstash.service -q | cat >> /etc/pfelk/logs/error.pfelk.log
echo "\n###Kibana.service:###\n" >> /etc/pfelk/logs/error.pfelk.log
systemctl status kibana.service -q | cat >> /etc/pfelk/logs/error.pfelk.log
echo "Error Data Collected Successfully"
echo "Attach the contents of /etc/pfelk/logs/error.pfelk.log as a file to attache and include with your issue in github"
