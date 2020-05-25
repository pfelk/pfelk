## Scripted Installation Guide (pfSense/OPNsense) + Elastic Stack 

## Table of Contents
- [Installation](#installation)
- [Configuration](#configuration)

## Installation

### 1. MaxMind
- Create a MaxMind Account @ https://www.maxmind.com/en/geolite2/signup
- Login to your MaxMind Account; navigate to "My License Key" under "Services" and Generate new license key
- Keep your MaxMind Credentials, you will need them upon running the script!

### 2. Download and Run Script
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/pfelk-install-1.0.0.sh
```
### 3. Make the script executable 
```
sudo chmod +x pfelk-install-1.0.0.sh
```
### 4. Execute the script 
```
sudo ./pfelk-install-1.0.0.sh
```

## Configuration 

#### 2. Enter your pfSense/OPNsense IP address 
`sudo nano /etc/logstash/conf.d/01-inputs.conf`
```
Change line 12; the "if [host] = "0.0.0.0" should point to your pfSense/OPNsense IP address
Change line 15; rename "firewall" (OPTIONAL) to identify your device (i.e. backup_firewall)
Change line 18-27; (OPTIONAL) to point to your second PF IP address or ignore
```

### 3. Complete Configuration --> [Configuration](configuration.md)
