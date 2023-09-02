## Preparation Guide (pfSense/OPNsense) + Elastic Stack 

# Preparation

### p1. Disabling Swap
Swapping should be disabled for performance and stability.
```
sudo swapoff -a
```
```
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

### p2. Configuration Date/Time Zone
The box running this configuration will reports firewall logs based on its clock.  The command below will set the timezone to Eastern Standard Time (EST).  To view available timezones type `sudo timedatectl list-timezones`
```
sudo timedatectl set-timezone EST
```

### p3. ⚠️ (Debian Only) Add Prerequisites
```
apt-get install apt-transport-https gnupg2 software-properties-common dirmngr lsb-release ca-certificates
```

### p4. Download and install the public GPG signing key
```
sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
```

### p5. Download and install apt-transport-https package
```
sudo apt install apt-transport-https
```

### p6. Add Elasticsearch|Logstash|Kibana Repositories (version 8+)
```
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
```

### p7. Update
```
sudo apt-get update
```

### p8. ⚠️  Install MaxMind (Optional)
Follow the steps [here](https://github.com/pfelk/pfelk/wiki/How-To:-MaxMind-via-GeoIP-with-pfELK), to install and utilize MaxMind. Otherwise the built-in GeoIP from Elastic will be utilized.


# Proceed to Install ➡️ [Install](install.md)

**[Preparation](preparation.md)** • <sub>[Install](install.md)</sub> • <sub>[Security](security.md)</sub> • <sub>[Templates](templates.md)</sub> • <sub>[Configuration](configuration.md)</sub>
