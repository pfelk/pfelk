## Welcome to (pfSense/OPNsense) + Elastic Stack 

![pfelk dashboard](https://github.com/a3ilson/pfelk/raw/master/pf%2BELK.png)
You can view installation guide guide on [3ilson.org YouTube Channel](https://www.youtube.com/3ilsonorg).


### Prerequisites
- Ubuntu Server v18.04+
- pfSense v2.4.4+ or OPNsense 19.7.4+
- The following was tested with Java v13 and Elastic Stack v7.4

# Preparation

### 1. Add Oracle Java Repository
```
sudo add-apt-repository ppa:linuxuprising/java
```

### 2. Add Maxmind Repository
```
sudo add-apt-repository ppa:maxmind/ppa
```

### 3. Download and install the public GPG signing key
```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
```

### 4. Download and install apt-transport-https package
```
sudo apt-get install apt-transport-https
```

### 5. Add Elasticsearch|Logstash|Kibana Repositories (version 7+)
```
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
```

### 6. Update
```
sudo apt-get update
```

### 7. Install Java 13
```
sudo apt-get install oracle-java13-installer
```

### 8. Install Maxmind
```
sudo apt install geoipupdate
```

### 9. Configure Maxmind
```
sudo nano /etc/GeoIP.conf
```
- Modify line 13 as follows:
```
EditionIDs GeoLite2-City GeoLite2-Country GeoLite2-ASN
```

### 8. Download Maxmind Databases
```
sudo geoipupdate
```

### 9. Add cron (automatically updates Maxmind everyweek on Sunday at 1700hrs)
```
sudo nano /etc/cron.weekly/geoipupdate
```
- Add the following and save/exit
```
00 17 * * 0 geoipupdate
```

# Install
- Elasticsearch v7+ | Kibana v7+ | Logstash v7+

### 10. Install Elasticsearch|Kibana|Logstash
```
sudo apt-get install elasticsearch && sudo apt-get install kibana && sudo apt-get install logstash
```

# Configure Kibana|v7+

### 11. Configure Kibana
```
sudo nano /etc/kibana/kibana.yml
```

### 12. Modify host file (/etc/kibana/kibana.yml)
- server.port: 5601
- server.host: "0.0.0.0"

# Configure Logstash|v7+

### 13. Change Directory
```
cd /etc/logstash/conf.d
```

### 14. Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/conf.d/01-inputs.conf
```
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/conf.d/05-syslog.conf
```
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/conf.d/10-pf.conf
```
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/conf.d/11-firewall.conf
```
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/conf.d/50-outputs.conf
```
### 14a. (Optional) Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/conf.d/12-suricata.conf
```
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/conf.d/13-snort.conf
```
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/conf.d/15-others.conf
```


### 15. Make Patterns Folder
```
sudo mkdir /etc/logstash/conf.d/patterns
```

### 16. Navigate to Patterns Folder
```
cd /etc/logstash/conf.d/patterns/
```

### 17. Download the following configuration file
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/conf.d/patterns/pf-09.2019.grok
```

### 18. Enter your pfSense/OPNsense IP address (05-syslog.conf)
```
sudo nano /etc/logstash/conf.d/05-syslog.conf
```

### 19. Revise/Update w/pf IP address (05-syslog.conf)
```
Change line 5; the "if [host] =~ ..." should point to your pfSense IP address
Change line 12-16; (OPTIONAL) to point to your second PF IP address or ignore
```

# Configure Services

### 20. Start Services on Boot as Services (you'll need to reboot or start manually to proceed)
```
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl enable kibana.service
sudo /bin/systemctl enable logstash.service
```

### 21. Start Services Manually
```
systemctl start elasticsearch 
systemctl start kibana 
systemctl start logstash 
```

### 22. Login to pfSense and Forward syslogs
- In pfSense navigate to Status->System Logs, then click on Settings.
- At the bottom check "Enable Remote Logging"
- (Optional) Select a specific interface to use for forwarding
- Enter the ELK local IP into the field "Remote log servers" with port 5140
- Under "Remote Syslog Contents" check "Everything"
- Click Save

### 23. Set-up Kibana
- In your web browser go to the ELK local IP using port 5601
- Click the gear icon in the bottom left
- Click Kibana -> Index Patters
- Click Create New Index Pattern
- Type "pf*" into the input box, then click Next Step
- In the Time Filter drop down select "@timestamp"
- Click Create then verify you have data showing up under the Discover tab


### Troubleshooting
- Restart services:
```
systemctl stop elasticsearch 
systemctl stop kibana 
systemctl stop logstash 
systemctl start elasticsearch 
systemctl start kibana 
systemctl start logstash 
```

- Check logs for errors:
```
sudo vi /var/log/logstash/logstash-plain.log
sudo vi /var/log/elasticsearch/elasticsearch.log
(Press Shift + G to scroll to bottom, Escape then type ":q!" to exit)
If this helped, feel free to donate a drink:

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=KA7KSUM22FW7Q&currency_code=USD&source=url)
