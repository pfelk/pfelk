## Scripted Installation Guide (pfSense/OPNsense) + Elastic Stack 
- [x] Automate Installation
- [ ] Automate Configuration 

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
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/ez-pfelk-installer.sh
```
### 3. Make the script executable 
```
sudo chmod +x ez-pfelk-installer.sh
```
### 4. Execute the script 
```
sudo ./ez-pfelk-installer.sh
```

## Configuration 

### 2. Configure Logstash|v7.7+
#### 2a. Enter your pfSense/OPNsense IP address 
`sudo nano /data/pfELK/configurations/01-inputs.conf`
```
Change line 12; the "if [host] =~ ..." should point to your pfSense/OPNsense IP address
Change line 15; rename "firewall" (OPTIONAL) to identify your device (i.e. backup_firewall)
Change line 18-27; (OPTIONAL) to point to your second PF IP address or ignore
```
#### 2b. Revise/Update w/pf IP address 
`sudo nano /data/pfELK/configurations/01-inputs.conf`
```
For pfSense uncommit line 34 and commit out line 31
For OPNsense uncommit line 31 and commit out line 34
```

### 3. Complete Configuration --> [Configuration](configuration.md)
