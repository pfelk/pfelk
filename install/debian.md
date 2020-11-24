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

### 1. Add Prerequisites
```
apt-get install apt-transport-https gnupg2 software-properties-common dirmngr lsb-release ca-certificates
```

### 2. Download MaxMind
```
wget https://github.com/maxmind/geoipupdate/releases/download/v4.3.0/geoipupdate_4.3.0_linux_amd64.deb
```

### 3. Install MaxMind
```
apt install ./geoipupdate_4.3.0_linux_amd64.deb
```

### 4. Download and install the public GPG signing key
```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
```

### 5. Add Elasticsearch|Logstash|Kibana Repositories (version 7+)
```
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
```

### 6. Update
```
apt-get update
```

### 7. Install Java 14 LTS
```
apt install openjdk-14-jre-headless
```

### 8. Configure MaxMind
- Create a MaxMind Account @ https://www.maxmind.com/en/geolite2/signup
- Login to your MaxMind Account; navigate to "My License Key" under "Services" and Generate new license key
```
nano /etc/GeoIP.conf
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

### 9. Download MaxMind Databases
```
sudo geoipupdate 
```

### 10. Add cron (automatically updates MaxMind everyweek on Sunday at 1700hrs)
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
apt-get install elasticsearch kibana logstash
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

### 15. (Required) Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/01-inputs.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/02-types.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/03-filter.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/05-firewall.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/10-apps.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/30-geoip.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/50-outputs.conf -P /etc/logstash/conf.d/
```

### 15a. (Optional) Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/35-rules-desc.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/36-ports-desc.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/45-cleanup.conf -P /etc/logstash/conf.d/
```

### 16. Download the grok pattern
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/patterns/pfelk.grok -P /etc/logstash/conf.d/patterns/
```

### 17a. (Optional) Download the Database(s)
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/databases/rule-names.csv -P /etc/logstash/conf.d/databases/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/databases/service-names-port-numbers.csv -P /etc/logstash/conf.d/databases/
```

### 17b. (Optional) Configure Firewall Rule Database
To configure pfSense/OPNsense to update the firewall rule database, follow [this reference](https://github.com/pfelk/pfelk/wiki/References:-Rule-Descriptions).

### 18b. (Optional) Amend 02-types.conf with unique observer.name field (line 8).  
Amend "OPNsense" as desired.  This will be useful if monitoring multiple instances. Reference the [Wiki page](https://github.com/pfelk/pfelk/wiki/References:-Multiple-Instances) for further assistance.
```
      add_field => [ "[observer][name]", "OPNsense" ]
```
### 18ab (Optional) Amend 05-firewall.conf as desired, to map/reference the interface.name, interface.alias and network.name fields. 
Amend `interface.name`, `interface.alias` and `network.name` fields via [Wiki page](https://github.com/pfelk/pfelk/wiki/References:-Customized-Interface-Names)

# Troubleshooting
### 19. Create Logging Directory 
```
sudo mkdir -p /etc/pfELK/logs
```

### 20. Download `error-data.sh`
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/error-data.sh -P /etc/pfELK/
```

### 21. Make `error-data.sh` Executable
```
sudo chmod +x /etc/pfELK/error-data.sh
```

### 22. Complete Configuration --> [Configuration](configuration.md)
