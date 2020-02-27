#!/bin/sh
# Use this script to install OS dependencies, downloading and compile pfELK dependencies

# This script will
# * use apt-get/yum to install OS dependancies
# * download known working versions of pfELK dependancies
# * configure pfELK <-- In Work... Configuration Script
# * install Elasticstack
# * install Java
# * install Maxmind (GeoIP) <-- In Work... Configuration Script
# * install apt-trasnport-https (ATH)

# Check the existance of sudo
command -v sudo >/dev/null 2>&1 || { echo >&2 "pfELK: sudo is required to be installed"; exit 1; }

# Installing pfELK dependencies
echo "pfELK: Installing Inital Dependencies & Added Respositories"
if [ -f "/etc/redhat-release" ] || [ -f "/etc/system-release" ]; then
  sudo yum -y install wget apt-transport-https; sudo yum add-apt-repository ppa:linuxuprising/java; sudo yum add-apt-repository ppa:maxmind/ppa; sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list; sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  if [ $? -ne 0 ]; then
    echo "pfELK: yum failed"
    exit 1
  fi
fi

if [ -f "/etc/debian_version" ]; then
  sudo apt-get -qq install wget apt-transport-https; sudo add-apt-repository ppa:linuxuprising/java; sudo add-apt-repository ppa:maxmind/ppa; sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list; sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#if [ "$UNAME" = "FreeBSD" ]; then
#  sudo pkg_add -Fr wget apt-transport-https; sudo add-apt-repository ppa:linuxuprising/java; sudo add-apt-repository ppa:maxmind/ppa; sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list; sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
#  MAKE=gmake
#fi

# Update Required Respositories
echo "pfELK: Updating Respositories"
if [ -f "/etc/redhat-release" ] || [ -f "/etc/system-release" ]; then
  sudo yum -y update
  if [ $? -ne 0 ]; then
    echo "pfELK: yum failed"
    exit 1
  fi
fi

if [ -f "/etc/debian_version" ]; then
  sudo apt-get -qq update 
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#if [ "$UNAME" = "FreeBSD" ]; then
#  sudo pkg_add -Fr update
#  MAKE=gmake
#fi

# Install Required Respositories
echo "pfELK: Installing Required Respositories"
if [ -f "/etc/redhat-release" ] || [ -f "/etc/system-release" ]; then
  sudo yum -y install oracle-java13-installer; sudo apt-get -qq install geoipupdate; sudo apt-get -qq install elasticsearch; sudo apt-get -qq install kibana; sudo apt-get -qq install logstash
  if [ $? -ne 0 ]; then
    echo "pfELK: yum failed"
    exit 1
  fi
fi

if [ -f "/etc/debian_version" ]; then
  sudo apt-get -qq install oracle-java13-installer; sudo apt-get -qq install geoipupdate; sudo apt-get -qq install elasticsearch; sudo apt-get -qq install kibana; sudo apt-get -qq install logstash
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#if [ "$UNAME" = "FreeBSD" ]; then
#  sudo pkg_add -Fr install oracle-java13-installer; sudo apt-get -qq install geoipupdate; sudo apt-get -qq install elasticsearch; sudo apt-get -qq install kibana; sudo apt-get -qq install logstash
#  MAKE=gmake
#fi

# System Configuration
echo "pfELK: System Optimization"
sudo swapoff -a

# Download Configuration & Pattern
  echo "pfELK: Retrieving Confguration Files"
  sudo mkdir /etc/logstash/conf.d/patterns
  cd /etc/logstash/conf.d
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/conf.d/01-inputs.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/conf.d/11-firewall.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/conf.d/20-geoip.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/conf.d/50-outputs.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/conf.d/12-suricata.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/conf.d/13-snort.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/conf.d/15-others.conf
  cd /etc/logstash/conf.d/patterns
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/conf.d/patterns/pf-12.2019.grok

# Add Configuraiton Script Here

# Install/Troubleshoot Success Mesaage 

exit 0
