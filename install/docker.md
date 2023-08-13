## Custom Installation Guide (pfSense/OPNsense) + Elastic Stack 

## Table of Contents

- [Preparation](#preparation)
- [Installation](#installation)
- [Configuration](#configuration)
- [Services](#services)

# Preparation

### 1. Disabling Swap
Swapping should be disabled for performance and stability.
```
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

### 2. Configuration Date/Time Zone
The box running this configuration will reports firewall logs based on its clock.  The command below will set the timezone to Eastern Standard Time (EST).  To view available timezones type `sudo timedatectl list-timezones`
```
sudo timedatectl set-timezone EST
```

### 3. Configure Memory
```
sudo sysctl -w vm.max_map_count=262144
```

# Installation

### 4. Download and Install Docker
```
sudo apt-get install docker
```
### 5. Download and Install Docker Compose
```
sudo apt-get install docker-compose
```

### 6. Create Required Directories 
```
sudo mkdir -p /etc/pfelk/{conf.d,config,logs,databases,patterns,scripts,templates}
```

### 7. (Required) Download the pfelk docker files
```
sudo wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/.env -P /etc/pfelk/docker/
sudo wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/docker-compose.yml -P /etc/pfelk/docker/
sudo wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/config/logstash.yml -P /etc/pfelk/config/
sudo wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/config/pipelines.yml -P /etc/pfelk/config/
```

### 8. (Required) Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/01-inputs.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/02-firewall.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/05-apps.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/30-geoip.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/49-cleanup.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/50-outputs.pfelk -P /etc/pfelk/conf.d/
```

### 9. (Optional) Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/20-interfaces.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/35-rules-desc.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/36-ports-desc.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/37-enhanced_user_agent.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/38-enhanced_url.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/45-enhanced_private.pfelk -P /etc/pfelk/conf.d/
```

### 10. Download the grok pattern
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/patterns/pfelk.grok -P /etc/pfelk/patterns/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/patterns/openvpn.grok -P /etc/pfelk/patterns/
```

### 11. (Optional) Download the Database(s)
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/databases/private-hostnames.csv -P /etc/pfelk/databases/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/databases/rule-names.csv -P /etc/pfelk/databases/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/databases/service-names-port-numbers.csv -P /etc/pfelk/databases/
```

### 12. (Optional) Configure Firewall Rule Database
To configure pfSense/OPNsense to update the firewall rule database, follow [this reference](https://github.com/pfelk/pfelk/wiki/References:-Rule-Descriptions).

### 13. (Optional) Amend 20-interfaces.pfelk as desired, to map/reference the interface.name, interface.alias and network.name fields. 
Amend `interface.name`, `interface.alias` and `network.name` fields via [Wiki page](https://github.com/pfelk/pfelk/wiki/References:-Customized-Interface-Names)

# Configuration
* Optional

### 14. Configure Credentials | .env
```
sudo nano /etc/pfelk/docker/.env
```
#### Amend `.env` Credentials as Desired
```
ELASTIC_PASSWORD=changeme
KIBANA_PASSWORD=changeme
LOGSTASH_PASSWORD=changeme
LICENSE=basic
```

### 15. Configure Credentials | 50-outputs.conf
```
sudo nano /etc/pfelk/conf.d/50-outputs.pfelk
```
#### Amend 50-outputs.conf Credentials as Desired
```
    cacert => '/usr/share/logstash/config/certs/ca/ca.crt'
    user => "elastic"
    # cacert => '/etc/logstash/config/certs/http_ca.crt' #[Disable if using Docker]
    # user => "pfelk_logstash" #[Disable if using Docker]
    password => "changeme"
```

# Services

### 14. Navigate to Docker.yml File
```
cd /etc/pfelk/docker/
```

### 15. Start pfelk/docker
```
sudo docker-compose up
```
or if you want to fund in the background
```
sudo docker-compose up -d
```

**[Install](docker.md)** • <sub>[Templates](templates.md)</sub> • <sub>[Configuration](configuration.md)</sub>
