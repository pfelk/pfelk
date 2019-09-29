## Welcome to (pfSense/OpnSense) + ELK

![pfelk dashboard](https://3.bp.blogspot.com/-NYJMm6Ax8uI/WfkHm_gtD1I/AAAAAAAACZY/B2krn7xKBRwFRxJRmMXgN9W0ZYY5uONBgCLcBGAs/s1600/logs.png)

You can view installation guide guide on [3ilson.org YouTube Channel](https://www.youtube.com/3ilsonorg).

### Prerequisites
- Ubuntu Server v18.04+
- pfSense v2.4.4+ or OPNsense 19.7.3+

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

### 7. Install Java 12
```
sudo apt-get install oracle-java12-installer
```

### 8. Install Maxmind
```
sudo apt install geoipupdate
```

### 9. Configure Maxmind
```
sudo nano /etc/GeoIP.conf
```
Append line 13 as follows:
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
Add the following and save/exit
```
00 17 * * 0 geoipupdatey
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

### 12. Amend host file (/etc/kibana/kibana.yml)
```
server.port: 5601
server.host: "0.0.0.0"
```

# Configure Logstash|v7+

### 13. Change Directory
```
cd /etc/logstash/conf.d
```

### 14. Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/01-inputs.conf
```

```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/05-syslog.conf
```

```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/10-pf.conf
```

```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/50-outputs.conf
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
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/pf-09.2019.grok
```

### 18. Edit (05-syslog.conf)
```
sudo nano /etc/logstash/conf.d/05-syslog.conf
```

### 19. Revise/Update w/pf IP address (05-syslog.conf)
```
Change line 3; the "if [host]..." should point to your pf IP address
Change line 9 to point to your second Pf IP address or comment out
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
