# Ansible Installation Guide (pfSense/OPNsense) + Elastic Stack 

## Table of Contents
- [Installation](#installation)
- [Configuration](#configuration)

## Prerequisites 

### Prerequisites on control nodes

Currently Ansible can be run from any machine with Python 2 (version 2.7) or Python 3 (versions 3.5 and higher) installed. Windows is not supported for the control node.

Take a look at the following link regarding further details on initial requirements: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

### Add Ansible apt repository and install the package for Ubuntu
```
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo apt-add-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
```

### Create Ansible configuration (optional)

```
$ vi ~/.ansible.cfg

[defaults]
# disable key check if host is not initially in 'known_hosts'
host_key_checking = False

[ssh_connection]
# if True, make ansible use scp if the connection type is ssh (default is sftp)
scp_if_ssh = True
```


### Prerequisites on managed nodes

On the managed nodes, you need a way to communicate, which is normally ssh. By default this uses sftp. If that’s not available, you can switch to scp in ansible.cfg. You also need Python 2 (version 2.6 or later) or Python 3 (version 3.5 or later).

### Tree of Ansible setup
```
ansible-pfelk/
├── hosts
└── install
    ├── group_vars
    │   └── all.yml
    ├── install.yml
    └── roles
        ├── elasticsearch
        │   ├── files
        │   │   └── elasticsearch.yml
        │   ├── handlers
        │   │   └── main.yml
        │   └── tasks
        │       └── main.yml
        ├── java
        │   └── tasks
        │       └── main.yml
        ├── kibana
        │   ├── files
        │   │   └── kibana.yml
        │   ├── handlers
        │   │   └── main.yml
        │   └── tasks
        │       └── main.yml
        ├── logstash
        │   ├── files
        │   │   ├── 01-inputs.conf
        │   │   ├── 11-firewall.conf
        │   │   ├── 12-suricata.conf
        │   │   ├── 13-snort.conf
        │   │   ├── 15-others.conf
        │   │   ├── 20-geoip.conf
        │   │   ├── 50-outputs.conf
        │   │   └── patterns
        │   │       └── pf-12.2019.grok
        │   ├── handlers
        │   │   └── main.yml
        │   └── tasks
        │       └── main.yml
        └── maxmind
            └── tasks
                └── main.yml
```


### Clone the repository

```
$ git clone https://github.com/a3ilson/pfelk.git
```


### Define the host you want to deploy the ELK stack to
Provide your target IP address in `ansible-pfelk/hosts` under `elk`, the ELK stak will be installed to this target.

### Change current folder to ansible-elk/ then deploy the playbook
```
$ cd ansible-pfelk/
$ ansible-playbook -i hosts --ask-become install/install.yml
```

This will take care of the following tasks:
 - install java
 - install maxmind
   - download GeoIP databases
   - setup a cron job for automated updates
 - install elasticsearch
 - install kibana
 - install logstash
   - copy the `.conf` files and patterns to their corresponding locations

### Manually register and configure Maxmind

### Configure Maxmind
- Create a Max Mind Account @ https://www.maxmind.com/en/geolite2/signup
- Login to your Max Mind Account; navigate to "My License Key" under "Services" and Generate new license key
```
$ sudo nano /etc/GeoIP.conf
```
- Modify lines 7 & 8 as follows (without < >):
```
AccountID <Input Your Account ID>
LicenseKey <Input Your LicenseKey>
```
## Finish the configuration

You can follow the steps starting with the Firewall section at https://github.com/a3ilson/pfelk/blob/master/install/configuration.md

## Troubleshooting

### Testing the playbook with dry-mode
 - include `--check` flag
 - run `ansible-playbook -i hosts --check install/install.yml`

### Deploy to localhost
To deploy the playbook to your local machine you need the do following:
 - install and setup `openssh`on your machine
 - if you choose not to use ssh keys, install `sshpass` for auth purposes
 - under `ansible-pfelk/hosts` define your IP as `localhost`
 - run the playbook with: `ansible-playbook -i hosts --ask-pass --ask-become install/install.yml`
 
### Enable verbose mode to debug problems
 - include `-vvvv` flag
 - run `ansible-playbook -i hosts --ask-pass --ask-become -vvvv install/install.yml`
