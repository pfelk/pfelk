echo "pfELK: Generating pfELK Error Data"
#remove any old pfelk error outputs
sudo rm /data/pfELK/error.pfelk.log
#create the new file
sudo touch /data/pfELK/error.pfelk.log
#add system information
echo "#####################################" >> /data/pfELK/error.pfelk.log
echo "# pfELK System Information ##########" >> /data/pfELK/error.pfelk.log
echo "#####################################\n" >> /data/pfELK/error.pfelk.log
printf "$(uname -srm)\n$(cat /etc/os-release)\n" | cat >> /data/pfELK/error.pfelk.log
#capture directory and files structure
echo "\n#####################################" >> /data/pfELK/error.pfelk.log
echo "# Listing pfELK Directory Structure #" >> /data/pfELK/error.pfelk.log
echo "#####################################\n" >> /data/pfELK/error.pfelk.log
find /data/ | cat >> /data/pfELK/error.pfelk.log
#capture all config files
echo "\n#####################################" >> /data/pfELK/error.pfelk.log
echo "# pfELK Config File Details #########" >> /data/pfELK/error.pfelk.log
echo "#####################################\n" >> /data/pfELK/error.pfelk.log
cat /data/pfELK/configurations/*.conf >> /data/pfELK/error.pfelk.log
cat /etc/logstash/pipelines.yml >> /data/pfELK/error.pfelk.log
cat /etc/logstash/logstash.yml | grep path.logs* >> /data/pfELK/error.pfelk.log
#attach logstash logs
echo "\n#####################################" >> /data/pfELK/error.pfelk.log
echo "# Appending Logstash Logs ###########" >> /data/pfELK/error.pfelk.log
echo "#####################################\n" >> /data/pfELK/error.pfelk.log
tail -20 /data/pfELK/logs/logstash-plain.log | cat >> /data/pfELK/error.pfelk.log
#attach Java version
echo "\n#####################################" >> /data/pfELK/error.pfelk.log
echo "# Java Version ######################" >> /data/pfELK/error.pfelk.log
echo "#####################################\n" >> /data/pfELK/error.pfelk.log
java -version 2>> /data/pfELK/error.pfelk.log
#capture systemctl status outputs to validate services running
echo "\n#####################################" >> /data/pfELK/error.pfelk.log
echo "# ELK Services Check ################" >> /data/pfELK/error.pfelk.log
echo "#####################################\n" >> /data/pfELK/error.pfelk.log
echo "\n###Elasticsearch.service:###\n" >> /data/pfELK/error.pfelk.log
systemctl status elasticsearch.service -q | cat >> /data/pfELK/error.pfelk.log
echo "\n###Logstash.service:###\n" >> /data/pfELK/error.pfelk.log
systemctl status logstash.service -q | cat >> /data/pfELK/error.pfelk.log
echo "\n###Kibana.service:###\n" >> /data/pfELK/error.pfelk.log
systemctl status kibana.service -q | cat >> /data/pfELK/error.pfelk.log
echo "Error Data Collected Successfully"
echo "Attach the contents of /data/pfELK/error.pfelk.log as a file to your Issue in github"
