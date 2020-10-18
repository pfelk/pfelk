## Custom Installation Guide (pfSense/OPNsense) + Elastic Stack 

## Table of Contents

- [Preparation](#preparation)
- [Installation](#installation)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)

# Preparation

### 0a. Disabling Swap
Swapping should be disabled for performance and stability.
```
sudo swapoff -a
```

### 0b. Configuration Date/Time Zone
The box running this configuration will reports firewall logs based on its clock.  The command below will set the timezone to Eastern Standard Time (EST).  To view available timezones type `sudo timedatectl list-timezones`
```
sudo timedatectl set-timezone EST
```

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

### 6. Install Java 14 LTS
```
sudo apt install openjdk-14-jre-headless
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
- Modify line 18 as follows:
```
DatabaseDirectory /usr/share/GeoIP/
```

### 9. Download Maxmind Databases
```
sudo geoipupdate
```

### 10. Add cron (automatically updates Maxmind everyweek on Sunday at 1700hrs)
```
sudo nano /etc/cron.weekly/geoipupdate
```
- Add the following and save/exit
```
00 17 * * 0 geoipupdate
```

# Installation
- Elasticsearch v7+ | Kibana v7+ | Logstash v7+

### 11. Install Elasticsearch|Kibana|Logstash
```
sudo apt install elasticsearch; sudo apt install kibana; sudo apt install logstash
```

# Configuration

### 12. Configure Kibana
```
sudo nano /etc/kibana/kibana.yml
```

### 13. Modify host file (/etc/kibana/kibana.yml)
- server.port: 5601
- server.host: "0.0.0.0"

### 14. Create Required Directories 
```
sudo mkdir /etc/logstash/conf.d/{databases,patterns,templates}
```

### 15a. (Required) Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/01-inputs.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/02-types.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/03-filter.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/05-firewall.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/10-apps.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/30-geoip.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/50-outputs.conf -P /etc/logstash/conf.d/
```

### 15b. (Optional) Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/35-rules-desc.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/36-ports-desc.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/45-cleanup.conf -P /etc/logstash/conf.d/
```

### 16. Download the grok pattern
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/patterns/pfelk.grok -P /etc/logstash/conf.d/patterns/
```

### 17a. (Optional) Download the Database(s)
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/databases/rule-names.csv -P /etc/logstash/conf.d/databases/
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/databases/service-names-port-numbers.csv -P /etc/logstash/conf.d/databases/
```

### 17b. (Optional) Configure Firewall Rule Database
To configure pfSense/OPNsense to update the firewall rule database, follow [this reference](https://github.com/3ilson/pfelk/wiki/References:-Rule-Descriptions).

### 18. (Optional) Amend 02-types.conf with unique observer.name field (line 8).  
Amend "OPNsense" as desired.  This will be useful if monitoring multiple instances. Reference the [Wiki page](https://github.com/3ilson/pfelk/wiki/References:-Multiple-Instances) for further assistance.
```
      add_field => [ "[observer][name]", "OPNsense" ]
```

# Troubleshooting
### 19. Create Logging Directory 
```
sudo mkdir -p /etc/pfELK/logs
```

### 20. Download `error-data.sh`
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/error-data.sh -P /etc/pfELK/
```

### 21. Make `error-data.sh` Executable
```
sudo chmod +x /etc/pfELK/error-data.sh
```

### 22. Complete Configuration --> [Configuration](configuration.md)
