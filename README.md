## Welcome to (pfSense/OpnSense) + ELK

You can view installation guide guide on [3ilson.org YouTube Channel](https://www.youtube.com/3ilsonorg).

### Prerequisites
- Ubuntu Server v18.04+
- pfSense v2.4.4+ or OPNsense 19.7.3+

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

### 6. Install Java 12
```
sudo apt-get install oracle-java12-installer
```

# Install
- Elasticsearch v7+ | Kibana v7+ | Logstash v7+

### 7. Install Elasticsearch|Kibana|Logstash
```
sudo apt-get install elasticsearch && sudo apt-get install kibana && sudo apt-get install logstash
```

# Configure Kibana|v7+

### 8. Configure Kibana
```
sudo nano /etc/kibana/kibana.yml
```

### 9. Amend host file (/etc/kibana/kibana.yml)
```
server.port: 5601
server.host: "0.0.0.0"
```

# Configure Logstash|v7+

### 10. Change Directory
```
cd /etc/logstash/conf.d
```

### 11. Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/01-inputs.conf
```

```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/05-syslog.conf
```

```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/10-pf.conf
```
- Commit either line 6 or 8 depending on PFsense or OPNsense
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/50-outputs.conf
```

### 12. Make Patterns Folder
```
sudo mkdir /etc/logstash/conf.d/patterns
```

### 13. Navigate to Patterns Folder
```
cd /etc/logstash/conf.d/patterns/
```

### 14. Download the following configuration file
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/pf-09.2019.grok
```

### 15. Edit (10-syslog.conf)
```
sudo nano /etc/logstash/conf.d/10-syslog.conf
```

### 16. Revise/Update w/pf IP address (10-syslog.conf)
```
Change line 3; the "if [host]..." should point to your pf IP address
Change line 9 to point to your second Pf IP address or comment out
```

### 17. Edit (11-pf.conf)
```
sudo nano /etc/logstash/conf.d/11-pf.conf
```

### 18. Revise/Update timezone
```
Change line 12 to the same timezone as your pf configuration
_Note if the timezone is offset or mismatched, you may not see any logs_
```

### 19. Download and install the MaxMind GeoIP database
```
cd /etc/logstash
```

### 20. Download and install the MaxMind GeoIP City database
```
sudo wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
```

### 21. Download and install the MaxMind GeoIP City database
```
sudo gunzip GeoLite2-City.mmdb.gz
```

### 22. Download and install the MaxMind GeoIP ASN database
```
sudo wget https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz
```

### 23. Download and install the MaxMind GeoIP ASN database
```
sudo tar -xvzf GeoLite2-ASN.tar.gz
```

### 24. Download and install the MaxMind GeoIP ASN database
##### Replace YYYYMMDD below with the correct date from your extracted directory
```
sudo mv GeoLite2-ASN_YYYYMMDD/GeoLite2-ASN.mmdb
```

### 25. Download and install the MaxMind GeoIP ASN database
##### Replace YYYYMMDD below with the correct date from your extracted directory
```
sudo rm -rf GeoLite2-ASN_YYYYMMDD
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
