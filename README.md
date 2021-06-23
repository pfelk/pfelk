![Version badge](https://img.shields.io/badge/ELK-7.13.2-blue.svg)
[![Gitter](https://badges.gitter.im/pfelk/community.svg)](https://gitter.im/pfelk/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/a3ilson)

[![Star](https://img.shields.io/github/stars/pfelk/pfelk?style=plastic)](https://github.com/pfelk/pfelk/stargazers) 
[![Fork](https://img.shields.io/github/forks/pfelk/pfelk?style=plastic)](https://github.com/pfelk/pfelk/network/members)
[![Issues](https://img.shields.io/github/issues/pfelk/pfelk?style=plastic)](https://github.com/pfelk/pfelk/issues)

[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/3ilson)
## Welcome to (pfSense/OPNsense) + Elastic Stack  
![pfelk dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/Images/Dashboard%20-%20v61.gif)

### Contents
* [Prerequisites](#prerequisites)
* [Key Features](#key-features)
* [How pfelk works?](#how-pfelk-works)
* [Installation](#installation)
  * [ansible](#ansible-playbook)
  * [docker](#docker-compose)
  * [script installation](#script-installation-method)
  * [manual installation](#manual-installation-method)
* [Roadmap](#roadmap)
* [Comparison to similar solutions](#comparison-to-similar-solutions)
* [Contributing](#contributing)
* [License](#license)

### Prerequisites
- Ubuntu Server v18.04+ or Debian Server 9+ (stretch and buster tested)
- pfSense v2.4.4+ or OPNsense 19.7.4+
- Minimum of 4GB of RAM but recommend 32GB ([WiKi Reference](https://github.com/pfelk/pfelk/wiki/How-To:-Performance))
- Setting up remote logging ([WiKi Reference](https://github.com/pfelk/pfelk/wiki/How-To:-Prerequisite-%7C--pfSense-OPNsense-Logging))

**pfelk** is a highly customizable **open-source** tool for ingesting and visualizing your firewall traffic with the full power of Elasticsearch, Logstash and Kibana.

### Key features:

- **ingest** and **enrich** your pfSense/OPNsense **firewall traffic** logs by leveraging *Logstash*

- **search** your indexed data in *near-real-time* with the full power of the *Elasticsearch*

- **visualize** you network traffic with interactive dashboards, Maps, graphs in *Kibana*

Supported entries include:
 - pfSense/OPNSense setups
 - TCP/UDP/ICMP protocols
 - DHCP message types with dashboard (dhcpdv4)
 - IPv4/IPv6 mapping
 - pfSense CARP data
 - openVPN log parsing
 - Unbound DNS Resolver with dashboard and Kibana SIEM compliance
 - Suricata IDS with dashboard and Kibana SIEM compliance
 - Snort IDS with dashboard and Kibana SIEM compliance 
 - Squid with dashboard and Kibana SIEM compliance
 - HAProxy with dashboard
 - Captive Portal with dashboard

**pfelk** aims to replace the vanilla pfSense/OPNsense web UI with extended search and visualization features. You can deploy this solution via **ansible-playbook**, **docker-compose**, **bash script**, or manually.

### How pfelk works?
* ![How pfelk works](https://raw.githubusercontent.com/pfelk/pfelk/main/Images/pfELK-Overview.PNG)

### Quick start

### Installation
#### ansible-playbook
 * Clone the [ansible-pfelk](https://github.com/pfelk/ansible-pfelk) repository
 * `$ ansible-playbook -i hosts --ask-become deploy-stack.yml`

#### docker-compose
 * Clone the [docker-pfelk](https://github.com/pfelk/docker-pfelk) repository
 * Setup MaxMind
 * `$ docker-compose up`
 * [![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=MJVbLvdVtyY) Guide

#### script installation method
* Download installer script from [pfelk](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/scripts/pfelk-installer.sh) repository
* `$ wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/scripts/pfelk-installer.sh`
* Make script executable 
* `$ chmod +x pfelk-installer.sh`
* Run installer script 
* `$ ./pfelk-installer.sh`
* Finish Configuring [here](https://github.com/pfelk/pfelk/blob/main/install/configuration.md)
* [![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=qcGcsQQoPo0) Guide

#### manual installation method
* [Ubuntu 18.04 / 20.04](https://github.com/pfelk/pfelk/blob/main/install/ubuntu.md)
* [Debian 9-10.5](https://github.com/pfelk/pfelk/blob/main/install/debian.md)
* [![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=_IJAAUqNVRc) Guide

### Roadmap
This is the experimental public roadmap for the pfelk project.

[See the roadmap »](https://github.com/pfelk/pfelk/projects)

### Comparison to similar solutions
[Comparisions »](https://github.com/pfelk/pfelk/wiki/Comparison)

### Contributing
Please reference to the [CONTRIBUTING file](https://github.com/pfelk/pfelk/blob/main/CONTRIBUTING.md). Collectively we can enhance and improve this product. Issues, feature requests, PRs, and documentation contributions are encouraged and welcomed!

### License
This project is licensed under the terms of the Apache 2.0 open source license. Please refer to [LICENSE](https://github.com/pfelk/pfelk/blob/main/license) for the full terms.
