## Scripted Installation Guide (pfSense/OPNsense) + Elastic Stack 

## Table of Contents
- [Installation](#installation)
- [Configuration](#configuration)

## Installation

### 1. MaxMind
- Create a MaxMind Account @ https://www.maxmind.com/en/geolite2/signup
- Login to your MaxMind Account; navigate to "My License Key" under "Services" and Generate new license key
- Keep your MaxMind Credentials, you will need them upon running the script!

### 2a - Ubuntu 
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/pfelk-install-1.0.0.sh
```
#### 3a. Make the script executable 
```
sudo chmod +x pfelk-install-1.0.0.sh
```
#### 4a. Execute the script 
```
sudo ./pfelk-install-1.0.0.sh
```
### 2b - Debian 
```
wget https://raw.githubusercontent.com/3ilson/pfelk/master/pfelk-install-1.0.0.sh
```
#### 3b. Make the script executable 
```
chmod +x pfelk-install-1.0.0.sh
```
#### 4b. Execute the script 
```
./pfelk-install-1.0.0.sh
```

### 5. Complete Configuration --> [Configuration](configuration.md)
