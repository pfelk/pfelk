echo "pfELK: Generating pfELK Error Data"
#create log folder
sudo mkdir /etc/pfELK/logs
#remove any old pfelk error outputs
sudo rm /etc/pfELK/logs/error.pfelk.log
#create the new file
sudo touch /etc/pfELK/logs/error.pfelk.log
#add system information
echo "#####################################" >> /etc/pfELK/logs/error.pfelk.log
echo "# pfELK System Information ##########" >> /etc/pfELK/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfELK/logs/error.pfelk.log
printf "$(uname -srm)\n$(cat /etc/os-release)\n$(free -hm)\n" | cat >> /etc/pfELK/logs/error.pfelk.log
#capture directory and files structure
echo "\n#####################################" >> /etc/pfELK/logs/error.pfelk.log
echo "# Listing pfELK Directory Structure #" >> /etc/pfELK/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfELK/logs/error.pfelk.log
find /etc/logstash/ | cat >> /etc/pfELK/logs/error.pfelk.log
#capture all config files
echo "\n#####################################" >> /etc/pfELK/logs/error.pfelk.log
echo "# pfELK Config File Details #########" >> /etc/pfELK/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfELK/logs/error.pfelk.log
cat /etc/logstash/conf.d/*.conf >> /etc/pfELK/logs/error.pfelk.log
echo "\n#####################################" >> /etc/pfELK/logs/error.pfelk.log
echo "# Listing Logstash Pipelines.yml #" >> /etc/pfELK/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfELK/logs/error.pfelk.log
cat /etc/logstash/pipelines.yml >> /etc/pfELK/logs/error.pfelk.log
echo "\n#####################################" >> /etc/pfELK/logs/error.pfelk.log
echo "# Listing Logstash Logstash.yml Log Path #" >> /etc/pfELK/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfELK/logs/error.pfelk.log
cat /etc/logstash/logstash.yml | grep path.logs* >> /etc/pfELK/logs/error.pfelk.log
#attach logstash logs
echo "\n#####################################" >> /etc/pfELK/logs/error.pfelk.log
echo "# Appending Logstash Logs ###########" >> /etc/pfELK/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfELK/logs/error.pfelk.log
tail -20 /var/log/logstash/logstash-plain.log | cat >> /etc/pfELK/logs/error.pfelk.log
#attach Java version
echo "\n#####################################" >> /etc/pfELK/logs/error.pfelk.log
echo "# Java Version ######################" >> /etc/pfELK/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfELK/logs/error.pfelk.log
java -version 2>> /etc/pfELK/logs/error.pfelk.log
#capture systemctl status outputs to validate services running
echo "\n#####################################" >> /etc/pfELK/logs/error.pfelk.log
echo "# ELK Services Check ################" >> /etc/pfELK/logs/error.pfelk.log
echo "#####################################\n" >> /etc/pfELK/logs/error.pfelk.log
echo "\n###Elasticsearch.service:###\n" >> /etc/pfELK/logs/error.pfelk.log
systemctl status elasticsearch.service -q | cat >> /etc/pfELK/logs/error.pfelk.log
echo "\n###Logstash.service:###\n" >> /etc/pfELK/logs/error.pfelk.log
systemctl status logstash.service -q | cat >> /etc/pfELK/logs/error.pfelk.log
echo "\n###Kibana.service:###\n" >> /etc/pfELK/logs/error.pfelk.log
systemctl status kibana.service -q | cat >> /etc/pfELK/logs/error.pfelk.log
echo "Error Data Collected Successfully"
echo "Attach the contents of /etc/pfELK/logs/error.pfelk.log as a file to attache and include with your issue in github"
