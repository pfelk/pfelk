## Welcome to (pfSense/OPNsense) + Elastic Stack 

![pfelk dashboard](https://github.com/a3ilson/pfelk/raw/master/pf%2BELK.png)
You can view installation guide guide on [3ilson.org YouTube Channel](https://www.youtube.com/3ilsonorg).


### Prerequisites
- Ubuntu Server v18.04+
- pfSense v2.4.4+ or OPNsense 19.7.4+
- The following was tested with Java v13 and Elastic Stack v7.5

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
sudo geoipupdate -d /usr/share/GeoIP/
```

### 9. Add cron (automatically updates Maxmind everyweek on Sunday at 1700hrs)
```
sudo nano /etc/cron.weekly/geoipupdate
```
- Add the following and save/exit
```
00 17 * * 0 geoipupdate -d /usr/share/GeoIP
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
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/conf.d/11-firewall.conf
```
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/conf.d/20-geoip.conf
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
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/conf.d/patterns/pf-12.2019.grok
```

### 18. Enter your pfSense/OPNsense IP address (01-inputs.conf)
```
Change line 9; the "if [host] =~ ..." should point to your pfSense/OPNsense IP address
Change line 12-16; (OPTIONAL) to point to your second PF IP address or ignore
```

### 19. Revise/Update w/pf IP address (01-inputs.conf)
```
For pfSense uncommit line 28 and commit out line 25
For OPNsense uncommit line 25 and commit out line 28
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

### (Optional) Configure Suricata for log forwarding
 - On your pfSense web UI go to Services / Suricata / Interfaces, and enable Suricata on desired interfaces
 - You can have separate configuration on each of your interfaces, you can edit them via clicking on the pencil icon
 - You should enable the EVE JSON output format for log forwarding, you should have the following options enabled at the EVE Output Settings section:
   - Eve JSON log: Suricata will output selected info in JSON format to a single file or to syslog 
   - EVE Output type: SYSLOG
   - EVE Syslog Output Facility: AUTH
   - EVE Syslog Output Priority: NOTICE 
   - EVE Log Alerts: Suricata will output Alerts via EVE
 - After saving this will get a notification about auto-enabling settings at the Logging Settings menu: the Log Facility here should be set to LOCAL1, and the Log Priority should be set to NOTICE.
 

### 23. Set-up Kibana
- In your web browser go to the ELK local IP using port 5601 (ex: 192.168.0.1:5601)
- Click Kibana -> Index Patters
- Click Create New Index Pattern
- Type "pf*" into the input box, then click Next Step
- In the Time Filter drop down select "@timestamp"
- Click Create then verify you have data showing up under the Discover tab

### 24. Import dashboards
 - In your web browser go to the ELK local IP using port 5601 (ex: 192.168.0.1:5601)
 - Click Management -> Saved Objects
 - You can import the dashboards found in the `Dashboard` folder via the Import buttom in the top-right corner.

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
```

- Check the Pipeline Viewer UI to visualize your pipeline

This feature is part of the (free) X-Pack addons.
You only need to enable monitoring for Logstash. 
To do this have the following lines in `/etc/logstash/logstash.yml`:
```
xpack.monitoring.enabled: true
xpack.monitoring.elasticsearch.hosts: [ "http://your-elasticsearch-instance:9200" ]
```
Restart Logstash
```
systemctl restart logstash
```
Go to Stack Monitoring / Logstash / Pipelines / Choose the ID of your relevant pipelines.

If this helped, feel free to make a contribution:

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=KA7KSUM22FW7Q&currency_code=USD&source=url)
