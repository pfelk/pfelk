## Welcome to (pfSense/OPNsense) + Elastic Stack 

![pfelk dashboard](https://github.com/a3ilson/pfelk/raw/master/Images/pfelkdashboard.png)

You can view installation guide guide on [3ilson.org YouTube Channel](https://www.youtube.com/3ilsonorg).


![Version badge](https://img.shields.io/badge/ELK-7.5.2-blue.svg)

### Prerequisites
- Ubuntu Server v18.04+
- pfSense v2.4.4+ or OPNsense 19.7.4+
- The following was tested with Java v13 and Elastic Stack v7.5

## Table of Contents

- [Background](#background)
- [Install](#install)
- [Usage](#usage)
- [Contribute](#contribute)
- [License](#license)

## Background
pfELK was created in 2016 after spending hours researching firewall visualization.  After stumbling across Elasticstack (formerly known as ELK stack) with weeks of troubleshooting and research.  The process was refined and shared to aid others in leveraging the awesome power of Elasticsearch through the visualization of firewall events.

pfELK is comprised of Java, Elasticstack, and a number and dependencies. Your firewall logs are parsed through various patterns simplifying firewall log analysis.  Currently, pfSense and OPNsense are supported with extensive testing

## Install
Please forgive our progress as we modernize the installation process.  There are currently three installation options as we seek to automate the installation process.
- 1. [Manual (custom) Installation](install/custom.md)
- 2. [Scripted Installation](install/script.md)
- 3. [Ansible Installation](install/ansible.md)

## Usage
Once pfELK is running, point your browser to "http://pfELK's-IP:5601" to access the Kibana interface.  

## Contribute
Please reference to the [CONTRIBUTING.md](CONTRIBUTING.md). Collectively we can enhance and improve this product.  Issues, feature requests, pulls, and documentation contributions in are encouraged and welcomed!  

## License
This project is licensed under the terms of the Apache 2.0 open source license. Please refer to [LICENSE](LICENSE) for the full terms.
