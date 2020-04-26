echo "pfELK: Generating pfELK Error Data"
#remove any old pfelk error outputs
sudo rm /data/pfELK/error.pfelk
#create the new file
sudo touch /data/pfELK/error.pfelk
#add system information
echo "#####################################" >> /data/pfELK/error.pfelk
echo "# pfELK System Information ##########" >> /data/pfELK/error.pfelk
echo "#####################################\n" >> /data/pfELK/error.pfelk
printf "$(uname -srm)\n$(cat /etc/os-release)\n" | cat >> /data/pfELK/error.pfelk
#capture directory and files structure
echo "\n#####################################" >> /data/pfELK/error.pfelk
echo "# Listing pfELK Directory Structure #" >> /data/pfELK/error.pfelk
echo "#####################################\n" >> /data/pfELK/error.pfelk
find /data/ | cat >> /data/pfELK/error.pfelk
#capture all config files
echo "\n#####################################" >> /data/pfELK/error.pfelk
echo "# pfELK Config File Details #########" >> /data/pfELK/error.pfelk
echo "#####################################\n" >> /data/pfELK/error.pfelk
cat /data/pfELK/configurations/*.conf >> /data/pfELK/error.pfelk
#attach logstash logs
echo "\n#####################################" >> /data/pfELK/error.pfelk
echo "# Appending Logstash Logs ###########" >> /data/pfELK/error.pfelk
echo "#####################################\n" >> /data/pfELK/error.pfelk
tail -20 /data/pfELK/logs/logstash-plain.log | cat >> /data/pfELK/error.pfelk
#attach Java version
echo "\n#####################################" >> /data/pfELK/error.pfelk
echo "# Java Version ######################" >> /data/pfELK/error.pfelk
echo "#####################################\n" >> /data/pfELK/error.pfelk
java -version 2>> /data/pfELK/error.pfelk
#capture systemctl status outputs to validate services running
echo "\n#####################################" >> /data/pfELK/error.pfelk
echo "# ELK Services Check ################" >> /data/pfELK/error.pfelk
echo "#####################################\n" >> /data/pfELK/error.pfelk
echo "\n###Elasticsearch.service:###\n" >> /data/pfELK/error.pfelk
systemctl status elasticsearch.service -q | cat >> /data/pfELK/error.pfelk
echo "\n###Logstash.service:###\n" >> /data/pfELK/error.pfelk
systemctl status logstash.service -q | cat >> /data/pfELK/error.pfelk
echo "\n###Kibana.service:###\n" >> /data/pfELK/error.pfelk
systemctl status kibana.service -q | cat >> /data/pfELK/error.pfelk
echo "Error Data Collected Successfully"
echo "Attach or Copy the contents of /data/pfELK/error.pfelk to your Issue"
