![Version badge](https://img.shields.io/badge/ELK-7.10.1-blue.svg)
[![Gitter](https://badges.gitter.im/pfelk/community.svg)](https://gitter.im/pfelk/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/a3ilson)

[![Star](https://img.shields.io/github/stars/pfelk/pfelk?style=plastic)](https://github.com/pfelk/pfelk/stargazers) 
[![Fork](https://img.shields.io/github/forks/pfelk/pfelk?style=plastic)](https://github.com/pfelk/pfelk/network/members)
[![Issues](https://img.shields.io/github/issues/pfelk/pfelk?style=plastic)](https://github.com/pfelk/pfelk/issues)

[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/3ilson)
## Welcome to (pfSense/OPNsense) + Elastic Stack  
![pfelk dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/Dashboard%20-%20v61.gif)

### Prerequisites
- Ubuntu Server v18.04+ or Debian Server 9+ (stretch and buster are tested)
- pfSense v2.4.4+ or OPNsense 19.7.4+
- The following was tested with Java v11 LTS and Elastic Stack v7.10.1
- Minimum of 4GB of RAM but recommend 32GB

**pfelk** is a highly customizable **open-source** tool for ingesting and visualizing your firewall traffic with the full power of Elasticsearch, Logstash and Kibana.

### Key features:

1. **ingest** and **enrich** your pfSense/OPNsense **firewall traffic** logs by leveraging *Logstash*

2. **search** your indexed data in *near-real-time* with the full power of the *Elasticsearch*

3. **visualize** you network traffic with interactive dashboards, Maps, graphs in *Kibana*

Supported entries include:
 - pfSense/OPNSense setups
 - TCP/UDP/ICMP protocols
 - DHCP message types with dashboard (dhcpdv4)
 - IPv4/IPv6 mapping
 - pfSense CARP data
 - openVPN log parsing
 - Unbound DNS Resolver with dashboard
 - Suricata IDS with dashboard
 - Snort IDS with dashboard
 - Squid with dashboard
 - HAProxy with dashboard
 - Captive Portal with dashboard

**pfelk** aims to replace the vanilla pfSense/OPNsense web UI with extended search and visualization features. You can deploy this solution via **ansible-playbook**, **docker-compose**, **bash script**, or manually.

### Contents
* [How pfelk works?](https://github.com/pfelk/pfelk#how-pfelk-works)
* [Installation](https://github.com/pfelk/pfelk#installation)
  * [ansible](https://github.com/pfelk/pfelk#ansible-playbook)
  * [docker](https://github.com/pfelk/pfelk#docker-compose)
  * [manual installation/script](https://github.com/pfelk/pfelk#manual-installationscript---preferred-manual-method)
* [Roadmap](https://github.com/pfelk/pfelk#roadmap)
* [Comparison to similar solutions](https://github.com/pfelk/pfelk#comparison-to-similar-solutions)
* [Contributing](https://github.com/pfelk/pfelk#contributing)
* [License](https://github.com/pfelk/pfelk#license)

### How pfelk works?
* ![How pfelk works](https://github.com/pfelk/pfelk/raw/master/Images/pfELK-Overview.PNG)

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
* Download installer script from [pfelk](https://raw.githubusercontent.com/pfelk/pfelk/master/pfelk-installer.sh) repository
* `$ wget https://raw.githubusercontent.com/pfelk/pfelk/master/pfelk-installer.sh`
* Make script executable 
* `$ chmod +x pfelk-installer.sh`
* Run installer script 
* `$ ./pfelk-installer.sh`
* Finish Configuring [here](https://github.com/pfelk/pfelk/blob/master/install/configuration.md)
* [![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=qcGcsQQoPo0) Guide

#### manual installation method
* [Ubuntu 18.04 / 20.04](https://github.com/pfelk/pfelk/blob/master/install/ubuntu.md)
* [Debian 9-10.5](https://github.com/pfelk/pfelk/blob/master/install/debian.md)
* [![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=_IJAAUqNVRc) Guide

### Roadmap
This is the experimental public roadmap for the pfelk project.

[See the roadmap »](https://github.com/pfelk/pfelk/projects)

### Comparison to similar solutions
[Comparisions »](https://github.com/pfelk/pfelk/wiki/Comparison)

### Contributing
Please reference to the [CONTRIBUTING file](https://github.com/pfelk/pfelk/blob/master/CONTRIBUTING.md). Collectively we can enhance and improve this product. Issues, feature requests, PRs, and documentation contributions are encouraged and welcomed!

### License
This project is licensed under the terms of the Apache 2.0 open source license. Please refer to [LICENSE](https://github.com/pfelk/pfelk/blob/master/license) for the full terms.
