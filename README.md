## Welcome to pfSense + ELK

You can view installation guide guide on [3ilson.org YouTube Channel ](https://www.youtube.com/3ilsonorg).

### Prerequisites 
- Ubuntu Server v18.04+
- pfSense v2.4.4+ or OPNsense 19.1.1+

# Preparation

### 1. Add Oracle Java Repository
```
sudo add-apt-repository ppa:linuxuprising/java
```

### 2. Download and install the public GPG signing key
```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
```

### 3. Download and install apt-transport-https package 
```
sudo apt-get install apt-transport-https
```

### 4. Add Elasticsearch|Logstash|Kibana Repositories (version 7+) 
```
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
```

### 5. Update
```
sudo apt-get update
```

### 6. Install Java 11
```
sudo apt install oracle-java11-installer
```

# Install
- Elasticsearch v7+ | Kibana v7+ | Logstash v7+

### 8. Install Elasticsearch|Kibana|Logstash
```
sudo apt-get install elasticsearch && sudo apt-get install kibana && sudo apt-get install logstash
```

# Configure Kibana|v7+

### 9. Configure Kibana
```
sudo nano /etc/kibana/kibana.yml
```

### 10. Amend host file (/etc/kibana/kibana.yml)
```
server.port: 5601
server.host: "0.0.0.0"
```

# Configure Logstash|v7+

### 11. Change Directory
```
cd /etc/logstash/conf.d
```

### 12. Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/01-inputs.conf
```

```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/10-syslog.conf
```

```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/11-pfsense.conf
```

```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/30-outputs.conf
```

### 13. Make Patterns Folder
```
sudo mkdir /etc/logstash/conf.d/patterns
```

### 14. Navigate to Patterns Folder
```
cd /etc/logstash/conf.d/patterns/
```

### 15. Download the following configuration file
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/pfsense_2_4_2.grok
```

### 16. Edit (10-syslog.conf)arkdown
```
sudo nano /etc/logstash/conf.d/10-syslog.conf
```

### 17. Revise/Update w/pfsense IP address (10-syslog.conf)
```
Change line 3; the "if [host]..." should point to your pfSense IP address
Change line 9 to point to your second PfSense IP address or comment out
```

### 18. Edit (11-pfsense.conf)
```
sudo nano /etc/logstash/conf.d/11-pfsense.conf
```

### 19. Resive/Update timezone
```
Change line 12 to the same timezone as your phSense configruation
_Note if the timezone is offset or mismatched, you may not see any logs_
```

### 20. Download and install the MaxMind GeoIP database
```
cd /etc/logstash
```

### 21. Download and install the MaxMind GeoIP database
```
sudo wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
```

### 22. Download and install the MaxMind GeoIP database
```
sudo gunzip GeoLite2-City.mmdb.gz
```

# Configure Services

### Start Services on Boot as Services (you'll need to reboot or start manually to proceed)
```
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl enable kibana.service
sudo /bin/systemctl enable logstash.service
```

### Start Services Manually
```
sudo -i service elasticsearch start
sudo -i service kibana start
sudo -i service logstash start
```

### Status
```
systemctl status elasticsearch.service
systemctl status kibana.service
systemctl status logstash.service
```

### Troubleshooting
```/var/log/logstash
cat/nano/vi the files within this location to view Logstash logs
```
