## Welcome to (pfSense/OPNsense) + Elastic Stack  

![pfelk dashboard](https://github.com/3ilson/pfelk/raw/master/Images/pfelk-dashboard.png)

You can view installation guide guide on [3ilson.org YouTube Channel](https://www.youtube.com/3ilsonorg).


![Version badge](https://img.shields.io/badge/ELK-7.7.0-blue.svg)
![Travis (.org)](https://img.shields.io/travis/3ilson/ansible-pfelk?label=Ansible-playbook) ![Travis (.org)](https://img.shields.io/travis/3ilson/docker-pfelk?label=Docker-compose) [![Gitter](https://badges.gitter.im/pfelk/community.svg)](https://gitter.im/pfelk/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/a3ilson) 

### Prerequisites
- Ubuntu Server v18.04+ or Debian Server 9+ (stretch and buster are tested)
- pfSense v2.4.4+ or OPNsense 19.7.4+
- The following was tested with Java v11 LTS and Elastic Stack v7.7.0
- Minimum of 4GB of RAM but recommend 32GB

**pfelk** is a highly customizable **open-source** tool for ingesting and visualizing your firewall traffic with the full power of Elasticsearch, Logstash and Kibana.

### Key features:

1. **ingest** and **enrich** your pfSense/OPNsense **firewall traffic** logs by leveraging *Logstash*

2. **search** your indexed data in *near-real-time* with the full power of the *Elasticsearch*

3. **visualize** you network traffic with interactive dashboards, Maps, graphs in *Kibana*

Supported entries include:
 - pfSense/OPNSense setups
 - TCP/UDP/ICMP protocols
 - DHCP message types
 - IPv4/IPv6 mapping
 - pfSense CARP data
 - openVPN log parsing
 - Unbound DNS Resolver
 - Suricata IDS with dashboards
 - Snort IDS with dashboards

**pfelk** aims to replace the vanilla pfSense/opnSense web UI with extended search and visualization features. You can deploy this solution via **ansible-playbook**, **docker-compose**, **bash script**, or manually.

### Contents
* [How pfelk works?](https://github.com/3ilson/pfelk#how-pfelk-works)
* [Installation](https://github.com/3ilson/pfelk#installation)
  * [ansible](https://github.com/3ilson/pfelk#ansible-playbook)
  * [docker](https://github.com/3ilson/pfelk#docker-compose)
  * [manual installation/script](https://github.com/3ilson/pfelk#manual-installationscript)
* [Roadmap](https://github.com/3ilson/pfelk#roadmap)
* [Comparison to similar technologies](https://github.com/3ilson/pfelk#comparison-to-similar-technologies)
* [Contributing](https://github.com/3ilson/pfelk#contributing)
* [License](https://github.com/3ilson/pfelk#license)

### How pfelk works?
![How pfelk works](https://github.com/3ilson/pfelk/raw/master/Images/how-pfelk.png)
### Quick start

### Installation
#### ansible-playbook
 * Clone the [ansible-pfelk](https://github.com/3ilson/ansible-pfelk) repository
 * `$ ansible-playbook -i hosts --ask-become deploy-stack.yml`

#### docker-compose
 * Clone the [docker-pfelk](https://github.com/3ilson/docker-pfelk) repository
 * Setup MaxMind
 * `$ docker-compose up`

#### manual installation/script - preferred manual method
* Download installer script from [pfelk](https://raw.githubusercontent.com/3ilson/pfelk/master/pfelk-install-1.0.0.sh) repository
##### Ubuntu
* `$ sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/pfelk-install-1.0.0.sh`
* Make script executable 
* `$ sudo chmod +x pfelk-install-1.0.0.sh`
* Run installer script 
* `$ sudo ./pfelk-install-1.0.0.sh`
* Finish Configuring [here](https://github.com/3ilson/pfelk/blob/master/install/script.md)
##### Debian
* `$ wget https://raw.githubusercontent.com/3ilson/pfelk/master/pfelk-install-1.0.0.sh`
* Make script executable 
* `$ chmod +x pfelk-install-1.0.0.sh`
* Run installer script 
* `$ ./pfelk-install-1.0.0.sh`
* Finish Configuring [here](https://github.com/3ilson/pfelk/blob/master/install/script.md)

#### manual installation
* [Ubuntu 18.04 / 20.04](https://github.com/3ilson/pfelk/blob/master/install/ubuntu.md)
* [Debian 9-10.3](https://github.com/3ilson/pfelk/blob/master/install/debian.md)

### Roadmap
This is the experimental public roadmap for the pfelk project.

[See the roadmap »](https://github.com/orgs/3ilson/projects)

### Comparison to similar technologies
[Comparisions »](https://github.com/3ilson/pfelk/wiki/Comparison)

### Contributing
Please reference to the CONTRIBUTING.md. Collectively we can enhance and improve this product. Issues, feature requests, pulls, and documentation contributions in are encouraged and welcomed!

### License
This project is licensed under the terms of the Apache 2.0 open source license. Please refer to LICENSE for the full terms.
