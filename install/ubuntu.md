## Custom Installation Guide (pfSense/OPNsense) + Elastic Stack 

## Table of Contents

- [Preparation](#preparation)
- [Installation](#installation)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Services](#services)

# Preparation

### 0. Disabling Swap
Swapping should be disabled for performance and stability.
```
sudo swapoff -a
```

### 1. Configuration Date/Time Zone
The box running this configuration will reports firewall logs based on its clock.  The command below will set the timezone to Eastern Standard Time (EST).  To view available timezones type `sudo timedatectl list-timezones`
```
sudo timedatectl set-timezone EST
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

### 7. Install MaxMind (Optional)
Follow the steps [here](https://github.com/pfelk/pfelk/wiki/How-To:-MaxMind-via-GeoIP-with-pfELK), to install and utilize MaxMind. Otherwise the built-in GeoIP from Elastic will be utilized.

# Installation
- Elasticsearch v7+ | Kibana v7+ | Logstash v7+

### 8. Install Elasticsearch|Kibana|Logstash
```
sudo apt install elasticsearch; sudo apt install kibana; sudo apt install logstash
```

# Configuration

### 9. Configure Kibana
```
sudo nano /etc/kibana/kibana.yml
```

### 10. Modify host file (/etc/kibana/kibana.yml)
- server.port: 5601
- server.host: "0.0.0.0"

### 11. Create Required Directories 
```
sudo mkdir /etc/logstash/conf.d/{databases,patterns,templates}
```

### 12. (Required) Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/01-inputs.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/02-types.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/03-filter.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/05-apps.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/20-interfaces.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/30-geoip.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/45-cleanup.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/50-outputs.conf -P /etc/logstash/conf.d/
```

### 13. (Optional) Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/35-rules-desc.conf -P /etc/logstash/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/36-ports-desc.conf -P /etc/logstash/conf.d/
```

### 14. Download the grok pattern
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/patterns/pfelk.grok -P /etc/logstash/conf.d/patterns/
```

### 15. (Optional) Download the Database(s)
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/databases/rule-names.csv -P /etc/logstash/conf.d/databases/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/databases/service-names-port-numbers.csv -P /etc/logstash/conf.d/databases/
```

### 16. (Optional) Configure Firewall Rule Database
To configure pfSense/OPNsense to update the firewall rule database, follow [this reference](https://github.com/pfelk/pfelk/wiki/References:-Rule-Descriptions).

### 17. (Optional) Amend 02-types.conf with unique observer.name field (line 8).  
Amend "OPNsense" as desired.  This will be useful if monitoring multiple instances. Reference the [Wiki page](https://github.com/pfelk/pfelk/wiki/References:-Multiple-Instances) for further assistance.
```
      add_field => [ "[observer][name]", "OPNsense" ]
```
### 18. (Optional) Amend 20-interfaces.conf as desired, to map/reference the interface.name, interface.alias and network.name fields. 
Amend `interface.name`, `interface.alias` and `network.name` fields via [Wiki page](https://github.com/pfelk/pfelk/wiki/References:-Customized-Interface-Names)

# Troubleshooting
### 19. Create Logging Directory 
```
sudo mkdir -p /etc/pfELK/logs
```

### 20. Download Script
`error-data.sh`
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/master/error-data.sh -P /etc/pfELK/
```

### 21. Make Script Executable
`error-data.sh` 
```
sudo chmod +x /etc/pfELK/error-data.sh
```

# Services
### 22. Start Services on Boot (you'll need to reboot or start manually to proceed)
```
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl enable kibana.service
sudo /bin/systemctl enable logstash.service
```
### 23. Start Services Manually
```
systemctl start elasticsearch.service 
systemctl start kibana.service
systemctl start logstash.service
```

### 24. Complete Configuration --> [Configuration](configuration.md)
