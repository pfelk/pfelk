#!/bin/sh
# Use this script to install OS dependencies, downloading and compile pfELK dependencies

# This script will
# * use apt-get/yum to install OS dependancies
# * download known working versions of pfELK dependencies
# * configure pfELK <-- In Work... Configuration Script
# * install Elasticstack
# * install Java 11 LTS
# * install Maxmind (GeoIP) <-- In Work... Configuration Script
# * install apt-trasnport-https (ATH)

# Check the existance of sudo
command -v sudo >/dev/null 2>&1 || { echo >&2 "pfELK: sudo is required to be installed"; exit 1; }

# Installing pfELK dependencies
echo "pfELK: Installing Inital Dependencies & Added Respositories"

#Redhat
if [ -f "/etc/redhat-release" ] || [ -f "/etc/system-release" ]; then
  sudo yum -y install wget apt-transport-https; sudo yum add-apt-repository ppa:maxmind/ppa; sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list; sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  if [ $? -ne 0 ]; then
    echo "pfELK: yum failed"
    exit 1
  fi
fi

#Debian
if hostnamectl | grep 'Operating System: Debian*' > /dev/null; then
  sudo apt-get -qq install wget apt-transport-https gnupg2 software-properties-common dirmngr lsb-release ca-certificates; sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list; sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#Ubuntu
if hostnamectl | grep 'Operating System: Ubuntu*' > /dev/null; then
  sudo apt-get -qq install wget apt-transport-https; sudo add-apt-repository ppa:maxmind/ppa; sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list; sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#FreeBSD (forthcoming)
#if [ "$UNAME" = "FreeBSD" ]; then
#  sudo pkg_add -Fr wget apt-transport-https; sudo add-apt-repository ppa:maxmind/ppa; sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list; sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
#  MAKE=gmake
#fi


# Update Required Respositories
echo "pfELK: Updating Respositories"
#Redhat
if [ -f "/etc/redhat-release" ] || [ -f "/etc/system-release" ]; then
  sudo yum -y update
  if [ $? -ne 0 ]; then
    echo "pfELK: yum failed"
    exit 1
  fi
fi

#Debian
if hostnamectl | grep 'Operating System: Debian*' > /dev/null; then
  sudo apt-get -qq update
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#Ubuntu
if hostnamectl | grep 'Operating System: Ubuntu*' > /dev/null; then
  sudo apt-get -qq update 
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#FreeBSD (forthcoming)
#if [ "$UNAME" = "FreeBSD" ]; then
#  sudo pkg_add -Fr update
#  MAKE=gmake
#fi

# Install Required Respositories
echo "pfELK: Installing Required Respositories - This may take some time, please be patient"

#Redhat
if [ -f "/etc/redhat-release" ] || [ -f "/etc/system-release" ]; then
  sudo yum -y install openjdk-11-jre-headless; sudo apt-get -qq install geoipupdate; sudo apt-get -qq install elasticsearch; sudo apt-get -qq install kibana; sudo apt-get -qq install logstash
  if [ $? -ne 0 ]; then
    echo "pfELK: yum failed"
    exit 1
  fi
fi

#Debian
if hostnamectl | grep 'Operating System: Debian*' > /dev/null; then
  sudo apt-get -qq install openjdk-11-jre-headless; sudo apt-get -qq install elasticsearch; sudo apt-get -qq install kibana; sudo apt-get -qq install logstash; cd $HOME; wget https://github.com/maxmind/geoipupdate/releases/download/v4.3.0/geoipupdate_4.3.0_linux_amd64.deb; sudo dpkg -i ./geoipupdate_4.3.0_linux_amd64.deb
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#Ubuntu
if hostnamectl | grep 'Operating System: Ubuntu*' > /dev/null; then
  sudo apt-get -qq install openjdk-11-jre-headless; sudo apt-get -qq install geoipupdate; sudo apt-get -qq install elasticsearch; sudo apt-get -qq install kibana; sudo apt-get -qq install logstash
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi


#FreeBSD (forthcoming)
#if [ "$UNAME" = "FreeBSD" ]; then
#  sudo pkg_add -Fr install openjdk-11-jre; sudo apt-get -qq install geoipupdate; sudo apt-get -qq install elasticsearch; sudo apt-get -qq install kibana; sudo apt-get -qq install logstash
#  MAKE=gmake
#fi

# System Configuration
echo "pfELK: System Optimization"
sudo swapoff -a

# Download Configuration & Pattern
  echo "pfELK: Retrieving Confguration Files"
  sudo mkdir /etc/logstash/conf.d/patterns
  sudo mkdir /etc/logstash/conf.d/templates
  cd /etc/logstash/conf.d
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/01-inputs.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/05-firewall.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/10-others.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/20-suricata.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/25-snort.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/30-geoip.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/35-rules-desc.conf
# sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/40-dns.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/45-cleanup.conf
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/50-outputs.conf
  cd /etc/logstash/conf.d/patterns
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/patterns/pfelk.grok
  cd /data/pfELK/templates
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/templates/pf-geoip-template.json
  cd /etc/kibana
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/kibana.yml
##
# Add Configuration Script Here
## MaxMind GeoIP Install.
      #GeoIP Cron Job.
      echo 00 17 * * 0 geoipupdate -d /usr/share/GeoIP > /etc/cron.weekly/geoipupdate
      sed -i 's/EditionIDs.*/EditionIDs GeoLite2-Country GeoLite2-City GeoLite2-ASN/g' /etc/GeoIP.conf
      sed -i "s/.*DatabaseDirectory.*/DatabaseDirectory \/data\/pfELK\/GeoIP\//g" /etc/GeoIP.conf
      maxmind_username=$(echo "${maxmind_username}")
      maxmind_password=$(echo "${maxmind_password}")
      read -p "Enter your MaxMind Account ID: " maxmind_username
      read -p "Enter your MaxMind Password: " maxmind_password
      sed -i "s/AccountID.*/AccountID ${maxmind_username}/g" /etc/GeoIP.conf
      sed -i "s/LicenseKey.*/LicenseKey ${maxmind_password}/g" /etc/GeoIP.conf
      echo -e "\\n";
      geoipupdate

# Install/Troubleshoot Success Message
echo "pfELK: Finalizing Installtion"
  sudo mkdir -p /etc/pfELK
  cd /etc/pfELK
  sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/error-data.sh
  sudo chmod +x /etc/pfELK/error-data.sh
  curl https://raw.githubusercontent.com/3ilson/pfelk/master/readme.txt
exit 0
