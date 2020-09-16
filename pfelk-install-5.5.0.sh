#!/bin/bash

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                   pfELK Easy Installation Script                                                                                #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################
# 
# OS       | List of Supported Distributions/OS
#
#          | Ubuntu Xenial Xerus ( 16.04 )
#          | Ubuntu Bionic Beaver ( 18.04 )
#          | Ubuntu Cosmic Cuttlefish ( 18.10 )
#          | Ubuntu Disco Dingo  ( 19.04 )
#          | Ubuntu Eoan Ermine  ( 19.10 )
#          | Ubuntu Focal Fossa  ( 20.04 )
#          | Debian Stretch ( 9 )
#          | Debian Buster ( 10 )
#          | Debian Bullseye ( 11 )
#
# Version    | 5.5.0
# Email      | andrew@pfelk.com
# Website    | https://pfelk.3ilson.dev
#
###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                   Dynamic Dependency Version                                                                                    #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################
#
# MaxMind      | https://github.com/maxmind/geoipupdate/releases
# GeoIP        | 4.3.0
# Java         | openjdk-11-jre-headless
# Jave_Version | 11
# Elastistack  | 7.9.1
#
###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                           Color Codes                                                                                           #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

RESET='\033[0m'
#GRAY='\033[0;37m'
#WHITE='\033[1;37m'
GRAY_R='\033[39m'
WHITE_R='\033[39m'
RED='\033[1;31m' # Light Red.
GREEN='\033[1;32m' # Light Green.
#BOLD='\e[1m'

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                           Start Checks                                                                                          #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

header() {
  clear
  clear
  echo -e "${GREEN}#####################################################################################################${RESET}\\n"
}

header_red() {
  clear
  clear
  echo -e "${RED}#####################################################################################################${RESET}\\n"
}

# Check for root (sudo)
if [[ "$EUID" -ne 0 ]]; then
  header_red
  echo -e "${WHITE_R}#${RESET} The script need to be run as root...\\n\\n"
  echo -e "${WHITE_R}#${RESET} For Ubuntu based systems run the command below to login as root"
  echo -e "${GREEN}#${RESET} sudo -i\\n"
  echo -e "${WHITE_R}#${RESET} For Debian based systems run the command below to login as root"
  echo -e "${GREEN}#${RESET} su\\n\\n"
  exit 1
fi

if ! env | grep "LC_ALL\\|LANG" | grep -iq "en_US\\|C.UTF-8"; then
  header
  echo -e "${WHITE_R}#${RESET} Your language is not set to English ( en_US ), the script will temporarily set the language to English."
  echo -e "${WHITE_R}#${RESET} Information: This is done to prevent issues in the script..."
  export LC_ALL=C &> /dev/null
  set_lc_all=true
  sleep 3
fi

abort() {
  if [[ "${set_lc_all}" == 'true' ]]; then unset LC_ALL; fi
  echo -e "\\n\\n${RED}#########################################################################${RESET}\\n"
  echo -e "${WHITE_R}#${RESET} An error occurred. Aborting script..."
  echo -e "${WHITE_R}#${RESET} Please open an issue (pfelk.3ilson.dev) on github!\\n"
  echo -e "${WHITE_R}#${RESET} Creating support file..."
  mkdir -p "/tmp/pfELK/support" &> /dev/null
  if dpkg -l lsb-release 2> /dev/null | grep -iq "^ii\\|^hi"; then lsb_release -a &> "/tmp/pfELK/support/lsb-release"; fi
  df -h &> "/tmp/pfELK/support/df"
  free -hm &> "/tmp/pfELK/support/memory"
  uname -a &> "/tmp/pfELK/support/uname"
  dpkg -l | grep "openjdk" &> "/tmp/pfELK/support/packages"
  dpkg -l &> "/tmp/pfELK/support/dpkg-list"
  echo "${architecture}" &> "/tmp/pfELK/support/architecture"
  sed -n '3p' "$0" &>> "/tmp/pfELK/support/script"
  grep "# Version" "$0" | head -n1 &>> "/tmp/pfELK/support/script"
  if dpkg -l tar 2> /dev/null | grep -iq "^ii\\|^hi"; then
    tar -cvf /tmp/pfELK_support.tar.gz "/tmp/pfELK" "${pfELK_dir}" &> /dev/null && support_file="/tmp/pfELK_support.tar.gz"
  elif dpkg -l zip 2> /dev/null | grep -iq "^ii\\|^hi"; then
    zip -r /tmp/pfELK_support.zip "/tmp/pfELK/*" "${pfELK_dir}/*" &> /dev/null && support_file="/tmp/pfELK_support.zip"
  fi
  if [[ -n "${support_file}" ]]; then echo -e "${WHITE_R}#${RESET} Support file has been created here: ${support_file} \\n"; fi
  if [[ -f /tmp/pfELK/services/stopped_list && -s /tmp/pfELK/services/stopped_list ]]; then
    while read -r service; do
      echo -e "\\n${WHITE_R}#${RESET} Starting ${service}..."
      systemctl start "${service}" && echo -e "${GREEN}#${RESET} Successfully started ${service}!" || echo -e "${RED}#${RESET} Failed to start ${service}!"
    done < /tmp/pfELK/services/stopped_list
  fi
  exit 1
}

if uname -a | tr '[:upper:]' '[:lower:]'; then
  pfELK_dir='/data/pfELK'
fi

script_logo() {
  cat << "EOF"

        ________________.____     ____  __. .___                 __         .__  .__                
_______/ ____\_   _____/|    |   |    |/ _| |   | ____   _______/  |______  |  | |  |   ___________ 
\____ \   __\ |    __)_ |    |   |      <   |   |/    \ /  ___/\   __\__  \ |  | |  | _/ __ \_  __ \
|  |_> >  |   |        \|    |___|    |  \  |   |   |  \\___ \  |  |  / __ \|  |_|  |_\  ___/|  | \/
|   __/|__|  /_______  /|_______ \____|__ \ |___|___|  /____  > |__| (____  /____/____/\___  >__|   
|__|                 \/         \/       \/          \/     \/            \/               \/   

    Easy pfELK Install Script
EOF
}

start_script() {
  mkdir -p /tmp/pfELK/logs 2> /dev/null
  mkdir -p /tmp/pfELK/upgrade/ 2> /dev/null
  mkdir -p /tmp/pfELK/dpkg/ 2> /dev/null
  mkdir -p /tmp/pfELK/geoip/ 2> /dev/null  
  mkdir -p /data/pfELK/logs/ 2> /dev/null  
  header
  script_logo
  echo -e "\\n${WHITE_R}#${RESET} Starting the Easy pfELK Install Script..."
  echo -e "${WHITE_R}#${RESET} Thank you for using Easy pfELK Install Script :-)\\n\\n"
  sleep 4
}
start_script

help_script() {
  if [[ "${script_option_help}" == 'true' ]]; then header; script_logo; else echo -e "${WHITE_R}----${RESET}\\n"; fi
  echo -e "    Easy pfELK Install Script Options\\n"
  echo -e "
  Script usage:
  bash $0 [options]
  
  Script options:
  --clean                  Purges pfELK (Elasticstack+pfELK)
  --help 			       Displays this information :) 
  --noelastic			   Do not install Elasticsearch
  --nogeoip                Do not install MaxMind GeoIP 
  --noip				   Do not configure firewall IP Address. 
  						   Must Configure Manually via:
                           /data/pfELK/01-inputs.conf
  --nojava				   Do not install openjdk-11-jre
  --nosense                Do not configure pfSense/OPNsense.  
                           Must Configure Manually via:
                           /data/pfELK/01-inputs.conf\\n\\n"
  exit 0
}

rm --force /tmp/pfELK/script_options &> /dev/null
script_option_list=(--clean --help --nogeoip --noip --nojava --nosense)

while [ -n "$1" ]; do
  case "$1" in
  --clean)
       script_options_clean=true
       # Note: Will configure to purge Elasticsearch, logstash, kibana and delete (rm -rf /data/pfELK)
       ;;
  --help)
       script_option_help=true
       help_script;;
  --noelasticsearch)
       script_option_elasticsearch=true
       echo "--noelasticsearch" &>> /tmp/pfELK/script_options;;
  --nogeoip)
       script_option_geoip=true
       echo "--nogeoip" &>> /tmp/pfELK/script_options;;
  --noip)
       echo "--noip" &>> /tmp/pfELK/script_options;;
  --nojava)
       script_option_nojava=true
       echo "--nojava" &>> /tmp/pfELK/script_options;;
  --nosense)
       script_option_nosense=true
       echo "--nosense" &>> /tmp/pfELK/script_options;;
  esac
  shift
done

# Check script options
if [[ -f /tmp/pfELK/script_options && -s /tmp/pfELK/script_options ]]; then IFS=" " read -r -a script_options <<< "$(tr '\r\n' ' ' < /tmp/pfELK/script_options)"; fi

# shellcheck disable=SC2016
grep -io '${pfELK_dir}/logs/.*log' "$0" | grep -v 'awk' | awk '!a[$0]++' &> /tmp/pfELK/log_files
while read -r log_file; do
  if [[ -f "${log_file}" ]]; then
    log_file_size=$(stat -c%s "${log_file}")
    if [[ "${log_file_size}" -gt "10000000" ]]; then
      tail -n1000 "${log_file}" &> "${log_file}.tmp"
      cp "${log_file}.tmp" "${log_file}"; rm --force "${log_file}.tmp" &> /dev/null
    fi
  fi
done < /tmp/pfELK/log_files
rm --force /tmp/pfELK/log_files

run_apt_get_update() {
  if ! [[ -d /tmp/pfELK/keys ]]; then mkdir -p /tmp/pfELK/keys; fi
  if ! [[ -f /tmp/pfELK/keys/missing_keys && -s /tmp/pfELK/keys/missing_keys ]]; then
    if [[ "${hide_apt_update}" == 'true' ]]; then
      echo -e "${WHITE_R}#${RESET} Running apt-get update..."
      if apt-get update &> /tmp/pfELK/keys/apt_update; then echo -e "${GREEN}#${RESET} Successfully ran apt-get update! \\n"; else echo -e "${YELLOW}#${RESET} Something went wrong during running apt-get update! \\n"; fi
      unset hide_apt_update
    else
      apt-get update 2>&1 | tee /tmp/pfELK/keys/apt_update
    fi
    grep -o 'NO_PUBKEY.*' /tmp/pfELK/keys/apt_update | sed 's/NO_PUBKEY //g' | tr ' ' '\n' | awk '!a[$0]++' &> /tmp/pfELK/keys/missing_keys
  fi
  if [[ -f /tmp/pfELK/keys/missing_keys && -s /tmp/pfELK/keys/missing_keys ]]; then
    #header
    #echo -e "${WHITE_R}#${RESET} Some keys are missing... The script will try to add the missing keys."
    #echo -e "\\n${WHITE_R}----${RESET}\\n"
    while read -r key; do
      echo -e "${WHITE_R}#${RESET} Key ${key} is missing... adding!"
      http_proxy=$(env | grep -i "http.*Proxy" | cut -d'=' -f2 | sed 's/[";]//g')
      if [[ -n "$http_proxy" ]]; then
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --keyserver-options http-proxy="${http_proxy}" --recv-keys "$key" &> /dev/null && echo -e "${GREEN}#${RESET} Successfully added key ${key}!\\n" || fail_key=true
      elif [[ -f /etc/apt/apt.conf ]]; then
        apt_http_proxy=$(grep "http.*Proxy" /etc/apt/apt.conf | awk '{print $2}' | sed 's/[";]//g')
        if [[ -n "${apt_http_proxy}" ]]; then
          apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --keyserver-options http-proxy="${apt_http_proxy}" --recv-keys "$key" &> /dev/null && echo -e "${GREEN}#${RESET} Successfully added key ${key}!\\n" || fail_key=true
        fi
      else
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv "$key" &> /dev/null && echo -e "${GREEN}#${RESET} Successfully added key ${key}!\\n" || fail_key=true
      fi
      if [[ "${fail_key}" == 'true' ]]; then
        echo -e "${RED}#${RESET} Failed to add key ${key}!"
        echo -e "${WHITE_R}#${RESET} Trying different method to get key: ${key}"
        gpg -vvv --debug-all --keyserver keyserver.ubuntu.com --recv-keys "${key}" &> /tmp/pfELK/keys/failed_key
        debug_key=$(grep "KS_GET" /tmp/pfELK/keys/failed_key | grep -io "0x.*")
        wget -q "https://keyserver.ubuntu.com/pks/lookup?op=get&search=${debug_key}" -O- | gpg --dearmor > "/tmp/pfELK/keys/pfELK-${key}.gpg"
        mv "/tmp/pfELK/keys/pfELK-${key}.gpg" /etc/apt/trusted.gpg.d/ && echo -e "${GREEN}#${RESET} Successfully added key ${key}!\\n"
      fi
      sleep 1
    done < /tmp/pfELK/keys/missing_keys
    rm --force /tmp/pfELK/keys/missing_keys
    rm --force /tmp/pfELK/keys/apt_update
    #header
    #echo -e "${WHITE_R}#${RESET} Running apt-get update again.\\n\\n"
    #sleep 2
    apt-get update &> /tmp/pfELK/keys/apt_update
    if grep -qo 'NO_PUBKEY.*' /tmp/pfELK/keys/apt_update; then
      if [[ "${hide_apt_update}" == 'true' ]]; then hide_apt_update=true; fi
      run_apt_get_update
    fi
  fi
}

cancel_script() {
  if [[ "${set_lc_all}" == 'true' ]]; then unset LC_ALL &> /dev/null; fi
  header
  echo -e "${WHITE_R}#${RESET} Cancelling the script!\\n\\n"
  exit 0
}

http_proxy_found() {
  header
  echo -e "${GREEN}#${RESET} HTTP Proxy found. | ${WHITE_R}${http_proxy}${RESET}\\n\\n"
}

remove_yourself() {
  if [[ "${set_lc_all}" == 'true' ]]; then unset LC_ALL &> /dev/null; fi
  if [[ "${delete_script}" == 'true' || "${script_option_skip}" == 'true' ]]; then
    if [[ -e "$0" ]]; then
      rm --force "$0" 2> /dev/null
    fi
  fi
}

# Get distro
get_distro() {
  if [[ -z "$(command -v lsb_release)" ]]; then
    if [[ -f "/etc/os-release" ]]; then
      if grep -iq VERSION_CODENAME /etc/os-release; then
        os_codename=$(grep VERSION_CODENAME /etc/os-release | sed 's/VERSION_CODENAME//g' | tr -d '="' | tr '[:upper:]' '[:lower:]')
      elif ! grep -iq VERSION_CODENAME /etc/os-release; then
        os_codename=$(grep PRETTY_NAME /etc/os-release | sed 's/PRETTY_NAME=//g' | tr -d '="' | awk '{print $4}' | sed 's/\((\|)\)//g' | sed 's/\/sid//g' | tr '[:upper:]' '[:lower:]')
        if [[ -z "${os_codename}" ]]; then
          os_codename=$(grep PRETTY_NAME /etc/os-release | sed 's/PRETTY_NAME=//g' | tr -d '="' | awk '{print $3}' | sed 's/\((\|)\)//g' | sed 's/\/sid//g' | tr '[:upper:]' '[:lower:]')
        fi
      fi
    fi
  else
    os_codename=$(lsb_release -cs | tr '[:upper:]' '[:lower:]')
    if [[ "${os_codename}" == 'n/a' ]]; then
      os_codename=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
      if [[ "${os_codename}" == 'parrot' ]]; then
        os_codename='buster'
      fi
    fi
    if [[ "${os_codename}" =~ (hera|juno) ]]; then os_codename=bionic; fi
    if [[ "${os_codename}" == 'loki' ]]; then os_codename=xenial; fi
    if [[ "${os_codename}" == 'debbie' ]]; then os_codename=buster; fi
  fi
  if [[ "${os_codename}" =~ (precise|maya) ]]; then
    repo_codename=precise
  elif [[ "${os_codename}" =~ (trusty|qiana|rebecca|rafaela|rosa) ]]; then
    repo_codename=trusty
  elif [[ "${os_codename}" =~ (xenial|sarah|serena|sonya|sylvia) ]]; then
    repo_codename=xenial
  elif [[ "${os_codename}" =~ (bionic|tara|tessa|tina|tricia) ]]; then
    repo_codename=bionic
  elif [[ "${os_codename}" =~ (stretch|continuum) ]]; then
    repo_codename=stretch
  elif [[ "${os_codename}" =~ (buster|debbie) ]]; then
    repo_codename=buster
  else
    repo_codename="${os_codename}"
  fi
}
get_distro

if ! [[ "${os_codename}" =~ (xenial|bionic|cosmic|disco|eoan|focal|stretch|buster|bullseye)  ]]; then
  clear
  header_red
  echo -e "${WHITE_R}#${RESET} This script is not made for your OS."
  echo -e "${WHITE_R}#${RESET} Feel free to contact pfELK (pfelk.3ilson.dev) on github, if you need help with installing pfELK or alternate installation options."
  echo -e ""
  echo -e "OS_CODENAME = ${os_codename}"
  echo -e ""
  echo -e ""
  exit 1
fi

if ! grep -iq '^127.0.0.1.*localhost' /etc/hosts; then
  clear
  header_red
  echo -e "${WHITE_R}#${RESET} '127.0.0.1   localhost' does not exist in your /etc/hosts file."
  echo -e "${WHITE_R}#${RESET} You may see experience issues if it does not exist..\\n\\n"
  read -rp $'\033[39m#\033[0m Do you want to add "127.0.0.1   localhost" to your /etc/hosts file? (Y/n) ' yes_no
  case "$yes_no" in
      [Yy]*|"")
          echo -e "${WHITE_R}----${RESET}\\n"
          echo -e "${WHITE_R}#${RESET} Adding '127.0.0.1       localhost' to /etc/hosts"
          sed  -i '1i # ------------------------------' /etc/hosts
          sed  -i '1i 127.0.0.1       localhost' /etc/hosts
          sed  -i '1i # Added by pfELK instalaltion script' /etc/hosts && echo -e "${WHITE_R}#${RESET} Done..\\n\\n"
          sleep 3;;
      [Nn]*) ;;
  esac
fi

if [[ $(echo "${PATH}" | grep -c "/sbin") -eq 0 ]]; then
  #PATH=/sbin:/bin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/local/bin
  #PATH=$PATH:/usr/sbin
  PATH="$PATH:/sbin:/bin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/local/bin"
fi

if ! [[ -d /etc/apt/sources.list.d ]]; then mkdir -p /etc/apt/sources.list.d; fi
if ! [[ -d /tmp/pfELK/keys ]]; then mkdir -p /tmp/pfELK/keys; fi

# Check if --show-progress is supported in wget version
if wget --help | grep -q '\--show-progress'; then echo "--show-progress" &>> /tmp/pfELK/wget_option; fi
if [[ -f /tmp/pfELK/wget_option && -s /tmp/pfELK/wget_option ]]; then IFS=" " read -r -a wget_progress <<< "$(tr '\r\n' ' ' < /tmp/pfELK/wget_option)"; fi

# Check if MaxMind GeoIP is already installed
if dpkg -l | grep "geoipupdate" | grep -q "^ii\\|^hi"; then
  header
  echo -e "${WHITE_R}#${RESET} MaxMind GeoIP is already installed on your system!${RESET}\\n\\n"
  read -rp $'\033[39m#\033[0m Would you like to remove MaxMind GeoIP? (Y/n) ' yes_no
  case "$yes_no" in
      [Yy]*|"")
        rm --force "$0" 2> /dev/null
        apt purge geoipupdate;;
      [Nn]*);;
  esac
fi

# Check if Elasticsearch is already installed
if dpkg -l | grep "elasticsearch" | grep -q "^ii\\|^hi"; then
  header
  echo -e "${WHITE_R}#${RESET} Elasticsearch is already installed on your system!${RESET}\\n\\n"
  read -rp $'\033[39m#\033[0m Would you like to remove Elasticsearch? (Y/n) ' yes_no
  case "$yes_no" in
      [Yy]*|"")
        rm --force "$0" 2> /dev/null
        apt purge elasticsearch;;
      [Nn]*);;
  esac
fi

# Check if Logstash is already installed
if dpkg -l | grep "logstash" | grep -q "^ii\\|^hi"; then
  header
  echo -e "${WHITE_R}#${RESET} Logstash is already installed on your system!${RESET}\\n\\n"
  read -rp $'\033[39m#\033[0m Would you like to remove Logstash? (Y/n) ' yes_no
  case "$yes_no" in
      [Yy]*|"")
        rm --force "$0" 2> /dev/null
        apt purge logstash;; 
      [Nn]*);; 
  esac
fi

# Check if Kibana is already installed
if dpkg -l | grep "kibana" | grep -q "^ii\\|^hi"; then
  header
  echo -e "${WHITE_R}#${RESET} Kibana is already installed on your system!${RESET}\\n\\n"
  read -rp $'\033[39m#\033[0m Would you like to remove Kibana? (Y/n) ' yes_no
  case "$yes_no" in
      [Yy]*|"")
        rm --force "$0" 2> /dev/null
        apt purge kibana;; 
      [Nn]*);;
  esac
fi

dpkg_locked_message() {
  header_red
  echo -e "${WHITE_R}#${RESET} dpkg is locked... Waiting for other software managers to finish!"
  echo -e "${WHITE_R}#${RESET} If this is everlasting, please open an issue on pfELK (pfelk.3ilson.dev) on github!\\n\\n"
  sleep 5
  if [[ -z "$dpkg_wait" ]]; then
    echo "pfelk_lock_active" >> /tmp/pfelk_lock
  fi
}

dpkg_locked_60_message() {
  header
  echo -e "${WHITE_R}#${RESET} dpkg is already locked for 60 seconds..."
  echo -e "${WHITE_R}#${RESET} Would you like to force remove the lock?\\n\\n"
}

# Check if dpkg is locked
if dpkg -l psmisc 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  while fuser /var/lib/dpkg/lock /var/lib/apt/lists/lock /var/cache/apt/archives/lock >/dev/null 2>&1; do
    dpkg_locked_message
    if [[ $(grep -c "pfelk_lock_active" /tmp/pfelk_lock) -ge 12 ]]; then
      rm --force /tmp/pfelk_lock 2> /dev/null
      dpkg_locked_60_message
      if [[ "${script_option_skip}" != 'true' ]]; then read -rp $'\033[39m#\033[0m Do you want to proceed with removing the lock? (Y/n) ' yes_no; fi
      case "$yes_no" in
          [Yy]*|"")
            killall apt apt-get 2> /dev/null
            rm --force /var/lib/apt/lists/lock 2> /dev/null
            rm --force /var/cache/apt/archives/lock 2> /dev/null
            rm --force /var/lib/dpkg/lock* 2> /dev/null
            dpkg --configure -a 2> /dev/null
            DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install --fix-broken 2> /dev/null;;
          [Nn]*) dpkg_wait=true;;
      esac
    fi
  done;
else
  dpkg -i /dev/null 2> /tmp/pfelk_dpkg_lock; if grep -q "locked.* another" /tmp/pfelk_dpkg_lock; then dpkg_locked=true; rm --force /tmp/pfelk_dpkg_lock 2> /dev/null; fi
  while [[ "${dpkg_locked}" == 'true'  ]]; do
    unset dpkg_locked
    dpkg_locked_message
    if [[ $(grep -c "pfelk_lock_active" /tmp/pfelk_lock) -ge 12 ]]; then
      rm --force /tmp/pfelk_lock 2> /dev/null
      dpkg_locked_60_message
      if [[ "${script_option_skip}" != 'true' ]]; then read -rp $'\033[39m#\033[0m Do you want to proceed with force removing the lock? (Y/n) ' yes_no; fi
      case "$yes_no" in
          [Yy]*|"")
            pgrep "apt" >> /tmp/pfELK/apt/apt
            while read -r pfelk_apt; do
              kill -9 "$pfelk_apt" 2> /dev/null
            done < /tmp/pfELK/apt/apt
            rm --force /tmp/pfelk_apt 2> /dev/null
            rm --force /var/lib/apt/lists/lock 2> /dev/null
            rm --force /var/cache/apt/archives/lock 2> /dev/null
            rm --force /var/lib/dpkg/lock* 2> /dev/null
            dpkg --configure -a 2> /dev/null
            DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install --fix-broken 2> /dev/null;;
          [Nn]*) dpkg_wait=true;;
      esac
    fi
    dpkg -i /dev/null 2> /tmp/pfelk_dpkg_lock; if grep -q "locked.* another" /tmp/pfelk_dpkg_lock; then dpkg_locked=true; rm --force /tmp/pfelk_dpkg_lock 2> /dev/null; fi
  done;
  rm --force /tmp/pfelk_dpkg_lock 2> /dev/null
fi

script_version_check() {
  if dpkg -l curl 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
    version=$(grep -i "# Version" "$0" | awk '{print $4}' | cut -d'-' -f1)
    script_online_version_dots=$(curl "https://raw.githubusercontent.com/3ilson/pfelk/master/pfelk-install-${version}.sh" -s | grep "# Version" | awk '{print $4}')
    script_local_version_dots=$(grep "# Version" "$0" | awk '{print $4}')
    script_online_version="${script_online_version_dots//./}"
    script_local_version="${script_local_version_dots//./}"
    # Script version check.
    if [[ "${script_online_version::3}" -gt "${script_local_version::3}" ]]; then
      header_red
      echo -e "${WHITE_R}#${RESET} You're currently running script version ${script_local_version_dots} while ${script_online_version_dots} is the latest!"
      echo -e "${WHITE_R}#${RESET} Downloading and executing version ${script_online_version_dots} of the Easy pfELK Installation Script..\\n\\n"
      sleep 3
      rm --force "$0" 2> /dev/null
      rm --force "pfelk-install-${version}.sh" 2> /dev/null
      wget -q "${wget_progress[@]}" "https://raw.githubusercontent.com/3ilson/pfelk/master/pfelk-install-${version}.sh" && bash "pfelk-install-${version}.sh" "${script_options[@]}"; exit 0
    fi
  else
    curl_missing=true
  fi
}
script_version_check

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                            Variables                                                                                            #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

# dpkg -l | grep "elasticsearch\\|logstash\\|kibana" | awk '{print $3}' | sed 's/.*://' | sed 's/-.*//g' &> /tmp/pfELK/elk_version
# elk_version_installed=$(sort -V /tmp/pfELK/elk_version | tail -n 1)
# rm --force /tmp/pfELK/elk_version &> /dev/null
# first_digits_elk_version_installed=$(echo "${elk_version_installed}" | cut -d'.' -f1)
# second_digits_elk_version_installed=$(echo "${elk_version_installed}" | cut -d'.' -f2)
# third_digits_elk_version_installed=$(echo "${elk_version_installed}" | cut -d'.' -f3)
#
system_memory=$(awk '/MemTotal/ {printf( "%.0f\n", $8 / 8192 / 8192)}' /proc/meminfo)
#
maxmind_username=$(echo "${maxmind_username}")
maxmind_password=$(echo "${maxmind_password}")
#system_free_disk_space=$(df -h / | grep "/" | awk '{print $4}' | sed 's/G//')
system_free_disk_space=$(df -k / | awk '{print $4}' | tail -n1)
#
#SERVER_IP=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -1)
#SERVER_IP=$(/sbin/ifconfig | grep 'inet ' | grep -v '127.0.0.1' | head -n1 | awk '{print $2}' | head -1 | sed 's/.*://')
SERVER_IP=$(ip addr | grep -A8 -m1 MULTICAST | grep -m1 inet | cut -d' ' -f6 | cut -d'/' -f1)
if [[ -z "${SERVER_IP}" ]]; then SERVER_IP=$(hostname -I | head -n 1 | awk '{ print $NF; }'); fi
PUBLIC_SERVER_IP=$(curl ifconfi.me/ -s)
architecture=$(dpkg --print-architecture)
get_distro
#
#JAVA11=$(dpkg -l | grep -c "openjdk-11-jre-headless\\|oracle-java11-installer")

unsupported_java_installed=''
openjdk_11_installed=''
port_5601_in_use=''
port_5601_pid=''
port_5601_service=''
port_5140_in_use=''
port_5140_pid=''
port_5140_service=''
elk_version=7.9.1
maxmind_version=4.3.0

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                        Required Packages                                                                                        #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

# Install needed packages if not installed
install_required_packages() {
  sleep 2
  installing_required_package=yes
  header
  echo -e "${WHITE_R}#${RESET} Installing required packages for the script.\\n"
  hide_apt_update=true
  run_apt_get_update
  sleep 2
}
apt_get_install_package() {
  if [[ "${old_openjdk_version}" == 'true' ]]; then
    apt_get_install_package_variable="update"
    apt_get_install_package_variable_2="updated"
  else
    apt_get_install_package_variable="install"
    apt_get_install_package_variable_2="installed"
  fi
  hide_apt_update=true
  run_apt_get_update
  echo -e "\\n------- ${required_package} installation ------- $(date +%F-%R) -------\\n" &>> "${pfELK_dir}/logs/apt.log"
  echo -e "${WHITE_R}#${RESET} Trying to ${apt_get_install_package_variable} ${required_package}..."
  if DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install "${required_package}" &>> "${pfELK_dir}/logs/apt.log"; then echo -e "${GREEN}#${RESET} Successfully ${apt_get_install_package_variable_2} ${required_package}! \\n" && sleep 2; else echo -e "${RED}#${RESET} Failed to ${apt_get_install_package_variable} ${required_package}! \\n"; abort; fi
  unset required_package
}

if ! dpkg -l sudo 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing sudo..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install sudo &>> "${pfELK_dir}/logs/required.log"; then
    echo -e "${RED}#${RESET} Failed to install sudo in the first run...\\n"
    if [[ "${repo_codename}" =~ (precise|trusty|xenial) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu/ ${repo_codename}-security main") -eq 0 ]]; then
        echo -e "deb http://us.archive.ubuntu.com/ubuntu/ ${repo_codename}-security main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (bionic|cosmic|disco|eoan|focal) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu ${repo_codename} main") -eq 0 ]]; then
        echo -e "deb http://us.archive.ubuntu.com/ubuntu ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (stretch|buster|bullseye) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${repo_codename} main") -eq 0 ]]; then
        echo -e "deb http://ftp.us.debian.org/debian ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    fi
    required_package="sudo"
    apt_get_install_package
  else
    echo -e "${GREEN}#${RESET} Successfully installed sudo! \\n" && sleep 2
  fi
fi

# MaxMind GeoIP install
if dpkg -l | grep "geoipupdate" | grep -q "^ii\\|^hi"; then
   header
   echo -e "${WHITE_R}#${RESET} MaxMind GeoIP is already installed!${RESET}"; 
   echo -e "${WHITE_R}#${RESET} Ensure MaxMind GeoIP is properly configured!${RESET}";
   echo -e "${RED}# WARNING${RESET} Running Logstash without MaxMind properly configured will result in fatal errors...\\n\\n"
   sleep 5;
else
read -rp $'\033[39m#\033[0m Do you have your MaxMind Account and Passowrd credentials? (y/N) ' yes_no
  case "$yes_no" in
   [Yy]*)
     if [[ "${script_option_geoip}" != 'true' ]]; then
 	   geoip_temp="$(mktemp --tmpdir=/tmp geoipupdate_${maxmind_version}_linux_amd64_XXX.deb)"
	   echo -e "${WHITE_R}#${RESET} Downloading MaxMind v${maxmind_version} GeoIP..."
	   if wget "${wget_progress[@]}" -qO "$geoip_temp" "https://github.com/maxmind/geoipupdate/releases/download/v${maxmind_version}/geoipupdate_${maxmind_version}_linux_amd64.deb"; then echo -e "${GREEN}#${RESET} Successfully downloaded MaxMind GeoIP! \\n"; else echo -e "${RED}#${RESET} Failed to download MaxMind GeoIP...\\n"; abort; fi;
	 else
	   echo -e "${GREEN}#${RESET} ${WHITE_R} MaxMind GeoIP v${maxmind_version} ${RESET} has already been downloaded!"
	 fi
	 echo -e "${WHITE_R}#${RESET} Installing MaxMind GeoIP..."
	 echo "geoip geoip/has_backup boolean true" 2> /dev/null | debconf-set-selections
	 if DEBIAN_FRONTEND=noninteractive dpkg -i "$geoip_temp" &>> "${pfELK_dir}/logs/geoip_install.log"; then
	   echo -e "${GREEN}#${RESET} Successfully installed MaxMind v${maxmind_version}! \\n"
	 else
	   echo -e "${RED}#${RESET} Failed to install MaxMind v${maxmind_version}...\\n"
	 fi
	 rm --force "$geoip_temp" 2> /dev/null
	 
   # GeoIP Cronjob
	 echo 00 17 * * 0 geoipupdate -d /data/pfELK/GeoIP > /etc/cron.weekly/geoipupdate
	 sed -i 's/EditionIDs.*/EditionIDs GeoLite2-Country GeoLite2-City GeoLite2-ASN/g' /etc/GeoIP.conf
	 #sed -i "1 s/.*DatabaseDirectory.*/DatabaseDirectory \/usr\/share\/GeoIP\//g" /etc/GeoIP.conf
	 maxmind_username=$(echo "${maxmind_username}")
	 maxmind_password=$(echo "${maxmind_password}")
	 read -p "Enter your MaxMind Account ID: " maxmind_username
	 read -p "Enter your MaxMind License Key: " maxmind_password
	 sed -i "s/AccountID.*/AccountID ${maxmind_username}/g" /etc/GeoIP.conf
	 sed -i "s/LicenseKey.*/LicenseKey ${maxmind_password}/g" /etc/GeoIP.conf
	 echo -e "\\n";
	 geoipupdate -d /usr/share/GeoIP
	 sleep 2
	 echo -e "\\n";;
   [No]*|"") 
	 echo -e "${RED}#${RESET} MaxMind v${maxmind_version} not installed!"
	 echo -e "${RED}#WARNING${RESET} Running Logstash without MaxMind will result in fatal errors...\\n"
	 sleep 2;;
   esac
fi

# lsb-release install
if ! dpkg -l lsb-release 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing lsb-release..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install lsb-release &>> "${pfELK_dir}/logs/required.log"; then
    echo -e "${RED}#${RESET} Failed to install lsb-release in the first run...\\n"
    if [[ "${repo_codename}" =~ (precise|trusty|xenial|bionic|cosmic|disco|eoan|focal) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu/ ${repo_codename} main universe") -eq 0 ]]; then
        echo -e "deb http://us.archive.ubuntu.com/ubuntu/ ${repo_codename} main universe" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (jessie|stretch|buster|bullseye) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${repo_codename} main") -eq 0 ]]; then
        echo -e "deb http://ftp.us.debian.org/debian ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    fi
    required_package="lsb-release"
    apt_get_install_package
  else
    echo -e "${GREEN}#${RESET} Successfully installed lsb-release! \\n" && sleep 2
  fi
fi

# apt-transport install
if ! dpkg -l apt-transport-https 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing apt-transport-https..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install apt-transport-https &>> "${pfELK_dir}/logs/required.log"; then
    echo -e "${RED}#${RESET} Failed to install apt-transport-https in the first run...\\n"
    if [[ "${repo_codename}" =~ (precise|trusty|xenial) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://security.ubuntu.com/ubuntu ${repo_codename}-security main") -eq 0 ]]; then
        echo -e "deb http://security.ubuntu.com/ubuntu ${repo_codename}-security main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (bionic|cosmic) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://security.ubuntu.com/ubuntu ${repo_codename}-security main universe") -eq 0 ]]; then
        echo -e "deb http://security.ubuntu.com/ubuntu ${repo_codename}-security main universe" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (disco|eoan|focal) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu ${repo_codename} main universe") -eq 0 ]]; then
        echo -e "deb http://us.archive.ubuntu.com/ubuntu ${repo_codename} main universe" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" == "jessie" ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://security.debian.org/debian-security ${repo_codename}/updates main") -eq 0 ]]; then
        echo -e "deb http://security.debian.org/debian-security ${repo_codename}/updates main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (stretch|buster|bullseye) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${repo_codename} main") -eq 0 ]]; then
        echo -e "deb http://ftp.us.debian.org/debian ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    fi
    required_package="apt-transport-https"
    apt_get_install_package
  else
    echo -e "${GREEN}#${RESET} Successfully installed apt-transport-https! \\n" && sleep 2
  fi
fi

# software-properties-common install
if ! dpkg -l software-properties-common 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing software-properties-common..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install software-properties-common &>> "${pfELK_dir}/logs/required.log"; then
    echo -e "${RED}#${RESET} Failed to install software-properties-common in the first run...\\n"
    if [[ "${repo_codename}" == "precise" ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://security.ubuntu.com/ubuntu ${repo_codename}-security main") -eq 0 ]]; then
        echo -e "deb http://security.ubuntu.com/ubuntu ${repo_codename}-security main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (trusty|xenial|bionic|cosmic|disco|eoan|focal) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu ${repo_codename} main") -eq 0 ]]; then
        echo -e "deb http://us.archive.ubuntu.com/ubuntu ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (jessie|stretch|buster|bullseye) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${repo_codename} main") -eq 0 ]]; then
        echo -e "deb http://ftp.us.debian.org/debian ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    fi
    required_package="software-properties-common"
    apt_get_install_package
  else
    echo -e "${GREEN}#${RESET} Successfully installed software-properties-common! \\n" && sleep 2
  fi
fi

# curl install
if ! dpkg -l curl 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing curl..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install curl &>> "${pfELK_dir}/logs/required.log"; then
    echo -e "${RED}#${RESET} Failed to install curl in the first run...\\n"
    if [[ "${repo_codename}" =~ (precise|trusty|xenial|bionic|cosmic) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://security.ubuntu.com/ubuntu ${repo_codename}-security main") -eq 0 ]]; then
        echo -e "deb http://security.ubuntu.com/ubuntu ${repo_codename}-security main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (disco|eoan|focal) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu ${repo_codename} main") -eq 0 ]]; then
        echo -e "deb http://us.archive.ubuntu.com/ubuntu ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" == "jessie" ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://security.debian.org/debian-security ${repo_codename}/updates main") -eq 0 ]]; then
        echo -e "deb http://security.debian.org/debian-security ${repo_codename}/updates main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (stretch|buster|bullseye) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${repo_codename} main") -eq 0 ]]; then
        echo -e "deb http://ftp.us.debian.org/debian ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    fi
    required_package="curl"
    apt_get_install_package
  else
    echo -e "${GREEN}#${RESET} Successfully installed curl! \\n" && sleep 2
  fi
fi

# dirmngr install
if ! dpkg -l dirmngr 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing dirmngr..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install dirmngr &>> "${pfELK_dir}/logs/required.log"; then
    echo -e "${RED}#${RESET} Failed to install dirmngr in the first run...\\n"
    if [[ "${repo_codename}" =~ (precise|trusty|xenial|bionic|cosmic|disco|eoan|focal) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu/ ${repo_codename} universe") -eq 0 ]]; then
        echo -e "deb http://us.archive.ubuntu.com/ubuntu/ ${repo_codename} universe" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu/ ${repo_codename} main restricted") -eq 0 ]]; then
        echo -e "deb http://us.archive.ubuntu.com/ubuntu/ ${repo_codename} main restricted" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (jessie|stretch|buster|bullseye) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${repo_codename} main") -eq 0 ]]; then
        echo -e "deb http://ftp.us.debian.org/debian ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    fi
    required_package="dirmngr"
    apt_get_install_package
  else
    echo -e "${GREEN}#${RESET} Successfully installed dirmngr! \\n" && sleep 2
  fi
fi

# wget install
if ! dpkg -l wget 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing wget..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install wget &>> "${pfELK_dir}/logs/required.log"; then
    echo -e "${RED}#${RESET} Failed to install wget in the first run...\\n"
    if [[ "${repo_codename}" =~ (precise|trusty|xenial|bionic|cosmic) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://security.ubuntu.com/ubuntu ${repo_codename}-security main") -eq 0 ]]; then
        echo -e "deb http://security.ubuntu.com/ubuntu ${repo_codename}-security main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (disco|eoan|focal) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu ${repo_codename} main") -eq 0 ]]; then
        echo -e "deb http://us.archive.ubuntu.com/ubuntu ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" == "jessie" ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://security.debian.org/debian-security ${repo_codename}/updates main") -eq 0 ]]; then
        echo -e "deb http://security.debian.org/debian-security ${repo_codename}/updates main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (stretch|buster|bullseye) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${repo_codename} main") -eq 0 ]]; then
        echo -e "deb http://ftp.us.debian.org/debian ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    fi
    required_package="wget"
    apt_get_install_package
  else
    echo -e "${GREEN}#${RESET} Successfully installed wget! \\n" && sleep 2
  fi
fi

# netcat install
if ! dpkg -l netcat 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing netcat..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install netcat &>> "${pfELK_dir}/logs/required.log"; then
    echo -e "${RED}#${RESET} Failed to install netcat in the first run...\\n"
    if [[ "${repo_codename}" =~ (precise|trusty|xenial|bionic|cosmic|disco|eoan|focal) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu/ ${repo_codename} universe") -eq 0 ]]; then
        echo -e "deb http://us.archive.ubuntu.com/ubuntu/ ${repo_codename} universe" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    elif [[ "${repo_codename}" =~ (jessie|stretch|buster|bullseye) ]]; then
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${repo_codename} main") -eq 0 ]]; then
        echo -e "deb http://ftp.us.debian.org/debian ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
    fi
    required_package="netcat"
    apt_get_install_package
  else
    echo -e "${GREEN}#${RESET} Successfully installed netcat! \\n" && sleep 2
  fi
  netcat_installed=true
fi

if [[ "${curl_missing}" == 'true' ]]; then script_version_check; fi

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                             Checks                                                                                              #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

if [ "${system_free_disk_space}" -lt "5000000" ]; then
  header_red
  echo -e "${WHITE_R}#${RESET} Free disk space is below 5GB. Please expand the disk size!"
  echo -e "${WHITE_R}#${RESET} It is recommend tha available space be expanding to at least 10GB\\n\\n"
  if [[ "${script_option_skip}" != 'true' ]]; then
    read -rp "Do you want to proceed at your own risk? (Y/n)" yes_no
    case "$yes_no" in
        [Yy]*|"") ;;
        [Nn]*) cancel_script;;
    esac
  else
    cancel_script
  fi
fi

# Memory
if [[ "${system_swap}" == "0" && "${system_memory}" -lt "4" ]]; then
  header_red
  echo -e "${WHITE_R}#${RESET} System memory does not meet minimum and may not run!"
  echo -e "${WHITE_R}#${RESET} It is recommend that ram is expanded to at least 8GB\\n\\n"
  swapoff -a
  sleep 2
else
  header
  echo -e "${WHITE_R}#${RESET} Memory Meets Minimum Requirements!\\n\\n"
  swapoff -a
  sleep 2
fi

# MaxMind GeoIP
# Added check to ensure GeoIP database files were downloaded

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                  Ask to keep script or delete                                                                                   #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

script_removal() {
  header
  read -rp $'\033[39m#\033[0m Do you want to keep the script on your system after completion? (Y/n) ' yes_no
  case "$yes_no" in
      [Yy]*|"") ;;
      [Nn]*) delete_script=true;;
  esac
}

if [[ "${script_option_skip}" != 'true' ]]; then
  script_removal
fi

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                 Installation Script starts here                                                                                 #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

start_pfelk() {
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
  header
  script_logo
  sleep 4
}
start_pfelk

system_upgrade() {
  if [[ -f /tmp/pfELK/upgrade/upgrade_list && -s /tmp/pfELK/upgrade/upgrade_list ]]; then
    while read -r package; do
      echo -e "\\n------- updating ${package} ------- $(date +%F-%R) -------\\n" &>> "${pfELK_dir}/logs/upgrade.log"
      echo -ne "\r${WHITE_R}#${RESET} Updating package ${package}..."
      if DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' --only-upgrade install "${package}" &>> "${pfELK_dir}/logs/upgrade.log"; then echo -e "\r${GREEN}#${RESET} Successfully updated package ${package}!"; else echo -e "\r${RED}#${RESET} Something went wrong during the update of package ${package}...${RED}#${RESET} The script will continue with an apt-get upgrade...\\n"; break; fi
    done < /tmp/pfELK/upgrade/upgrade_list
  fi
  echo -e "\\n------- apt-get upgrade ------- $(date +%F-%R) -------\\n" &>> "${pfELK_dir}/logs/upgrade.log"
  echo -e "${WHITE_R}#${RESET} Running apt-get upgrade..."
  if DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade &>> "${pfELK_dir}/logs/upgrade.log"; then echo -e "${GREEN}#${RESET} Successfully ran apt-get upgrade! \\n"; else echo -e "${RED}#${RESET} Failed to run apt-get upgrade"; abort; fi
  echo -e "\\n------- apt-get dist-upgrade ------- $(date +%F-%R) -------\\n" &>> "${pfELK_dir}/logs/upgrade.log"
  echo -e "${WHITE_R}#${RESET} Running apt-get dist-upgrade..."
  if DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' dist-upgrade &>> "${pfELK_dir}/logs/upgrade.log"; then echo -e "${GREEN}#${RESET} Successfully ran apt-get dist-upgrade! \\n"; else echo -e "${RED}#${RESET} Failed to run apt-get dist-upgrade"; abort; fi
  echo -e "${WHITE_R}#${RESET} Running apt-get autoremove..."
  if apt-get -y autoremove &>> "${pfELK_dir}/logs/apt-cleanup.log"; then echo -e "${GREEN}#${RESET} Successfully ran apt-get autoremove! \\n"; else echo -e "${RED}#${RESET} Failed to run apt-get autoremove"; fi
  echo -e "${WHITE_R}#${RESET} Running apt-get autoclean..."
  if apt-get -y autoclean &>> "${pfELK_dir}/logs/apt-cleanup.log"; then echo -e "${GREEN}#${RESET} Successfully ran apt-get autoclean! \\n"; else echo -e "${RED}#${RESET} Failed to run apt-get autoclean"; fi
  sleep 3
}

rm --force /tmp/pfELK/upgrade/upgrade_list &> /dev/null
header
echo -e "${WHITE_R}#${RESET} Checking if your system is up-to-date...\\n" && sleep 1
hide_apt_update=true
run_apt_get_update

echo -e "${WHITE_R}#${RESET} The package(s) below can be upgraded!"
echo -e "\\n${WHITE_R}----${RESET}\\n"
rm --force /tmp/pfELK/upgrade/upgrade_list &> /dev/null
{ apt-get --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print "$1 ( \e[1;34m$2\e[0m -> \e[1;32m$3\e[0m )\n"}';} | while read -r line; do echo -en "${WHITE_R}-${RESET} $line\n"; echo -en "$line\n" | awk '{print $1}' &>> /tmp/pfELK/upgrade/upgrade_list; done;
if [[ -f /tmp/pfELK/upgrade/upgrade_list ]]; then number_of_updates=$(wc -l < /tmp/pfELK/upgrade/upgrade_list); else number_of_updates='0'; fi
if [[ "${number_of_updates}" == '0' ]]; then echo -e "${WHITE_R}#${RESET} There are were no packages that need an upgrade..."; fi
echo -e "\\n${WHITE_R}----${RESET}\\n"
if [[ "${script_option_skip}" != 'true' ]]; then
  read -rp $'\033[39m#\033[0m Do you want to proceed with updating your system? (Y/n) ' yes_no
else
  echo -e "${WHITE_R}#${RESET} Performing the updates!"
fi
case "$yes_no" in
    [Yy]*|"") echo -e "\\n${WHITE_R}----${RESET}\\n"; system_upgrade;;
    [Nn]*) ;;
esac
sleep 3

openjdk_version=$(dpkg -l | grep "^ii\\|^hi" | grep "openjdk-11-jre-headless" | awk '{print $3}' | grep "^11" | sed 's/-.*//g' | sed 's/11//g' | grep -o '[[:digit:]]*' | sort -V | tail -n 1)
if dpkg -l | grep "^ii\\|^hi" | grep -iq "openjdk-11-jre-headless"; then
  if [[ "${openjdk_version}" -lt '10' ]]; then
    old_openjdk_version=true
  fi
fi
if ! dpkg -l | grep "^ii\\|^hi" | grep -iq "openjdk-11-jre-headless" || [[ "${old_openjdk_version}" == 'true' ]]; then
  if [[ "${old_openjdk_version}" == 'true' ]]; then
    header_red
    echo -e "${RED}#${RESET} OpenJDK is too old...\\n" && sleep 2
    openjdk_variable="Updating"
    openjdk_variable_2="Updated"
    openjdk_variable_3="Update"
  else
    header
    echo -e "${GREEN}#${RESET} Preparing OpenJDK 11 installation...\\n" && sleep 2
    openjdk_variable="Installing"
    openjdk_variable_2="Installed"
    openjdk_variable_3="Install"
  fi
  sleep 2
  if [[ "${repo_codename}" =~ (precise|trusty|xenial|bionic|cosmic) ]]; then
    echo -e "${WHITE_R}#${RESET} ${openjdk_variable} openjdk-11-jre-headless..."
    if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install openjdk-11-jre-headless &> /dev/null || [[ "${old_openjdk_version}" == 'true' ]]; then
      echo -e "${RED}#${RESET} Failed to ${openjdk_variable_3} openjdk-11-jre-headless in the first run...\\n"
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ppa.launchpad.net/openjdk-r/ppa/ubuntu ${repo_codename} main") -eq 0 ]]; then
        echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu ${repo_codename} main" >> /etc/apt/sources.list.d/pfelk-install-script.list || abort
        echo "EB9B1D8886F44E2A" &>> /tmp/pfELK/keys/missing_keys
      fi
      required_package="openjdk-11-jre-headless"
      apt_get_install_package
    else
      echo -e "${GREEN}#${RESET} Successfully ${openjdk_variable_2} openjdk-11-jre-headless! \\n" && sleep 2
    fi
  elif [[ "${repo_codename}" =~ (disco|eoan|focal) ]]; then
    echo -e "${WHITE_R}#${RESET} ${openjdk_variable} openjdk-11-jre-headless..."
    if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install openjdk-11-jre-headless &> /dev/null || [[ "${old_openjdk_version}" == 'true' ]]; then
      echo -e "${RED}#${RESET} Failed to ${openjdk_variable_3} openjdk-11-jre-headless in the first run...\\n"
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://security.ubuntu.com/ubuntu bionic-security main universe") -eq 0 ]]; then
        echo "deb http://security.ubuntu.com/ubuntu bionic-security main universe" >> /etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
      required_package="openjdk-11-jre-headless"
      apt_get_install_package
    else
      echo -e "${GREEN}#${RESET} Successfully ${openjdk_variable_2} openjdk-11-jre-headless! \\n" && sleep 2
    fi
  elif [[ "${os_codename}" == "jessie" ]]; then
    echo -e "${WHITE_R}#${RESET} ${openjdk_variable} openjdk-11-jre-headless..."
    if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install -t jessie-backports openjdk-11-jre-headless &> /dev/null || [[ "${old_openjdk_version}" == 'true' ]]; then
      echo -e "${RED}#${RESET} Failed to ${openjdk_variable_3} openjdk-11-jre-headless in the first run...\\n"
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -P -c "^deb http[s]*://archive.debian.org/debian jessie-backports main") -eq 0 ]]; then
        echo deb http://archive.debian.org/debian jessie-backports main >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
        http_proxy=$(env | grep -i "http.*Proxy" | cut -d'=' -f2 | sed 's/[";]//g')
        if [[ -n "$http_proxy" ]]; then
          apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --keyserver-options http-proxy="${http_proxy}" --recv-keys 8B48AD6246925553 7638D0442B90D010 || abort
        elif [[ -f /etc/apt/apt.conf ]]; then
          apt_http_proxy=$(grep "http.*Proxy" /etc/apt/apt.conf | awk '{print $2}' | sed 's/[";]//g')
          if [[ -n "${apt_http_proxy}" ]]; then
            apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --keyserver-options http-proxy="${apt_http_proxy}" --recv-keys 8B48AD6246925553 7638D0442B90D010 || abort
          fi
        else
          apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 8B48AD6246925553 7638D0442B90D010 || abort
        fi
        echo -e "${WHITE_R}#${RESET} Running apt-get update..."
        required_package="openjdk-11-jre-headless"
        if apt-get update -o Acquire::Check-Valid-Until=false &> /dev/null; then echo -e "${GREEN}#${RESET} Successfully ran apt-get update! \\n"; else echo -e "${RED}#${RESET} Failed to ran apt-get update! \\n"; abort; fi
        echo -e "\\n------- ${required_package} installation ------- $(date +%F-%R) -------\\n" &>> "${pfELK_dir}/logs/apt.log"
        if DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install -t jessie-backports openjdk-11-jre-headless &>> "${pfELK_dir}/logs/apt.log"; then echo -e "${GREEN}#${RESET} Successfully installed ${required_package}! \\n" && sleep 2; else echo -e "${RED}#${RESET} Failed to install ${required_package}! \\n"; abort; fi
        sed -i '/jessie-backports/d' /etc/apt/sources.list.d/pfelk-install-script.list
        unset required_package
      fi
    fi
  elif [[ "${os_codename}" =~ (stretch|continuum) ]]; then
    echo -e "${WHITE_R}#${RESET} ${openjdk_variable} openjdk-11-jre-headless..."
    if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install openjdk-11-jre-headless &> /dev/null || [[ "${old_openjdk_version}" == 'true' ]]; then
      echo -e "${RED}#${RESET} Failed to ${openjdk_variable_3} openjdk-11-jre-headless in the first run...\\n"
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ppa.launchpad.net/openjdk-r/ppa/ubuntu xenial main") -eq 0 ]]; then
        echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu xenial main" >> /etc/apt/sources.list.d/pfelk-install-script.list || abort
        echo "EB9B1D8886F44E2A" &>> /tmp/pfELK/keys/missing_keys
      fi
      required_package="openjdk-11-jre-headless"
      apt_get_install_package
    else
      echo -e "${GREEN}#${RESET} Successfully ${openjdk_variable_2} openjdk-11-jre-headless! \\n" && sleep 2
    fi
  elif [[ "${repo_codename}" =~ (buster|bullseye) ]]; then
    echo -e "${WHITE_R}#${RESET} ${openjdk_variable} openjdk-11-jre-headless..."
    if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install openjdk-11-jre-headless &> /dev/null || [[ "${old_openjdk_version}" == 'true' ]]; then
      echo -e "${RED}#${RESET} Failed to ${openjdk_variable_3} openjdk-11-jre-headless in the first run...\\n"
      if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.us.debian.org/debian stretch main") -eq 0 ]]; then
        echo "deb http://ftp.us.debian.org/debian stretch main" >> /etc/apt/sources.list.d/pfelk-install-script.list || abort
      fi
      required_package="openjdk-11-jre-headless"
      apt_get_install_package
    else
      echo -e "${GREEN}#${RESET} Successfully ${openjdk_variable_2} openjdk-11-jre-headless! \\n" && sleep 2
    fi
  else
    header_red
    echo -e "${RED}Please manually install JAVA 11 on your system!${RESET}\\n"
    echo -e "${RED}OS Details:${RESET}\\n"
    echo -e "${RED}$(lsb_release -a)${RESET}\\n"
    exit 0
  fi
else
  header
  echo -e "${GREEN}#${RESET} Preparing OpenJDK 11 installation..."
  echo -e "${WHITE_R}#${RESET} OpenJDK 11 is already installed! \\n"
fi
sleep 3

if dpkg -l | grep "^ii\\|^hi" | grep -iq "openjdk-11"; then
  openjdk_11_installed=true
fi
if dpkg -l | grep "^ii\\|^hi" | grep -i "openjdk-.*-\\|oracle-java.*" | grep -vq "openjdk-11-jre-headless\\|oracle-java11"; then
  unsupported_java_installed=true
fi

if [[ "${openjdk_11_installed}" == 'true' && "${unsupported_java_installed}" == 'true' && "${script_option_skip}" != 'true' ]]; then
  header_red
  echo -e "${WHITE_R}#${RESET} Unsupported JAVA version(s) are detected, do you want to uninstall them?"
  echo -e "${WHITE_R}#${RESET} This may remove packages that depend on these java versions."
  read -rp $'\033[39m#\033[0m Do you want to proceed with uninstalling the unsupported JAVA version(s)? (y/N) ' yes_no
  case "$yes_no" in
       [Yy]*)
          rm --force /tmp/pfELK/java/* &> /dev/null
          mkdir -p /tmp/pfELK/java/ &> /dev/null
          mkdir -p "${pfELK_dir}/logs/" &> /dev/null
          header
          echo -e "${WHITE_R}#${RESET} Uninstalling unsupported JAVA versions..."
          echo -e "\\n${WHITE_R}----${RESET}\\n"
          sleep 3
          dpkg -l | grep "^ii\\|^hi" | awk '/openjdk-.*/{print $2}' | cut -d':' -f1 | grep -v "openjdk-11-jre-headless" &>> /tmp/pfELK/java/unsupported_java_list_tmp
          dpkg -l | grep "^ii\\|^hi" | awk '/oracle-java.*/{print $2}' | cut -d':' -f1 | grep -v "oracle-java8" &>> /tmp/pfELK/java/unsupported_java_list_tmp
          awk '!a[$0]++' /tmp/pfELK/java/unsupported_java_list_tmp >> /tmp/pfELK/java/unsupported_java_list; rm --force /tmp/pfELK/java/unsupported_java_list_tmp 2> /dev/null
          echo -e "\\n------- $(date +%F-%R) -------\\n" &>> "${pfELK_dir}/logs/java_uninstall.log"
          while read -r package; do
            apt-get remove "${package}" -y &>> "${pfELK_dir}/logs/java_uninstall.log" && echo -e "${WHITE_R}#${RESET} Successfully removed ${package}." || echo -e "${WHITE_R}#${RESET} Failed to remove ${package}."
          done < /tmp/pfELK/java/unsupported_java_list
          rm --force /tmp/pfELK/java/unsupported_java_list &> /dev/null
          echo -e "\\n" && sleep 3;;
       [Nn]*|"") ;;
  esac
fi

if dpkg -l | grep "^ii\\|^hi" | grep -iq "openjdk-11-jre-headless"; then
  update_java_alternatives=$(update-java-alternatives --list | grep "^java-1.8.*openjdk" | awk '{print $1}' | head -n1)
  if [[ -n "${update_java_alternatives}" ]]; then
    update-java-alternatives --set "${update_java_alternatives}" &> /dev/null
  fi
  update_alternatives=$(update-alternatives --list java | grep "java-11-openjdk" | awk '{print $1}' | head -n1)
  if [[ -n "${update_alternatives}" ]]; then
    update-alternatives --set java "${update_alternatives}" &> /dev/null
  fi
  header
  echo -e "${WHITE_R}#${RESET} Updating the ca-certificates..." && sleep 2
  rm /etc/ssl/certs/java/cacerts 2> /dev/null
  update-ca-certificates -f &> /dev/null && echo -e "${GREEN}#${RESET} Successfully updated the ca-certificates\\n" && sleep 2
fi

header
echo -e "${WHITE_R}#${RESET} Preparing installation of the pfELK dependencies...\\n"
sleep 2
echo -e "\\n------- dependency installation ------- $(date +%F-%R) -------\\n" &>> "${pfELK_dir}/logs/apt.log"
if [[ "${os_codename}" =~ (precise|maya|trusty|qiana|rebecca|rafaela|rosa|xenial|sarah|serena|sonya|sylvia|bionic|tara|tessa|tina|tricia|cosmic|disco|eoan|focal|stretch|continuum|buster|bullseye) ]]; then
  echo -e "${WHITE_R}#${RESET} Installing binutils, ca-certificates-java and java-common..."
  if DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install binutils ca-certificates-java java-common &>> "${pfELK_dir}/logs/apt.log"; then echo -e "${GREEN}#${RESET} Successfully installed binutils, ca-certificates-java and java-common! \\n"; else echo -e "${RED}#${RESET} Failed to install binutils, ca-certificates-java and java-common in the first run...\\n"; pfelk_dependencies=fail; fi
  echo -e "${WHITE_R}#${RESET} Installing jsvc and libcommons-daemon-java..."
  if DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install jsvc libcommons-daemon-java &>> "${pfELK_dir}/logs/apt.log"; then echo -e "${GREEN}#${RESET} Successfully installed jsvc and libcommons-daemon-java! \\n"; else echo -e "${RED}#${RESET} Failed to install jsvc and libcommons-daemon-java in the first run...\\n"; pfelk_dependencies=fail; fi
elif [[ "${os_codename}" == 'jessie' ]]; then
  echo -e "${WHITE_R}#${RESET} Installing binutils, ca-certificates-java and java-common..."
  if DEBIAN_FRONTEND='noninteractive' apt-get -y --force-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install binutils ca-certificates-java java-common &>> "${pfELK_dir}/logs/apt.log"; then echo -e "${GREEN}#${RESET} Successfully installed binutils, ca-certificates-java and java-common! \\n"; else echo -e "${RED}#${RESET} Failed to install binutils, ca-certificates-java and java-common in the first run...\\n"; pfelk_dependencies=fail; fi
  echo -e "${WHITE_R}#${RESET} Installing jsvc and libcommons-daemon-java..."
  if DEBIAN_FRONTEND='noninteractive' apt-get -y --force-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install jsvc libcommons-daemon-java &>> "${pfELK_dir}/logs/apt.log"; then echo -e "${GREEN}#${RESET} Successfully installed jsvc and libcommons-daemon-java! \\n"; else echo -e "${RED}#${RESET} Failed to install jsvc and libcommons-daemon-java in the first run...\\n"; pfelk_dependencies=fail; fi
fi
if [[ "${pfelk_dependencies}" == 'fail' ]]; then
  if [[ "${repo_codename}" =~ (precise|trusty|xenial|bionic|cosmic|disco|eoan|focal) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -P -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu ${repo_codename} main universe") -eq 0 ]]; then
      echo "deb http://us.archive.ubuntu.com/ubuntu ${repo_codename} main universe" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  elif [[ "${os_codename}" =~ (jessie|stretch|buster|bullseye) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -P -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${repo_codename} main") -eq 0 ]]; then
      echo "deb http://ftp.us.debian.org/debian ${repo_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  fi
  hide_apt_update=true
  run_apt_get_update
  if [[ "${os_codename}" =~ (precise|maya|trusty|qiana|rebecca|rafaela|rosa|xenial|sarah|serena|sonya|sylvia|bionic|tara|tessa|tina|tricia|cosmic|disco|eoan|focal|stretch|continuum|buster|bullseye) ]]; then
  echo -e "${WHITE_R}#${RESET} Installing binutils, ca-certificates-java and java-common..."
    if DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install binutils ca-certificates-java java-common &>> "${pfELK_dir}/logs/apt.log"; then echo -e "${GREEN}#${RESET} Successfully installed binutils, ca-certificates-java and java-common! \\n"; else echo -e "${RED}#${RESET} Failed to install binutils, ca-certificates-java and java-common in the first run...\\n"; abort; fi
  echo -e "${WHITE_R}#${RESET} Installing jsvc and libcommons-daemon-java..."
    if DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install jsvc libcommons-daemon-java &>> "${pfELK_dir}/logs/apt.log"; then echo -e "${GREEN}#${RESET} Successfully installed jsvc and libcommons-daemon-java! \\n"; else echo -e "${RED}#${RESET} Failed to install jsvc and libcommons-daemon-java in the first run...\\n"; abort; fi
  elif [[ "${os_codename}" == 'jessie' ]]; then
  echo -e "${WHITE_R}#${RESET} Installing binutils, ca-certificates-java and java-common..."
    if DEBIAN_FRONTEND='noninteractive' apt-get -y --force-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install binutils ca-certificates-java java-common &>> "${pfELK_dir}/logs/apt.log"; then echo -e "${GREEN}#${RESET} Successfully installed binutils, ca-certificates-java and java-common! \\n"; else echo -e "${RED}#${RESET} Failed to install binutils, ca-certificates-java and java-common in the first run...\\n"; abort; fi
  echo -e "${WHITE_R}#${RESET} Installing jsvc and libcommons-daemon-java..."
    if DEBIAN_FRONTEND='noninteractive' apt-get -y --force-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install jsvc libcommons-daemon-java &>> "${pfELK_dir}/logs/apt.log"; then echo -e "${GREEN}#${RESET} Successfully installed jsvc and libcommons-daemon-java! \\n"; else echo -e "${RED}#${RESET} Failed to install jsvc and libcommons-daemon-java in the first run...\\n"; abort; fi
  fi
fi
sleep 3

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                               Download and Configure pfELK Files                                                                                #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

download_pfelk() {
  mkdir -p /etc/logstash/conf.d/patterns
  mkdir -p /etc/logstash/conf.d/templates
  mkdir -p /etc/logstash/conf.d/databases
  cd /etc/logstash/conf.d/
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/01-inputs.conf
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/02-types.conf
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/03-filter.conf
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/05-firewall.conf
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/10-others.conf
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/15-squid.conf
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/20-suricata.conf
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/25-snort.conf
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/30-geoip.conf
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/35-rules-desc.conf
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/36-ports-desc.conf
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/45-cleanup.conf
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/50-outputs.conf
  cd /etc/logstash/conf.d/patterns/
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/patterns/pfelk.grok
  cd /etc/logstash/conf.d/templates
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/templates/pf-geoip.json
  cd /etc/logstash/conf.d/databases
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/databases/rule-names.csv
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/etc/logstash/conf.d/databases/service-names-port-numbers.csv
  mkdir -p /etc/pfELK/logs/
  cd /etc/pfELK/
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/error-data.sh
  chmod +x /etc/logstash/pfelk-error.sh
  header
  script_logo
  echo -e "\\n${WHITE_R}#${RESET} Setting up pfELK File Structure...\\n\\n"
  sleep 4
}
download_pfelk

header
echo -e "${WHITE_R}#${RESET} Please provide the IP address (LAN) for your firewall.${RESET}"; 
echo -e "${WHITE_R}#${RESET} Example: 192.168.0.1${RESET}";
echo -e "${RED}# WARNING${RESET} This address must be accessible from the pfELK installation host!\\n\\n"
read -p "Enter Your Firewall's IP Adress: " input_ip
sed -e s/"192.168.9.1"/${input_ip}/g -i /etc/logstash/conf.d/02-types.conf
sleep 2

#Configure 01-inputs.conf for OPNsense or pfSense
#echo -e "${WHITE_R}#${RESET} Please select firewall distribution type, for configuration.${RESET}\\n";
#SenseType='Please specify your firewall type: '
#options=("OPNsense" "pfSense" "Exit")
#select opt in "${options[@]}"
#do
#	case $opt in
#	    "OPNsense")
#	      sed -e s/#OPN#//g -i /etc/logstash/conf.d/03-filter.conf 
#	      echo -e "\\n";
#		  echo -e "${RED}#${RESET} pfELK configured for OPNsense!\\n"
#	      sleep 3
#	      echo -e "\\n"
#	      break
#	      ;;
#	    "pfSense")
#	      sed -e s/#pf#//g -i /etc/logstash/conf.d/03-filter.conf 
#	      echo -e "\\n";
#		  echo -e "${RED}#${RESET} pfELK configured for pfSense!\\n"
#	      sleep 3
#	      echo -e "\\n"
#	      break
#	      ;;
#	    "Exit")
#	      exit 0;;
#	    *) echo "invalid option $REPLY";;
#	esac
#done

# Elasticsearch install
if dpkg -l | grep "elasticsearch" | grep -q "^ii\\|^hi"; then
  header
  echo -e "${WHITE_R}#${RESET} Elasticsearch is already installed!${RESET}\\n\\n";
else
	header
	echo -e "${WHITE_R}#${RESET} Installing Elasticsearch...\\n"
	sleep 2
	if [[ "${script_option_elasticsearch}" != 'true' ]]; then
	  elasticsearch_temp="$(mktemp --tmpdir=/tmp elasticsearch_"${elk_version}"_XXX.deb)"
	  echo -e "${WHITE_R}#${RESET} Downloading Elasticsearch..."
	  if wget "${wget_progress[@]}" -qO "$elasticsearch_temp" "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${elk_version}-amd64.deb"; then echo -e "${GREEN}#${RESET} Successfully downloaded Elasticsearch version ${elk_version}! \\n"; else echo -e "${RED}#${RESET} Failed to download Elasticsearch...\\n"; abort; fi;
	else
	  echo -e "${GREEN}#${RESET} Elasticsearch has already been downloaded!"
	fi
	echo -e "${WHITE_R}#${RESET} Installing the Elasticsearch..."
	echo "elasticsearch elasticsearch/has_backup boolean true" 2> /dev/null | debconf-set-selections
	if DEBIAN_FRONTEND=noninteractive dpkg -i "$elasticsearch_temp" &>> "${pfELK_dir}/logs/elasticsearch_install.log"; then
	  echo -e "${GREEN}#${RESET} Successfully installed Elasticsearch! \\n"
	else
	  echo -e "${RED}#${RESET} Failed to install Elasticsearch...\\n"
	fi
fi
rm --force "$elasticsearch_temp" 2> /dev/null
service elasticsearch start || abort
sleep 3

# Logstash install
if dpkg -l | grep "logstash" | grep -q "^ii\\|^hi"; then
  header
  echo -e "${WHITE_R}#${RESET} Logstash is already installed!${RESET}\\n\\n";
else
	header
	echo -e "${WHITE_R}#${RESET} Installing Logstash...\\n"
	sleep 2
	if [[ "${script_option_logstash}" != 'true' ]]; then
	  logstash_temp="$(mktemp --tmpdir=/tmp logstash_"${elk_version}"_XXX.deb)"
	  echo -e "${WHITE_R}#${RESET} Downloading Logstash..."
	  if wget "${wget_progress[@]}" -qO "$logstash_temp" "https://artifacts.elastic.co/downloads/logstash/logstash-${elk_version}.deb"; then echo -e "${GREEN}#${RESET} Successfully downloaded Logstash version ${elk_version}! \\n"; else echo -e "${RED}#${RESET} Failed to download Logstash...\\n"; abort; fi;
	else
	  echo -e "${GREEN}#${RESET} Logstash has already been downloaded!"
	fi
	echo -e "${WHITE_R}#${RESET} Installing the Logstash..."
	echo "logstash logstash/has_backup boolean true" 2> /dev/null | debconf-set-selections
	if DEBIAN_FRONTEND=noninteractive dpkg -i "$logstash_temp" &>> "${pfELK_dir}/logs/logstash_install.log"; then
	  echo -e "${GREEN}#${RESET} Successfully installed Logstash! \\n"
	else
	  echo -e "${RED}#${RESET} Failed to install Logstash...\\n"
	fi
fi
rm --force "$logstash_temp" 2> /dev/null
service logstash start || abort
sleep 3

# Kibana install
if dpkg -l | grep "kibana" | grep -q "^ii\\|^hi"; then
  header
  echo -e "${WHITE_R}#${RESET} Kibana is already installed!${RESET}\\n\\n";
else
	header
	echo -e "${WHITE_R}#${RESET} Installing Kibana...\\n"
	sleep 2
	if [[ "${script_option_kibana}" != 'true' ]]; then
	  kibana_temp="$(mktemp --tmpdir=/tmp kibana_"${elk_version}"_XXX.deb)"
	  echo -e "${WHITE_R}#${RESET} Downloading Kibana..."
	  if wget "${wget_progress[@]}" -qO "$kibana_temp" "https://artifacts.elastic.co/downloads/kibana/kibana-${elk_version}-amd64.deb"; then echo -e "${GREEN}#${RESET} Successfully downloaded Kibana version ${elk_version}! \\n"; else echo -e "${RED}#${RESET} Failed to download Kibana...\\n"; abort; fi;
	else
	  echo -e "${GREEN}#${RESET} Kibana has already been downloaded!"
	fi
	echo -e "${WHITE_R}#${RESET} Installing the Kibana..."
	echo "kibana kibana/has_backup boolean true" 2> /dev/null | debconf-set-selections
	if DEBIAN_FRONTEND=noninteractive dpkg -i "$kibana_temp" &>> "${pfELK_dir}/logs/kibana_install.log"; then
	  echo -e "${GREEN}#${RESET} Successfully installed Kibana! \\n"
	else
	  echo -e "${RED}#${RESET} Failed to install Kibana...\\n"
	fi
fi
rm --force "$kibana_temp" 2> /dev/null
service kibana start || abort
sleep 3

# Download Kibana.yml & Restart Kibana
update_kibana() {
  cd /etc/kibana
  rm /etc/kibana/kibana.yml
  wget -q https://raw.githubusercontent.com/3ilson/pfelk/master/kibana.yml
  sudo systemctl restart kibana.service
}
update_kibana

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                               Finish                                                                                            #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

# Configure Firewall (OPNsense or pfSense) IP Address

# Check if Elasticsearch service is enabled
if ! [[ "${os_codename}" =~ (precise|maya|trusty|qiana|rebecca|rafaela|rosa) ]]; then
    SERVICE_ELASTIC=$(systemctl is-enabled elasticsearch)
    if [ "$SERVICE_ELASTIC" = 'disabled' ]; then
      systemctl enable elasticsearch 2>/dev/null || { echo -e "${RED}#${RESET} Failed to enable service | Elasticsearch"; sleep 3; }
    fi
  else
    SERVICE_ELASTIC=$(systemctl is-enabled elasticsearch)
    if [ "$SERVICE_ELASTIC" = 'disabled' ]; then
      systemctl enable elasticsearch 2>/dev/null || { echo -e "${RED}#${RESET} Failed to enable service | Elasticsearch"; sleep 3; }
    fi
fi

# Check if Logstash service is enabled
if ! [[ "${os_codename}" =~ (precise|maya|trusty|qiana|rebecca|rafaela|rosa) ]]; then
    SERVICE_LOGSTASH=$(systemctl is-enabled logstash)
    if [ "$SERVICE_LOGSTASH" = 'disabled' ]; then
      systemctl enable logstash 2>/dev/null || { echo -e "${RED}#${RESET} Failed to enable service | Logstash"; sleep 3; }
    fi
  else
    SERVICE_LOGSTASH=$(systemctl is-enabled logstash)
    if [ "$SERVICE_LOGSTASH" = 'disabled' ]; then
      systemctl enable logstash 2>/dev/null || { echo -e "${RED}#${RESET} Failed to enable service | Logstash"; sleep 3; }
    fi
fi

# Check if Kibana service is enabled
if ! [[ "${os_codename}" =~ (precise|maya|trusty|qiana|rebecca|rafaela|rosa) ]]; then
    SERVICE_KIBANA=$(systemctl is-enabled kibana)
    if [ "$SERVICE_KIBANA" = 'disabled' ]; then
      systemctl enable kibana 2>/dev/null || { echo -e "${RED}#${RESET} Failed to enable service | Kibana"; sleep 3; }
    fi
  else
    SERVICE_ELASTIC=$(systemctl is-enabled kibana)
    if [ "$SERVICE_ELASTIC" = 'disabled' ]; then
      systemctl enable kibana 2>/dev/null || { echo -e "${RED}#${RESET} Failed to enable service | Kibana"; sleep 3; }
    fi
fi

if [[ "${netcat_installed}" == 'true' ]]; then
  header
  echo -e "${WHITE_R}#${RESET} The script installed netcat, we do not need this anymore.\\n"
  echo -e "${WHITE_R}#${RESET} Uninstalling netcat..."
  apt-get purge netcat -y &> /dev/null && echo -e "${GREEN}#${RESET} Successfully uninstalled netcat." || echo -e "${RED}#${RESET} Failed to uninstall netcat."
  sleep 2
fi

if dpkg -l | grep "logstash" | grep -q "^ii\\|^hi"; then
  header
  echo -e "${GREEN}#${RESET} pfELK was installed successfully"
  echo -e "\\n"
  systemctl is-active -q kibana && echo -e "${GREEN}#${RESET} Logstash is active ( running )" || echo -e "${RED}#${RESET} Logstash failed to start... Please open an issue (pfelk.3ilson.dev) on github!"
  echo -e "\\n"
  echo -e "Open your browser and connect to http://$SERVER_IP:5601 to open Kibana"
  echo -e "Please check the documentation on github to configure your pfSense/OPNsense --> https://github.com/3ilson/pfelk/blob/master/install/configuration.md\\n"
  echo -e "\\n"
  sleep 5
  remove_yourself
else
  header_red
  echo -e "\\n${RED}#${RESET} Failed to successfully install pfELK"
  echo -e "${RED}#${RESET} Please contact pfELK (pfELK.3ilson.dev) on github!${RESET}\\n\\n"
  remove_yourself
fi
