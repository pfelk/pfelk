## Custom Installation Guide (pfSense/OPNsense) + Elastic Stack 

## Table of Contents

- [Preparation](#preparation)
- [Installation](#installation)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)

# Preparation

### 1. Add MaxMind Repository
```
sudo add-apt-repository ppa:maxmind/ppa
```

### 2. Download and install the public GPG signing key
```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
```

### 3. Download and install apt-transport-https package
```
sudo apt install apt-transport-https
```

### 4. Add Elasticsearch|Logstash|Kibana Repositories (version 7+)
```
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
```

### 5. Update
```
sudo apt update
```

### 6. Install Java 11 LTS
```
sudo apt install openjdk-11-jre
```

### 7. Install MaxMind
```
sudo apt install geoipupdate
```

### 8. Configure MaxMind
- Create a MaxMind Account @ https://www.maxmind.com/en/geolite2/signup
- Login to your MaxMind Account; navigate to "My License Key" under "Services" and Generate new license key
```
sudo nano /etc/GeoIP.conf
```
- Modify lines 7 & 8 as follows (without < >):
```
AccountID <Input Your Account ID>
LicenseKey <Input Your LicenseKey>
```
- Modify line 13 as follows:
```
EditionIDs GeoLite2-City GeoLite2-Country GeoLite2-ASN
```

### 9. Create Directories and Download Maxmind Databases
```
sudo mkdir /data
sudo mkdir /data/pfELK
sudo mkdir /data/pfELK/GeoIP

sudo geoipupdate -d /data/pfELK/GeoIP/
```

### 10. Add cron (automatically updates Maxmind everyweek on Sunday at 1700hrs)
```
sudo nano /etc/cron.weekly/geoipupdate
```
- Add the following and save/exit
```
00 17 * * 0 geoipupdate -d /data/pfELK/GeoIP
```

# Installation
- Elasticsearch v7+ | Kibana v7+ | Logstash v7+

### 11. Install Elasticsearch|Kibana|Logstash
```
sudo apt install elasticsearch && sudo apt-get install kibana && sudo apt-get install logstash
```

# Configuration

### 12. Configure Kibana
```
sudo nano /etc/kibana/kibana.yml
```

### 13. Modify host file (/etc/kibana/kibana.yml)
- server.port: 5601
- server.host: "0.0.0.0"

### 14. Change Directory
```
cd /data/pfELK/configurations
```

### 15. (Required) Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/data/configurations/01-inputs.conf
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/data/configurations/05-firewall.conf
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/data/configurations/30-geoip.conf
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/data/configurations/50-outputs.conf
```

### 15a. (Optional) Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/data/configurations/10-others.conf
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/data/configurations/20-suricata.conf
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/data/configurations/25-snort.conf
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/data/configurations/35-rules-desc.conf
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/data/configurations/40-dns.conf
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/data/configurations/45-cleanup.conf
```

### 16. Make Patterns Folder
```
sudo mkdir /data/pfELK/patterns
```

### 17. Navigate to Patterns Folder
```
cd /data/pfELK/patterns/
```

### 18. Download the grok pattern
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/data/patterns/pfelk.grok
```

### 19. Make Template Folder
```
sudo mkdir /data/pfELK/templates
```

### 20. Navigate to Template Folder
```
cd /data/pfELK/templates/
```

### 21. Download Template(s)
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/data/templates/pf-geoip-template.json
```

### 22. Navigate to Logstash 
```
cd /etc/logstash/
```

### 23. Download pipelines.yml
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/pipelines.yml
```

### 24. Download logstash.yml
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/logstash.yml
```

### 25. Enter your pfSense/OPNsense IP address (/data/pfELK/configurations/01-inputs.conf)
```
Change line 12; the "if [host] =~ ..." should point to your pfSense/OPNsense IP address
Change line 15; rename "firewall" (OPTIONAL) to identify your device (i.e. backup_firewall)
Change line 18-27; (OPTIONAL) to point to your second PF IP address or ignore
```

### 26. Revise/Update w/pf IP address (/data/pfELK/configurations/01-inputs.conf)
```
For pfSense uncommit line 34 and commit out line 31
For OPNsense uncommit line 31 and commit out line 34
```

# Troubleshooting
### 27. Create Logging Directory 
```
sudo mkdir /data/pfELK/logs
```

### 28. Enable Write Permissions for Logging Directory
```
sudo chmod 777 /data/pfELK/logs
```

### 29. Navigate to pfELK 
```
cd /data/pfELK/
```

### 30. Download `error-data.sh`
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/error-data.sh
```

### 31. Make `error-data.sh` Executable
```
sudo chmod +x /data/pfELK/error-data.sh
```

### 32. Complete Configuration --> [Configuration](configuration.md)
