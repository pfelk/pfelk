## Welcome to (pfSense/OPNsense) + Elastic Stack  

![pfelk dashboard](https://github.com/a3ilson/pfelk/raw/master/Images/pfelk-dashboard.png)

You can view installation guide guide on [3ilson.org YouTube Channel](https://www.youtube.com/3ilsonorg).


![Version badge](https://img.shields.io/badge/ELK-7.6.1-blue.svg)
![Travis (.org)](https://img.shields.io/travis/3ilson/ansible-pfelk?label=Ansible-playbook) ![Travis (.org)](https://img.shields.io/travis/3ilson/docker-pfelk?label=Docker-compose) [![Gitter](https://badges.gitter.im/pfelk/community.svg)](https://gitter.im/pfelk/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/a3ilson) 
### Prerequisites
- Ubuntu Server v18.04+ or Debian Server 9+ (stretch and buster are tested)
- pfSense v2.4.4+ or OPNsense 19.7.4+
- The following was tested with Java v13 and Elastic Stack v7.6.0
- Minimum of 4GB of RAM but recommend 32GB

## Table of Contents

- [Background](#background)
- [Install](#install)
- [Usage](#usage)
- [Contribute](#contribute)
- [License](#license)

## Background
pfELK was created in 2016 after spending hours researching firewall visualization.  After stumbling across Elasticstack (formerly known as ELK stack) with weeks of troubleshooting and research.  The process was refined and shared to aid others in leveraging the awesome power of Elasticsearch through the visualization of firewall events.

pfELK is comprised of Java, Elasticstack, and a number of dependencies. Your firewall logs are parsed through various patterns simplifying firewall log analysis.  Currently, pfSense and OPNsense are supported with extensive testing.

## Install
Please forgive our progress as we modernize the installation process.  There are currently three installation options as we seek to automate the installation process.
- 1. [Manual (custom) Installation](install/ubuntu.md) - Ubuntu 
- 1. [Manual (custom) Installation](install/debian.md) - Debian 
- 2. [Scripted Installation](install/script.md)
- 3. [Ansible Installation](https://github.com/3ilson/ansible-pfelk)
- 4. [Docker Installation](https://github.com/3ilson/docker-pfelk)

## Usage
Once pfELK is running, point your browser to "http://pfELK's-IP:5601" to access the Kibana interface.  

## Contribute
Please reference to the [CONTRIBUTING.md](CONTRIBUTING.md). Collectively we can enhance and improve this product.  Issues, feature requests, pulls, and documentation contributions in are encouraged and welcomed!  

## License
This project is licensed under the terms of the Apache 2.0 open source license. Please refer to [LICENSE](LICENSE) for the full terms.
