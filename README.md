![Version badge](https://img.shields.io/badge/ELK-8.12.2-blue.svg)
[![Gitter](https://badges.gitter.im/pfelk/community.svg)](https://gitter.im/pfelk/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/3ilson)

# Elastic Integration
- https://docs.elastic.co/en/integrations/pfsense

# pfSense/OPNsense + Elastic Stack  
![pfelk dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/Images/Dashboard%20-%20v61.gif)

### Contents
* [Prerequisites](#prerequisites)
* [Key Features](#key-features)
* [pfelk overview](#pfelk-overview)
* [Installation](#installation)
  * [docker](#docker-compose)
  * [script installation](#script-installation-method)
  * [manual installation](#manual-installation-method)
* [Roadmap](#roadmap)
* [Comparison to similar solutions](#comparison-to-similar-solutions)
* [Contributing](#contributing)
* [License](#license)

### Prerequisites
- Ubuntu Server v20.04+ or Debian Server 11+ (stretch and buster tested)
- pfSense v2.5.0+ or OPNsense 23.0+
- Minimum of 8GB of RAM (Docker requires more) and recommend 32GB ([WiKi Reference](https://github.com/pfelk/pfelk/wiki/How-To:-Performance))
- Setting up remote logging ([WiKi Reference](https://github.com/pfelk/pfelk/wiki/How-To:-Prerequisite-%7C--pfSense-OPNsense-Logging))

**pfelk** is a highly customizable **open-source** tool for ingesting and visualizing your firewall traffic with the full power of Elasticsearch, Logstash and Kibana.

### Key features:

- **ingest** and **enrich** your pfSense/OPNsense **firewall traffic** logs by leveraging *Logstash*

- **search** your indexed data in *near-real-time* with the full power of the *Elasticsearch*

- **visualize** you network traffic with interactive dashboards, Maps, graphs in *Kibana*

Supported entries include:
 - pfSense/OPNSense setups
 - TCP/UDP/ICMP protocols
 - DHCP (v4/v6) message types with dashboard
 - IPv4/IPv6 mapping
 - pfSense CARP data
 - openVPN log parsing
 - Unbound DNS Resolver with dashboard and Kibana SIEM compliance
 - Suricata IDS with dashboard and Kibana SIEM compliance
 - Snort IDS with dashboard and Kibana SIEM compliance 
 - Squid with dashboard and Kibana SIEM compliance
 - HAProxy with dashboard
 - Captive Portal with dashboard
 - NGINX with dashboard

**pfelk** aims to replace the vanilla pfSense/OPNsense web UI with extended search and visualization features. You can deploy this solution via **ansible-playbook**, **docker-compose**, **bash script**, or manually.

### pfelk overview
* ![pfelk-overview](https://github.com/pfelk/pfelk/raw/main/Images/pfelk-visual.png)

### Quick start

### Installation

#### docker-compose
 * [Manual Method](https://github.com/pfelk/pfelk/blob/main/install/docker.md) or [Scripted Installed](#) - Scripted Method Coming Soon
 * `$ docker-compose up`
 * [![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=MJVbLvdVtyY) Guide (Update Coming Soon

#### script installation method
* Download installer script from [pfelk](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/scripts/pfelk-installer.sh) repository
* `$ wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/scripts/pfelk-installer.sh`
* Make script executable 
* `$ chmod +x pfelk-installer.sh`
* Run installer script 
* `$ sudo ./pfelk-installer.sh`
* Configure Security [here](https://github.com/pfelk/pfelk/blob/main/install/security.md)
* Templates [here](https://github.com/pfelk/pfelk/blob/main/install/templates.md)
* Finish Configuring [here](https://github.com/pfelk/pfelk/blob/main/install/configuration.md)
* [![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=qcGcsQQoPo0) Guide

#### manual installation method
* [Ubuntu 20.04-22.04](https://github.com/pfelk/pfelk/blob/main/install/preparation.md)
* [Debian 11-12](https://github.com/pfelk/pfelk/blob/main/install/preparation.md)
* [Docker](https://github.com/pfelk/pfelk/blob/main/install/docker.md)
* [![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=_IJAAUqNVRc) Guide

### Roadmap
This is the experimental public roadmap for the pfelk project.

[See the roadmap »](https://github.com/orgs/pfelk/projects/11)

### Comparison to similar solutions
[Comparisions »](https://github.com/pfelk/pfelk/wiki/Comparison)

### Contributing
Please reference to the [CONTRIBUTING file](https://github.com/pfelk/pfelk/blob/main/CONTRIBUTING.md). Collectively we can enhance and improve this product. Issues, feature requests, PRs, and documentation contributions are encouraged and welcomed!

### License
This project is licensed under the terms of the Apache 2.0 open source license. Please refer to [LICENSE](https://github.com/pfelk/pfelk/blob/main/license) for the full terms.
