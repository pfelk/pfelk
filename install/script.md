## Scripted Installation Guide (pfSense/OPNsense) + Elastic Stack 
- [x] Automate Installation
- [ ] Automate Configuration 
- [ ] Build Repository (RPM) Installation

## Table of Contents
- [Installation](#installation)
- [Configuration](#configuration)

# Installation

## 0. Download and Run Script
```
sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/ez-pfelk-installer.sh
```
- Make the script executable 
```
sudo chmod +x ez-pfelk-installer.sh
```
- Execute the script 
```
sudo ./ez-pfelk-installer.sh
```

# Configuration 

## 1. Maxmind
- Create a Max Mind Account @ https://www.maxmind.com/en/geolite2/signup
- Login to your Max Mind Account; navigate to "My License Key" under "Services" and Generate new license key
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
#### 1a. Download Maxmind Databases
```
sudo geoipupdate -d /usr/share/GeoIP/
```

#### 1b. Add cron 
```
sudo nano /etc/cron.weekly/geoipupdate
```
- Add the following and save/exit (automatically updates Maxmind every week on Sunday at 1700hrs)
```
00 17 * * 0 geoipupdate -d /usr/share/GeoIP
```
## 2. Configure Logstash|v7.5+
#### 2a. Enter your pfSense/OPNsense IP address 
`sudo nano /etc/logstash/conf.d/01-inputs.conf`
```
Change line 9; the "if [host] =~ ..." should point to your pfSense/OPNsense IP address
Change line 12-16; (OPTIONAL) to point to your second PF IP address or ignore
```

#### 2b. Revise/Update w/pf IP address 
`sudo nano /etc/logstash/conf.d/01-inputs.conf`
```
For pfSense uncomment line 28 and commit out line 25
For OPNsense uncomment line 25 and commit out line 28
```
## 3. Configure Kibana|v7.5+
#### 3a. Configure Kibana
```
sudo nano /etc/kibana/kibana.yml
```
#### 3b. Modify host file (/etc/kibana/kibana.yml)
- server.port: 5601
- server.host: "0.0.0.0"

## 4. Complete Configuration --> [Configuration](configuration.md)
