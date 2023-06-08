#!/bin/bash
# Version    | 23.06
# Website    | https://github.com/pfelk/pfelk
########################################################
#pfELK Installation Script                             #
########################################################
# OS       | List of Supported Distributions/OS
#          | Ubuntu Focal Fossa  ( 20.04 )
#          | Ubuntu Hirsute Hippo (21.04)
#          | Ubuntu Impish Indri (21.10)
#          | Ubuntu Jammy Jellyfish (22.04)
#          | Debian Bullseye ( 11 )
#          | Debian Bookworm ( 12 )
########################################################
# Dependency Version                                   #
########################################################
# MaxMind      | https://github.com/maxmind/geoipupdate/releases
# GeoIP        | 5.1.1
# Elastic      | https://www.elastic.co/guide/en/elasticsearch/reference/current/es-release-notes.html
# Elasticstack | 8.8.1
########################################################
#Color Codes                                           #
########################################################
RESET='\033[0m'
WHITE='\033[1;37m'
WHITE_R='\033[39m'
RED='\033[1;31m'
GREEN='\033[1;32m'
########################################################
#Start Checks                                          #
########################################################
#Green Header
header() {
  clear
  echo -e "${GREEN}###############################################################################################${RED}pfELK${GREEN}#${RESET}\\n"
}
#Red Header
header_red() {
  clear
  echo -e "${RED}###############################################################################################${GREEN}pfELK${GREEN}#${RESET}\\n"
}
#Logo
script_logo() {
  cat << "EOF"
         __ ______ _      _  __  _____           _        _ _           
        / _|  ____| |    | |/ / |_   _|         | |      | | |          
  _ __ | |_| |__  | |    | ' /    | |  _ __  ___| |_ __ _| | | ___ _ __ 
 | '_ \|  _|  __| | |    |  <     | | | '_ \/ __| __/ _` | | |/ _ \ '__|
 | |_) | | | |____| |____| . \   _| |_| | | \__ \ || (_| | | |  __/ |   
 | .__/|_| |______|______|_|\_\ |_____|_| |_|___/\__\__,_|_|_|\___|_|   
 | |                                                                    
 |_|                                                                    
EOF
}
#Check for root (sudo)
if [[ "$EUID" -ne 0 ]]; then
  header_red
  script_logo
  echo -e "${RED}#${RESET} The script must run as root...\\n\\n"
  echo -e "${WHITE_R}#${RESET} For Ubuntu based systems run the command below to login as root"
  echo -e "${GREEN}#${RESET} sudo -i\\n"
  echo -e "${WHITE_R}#${RESET} For Debian based systems run the command below to login as root"
  echo -e "${GREEN}#${RESET} su\\n\\n"
  exit 1
fi
#Language
if ! env | grep "LC_ALL\\|LANG" | grep -iq "en_US\\|C.UTF-8"; then
  header
  script_logo
  echo -e "${WHITE_R}#${RESET} Your language is not set to English ( en_US ), the script will temporarily set the language to English."
  echo -e "${WHITE_R}#${RESET} Information: This is done to prevent issues in the script..."
  export LC_ALL=C &> /dev/null
  set_lc_all=true
fi
#Error...Abort Script
abort() {
  if [[ "${set_lc_all}" == 'true' ]]; then unset LC_ALL; fi
  echo -e "\\n\\n${RED}###############################################################################################${GREEN}23.03${RED}#${RESET}\\n"
  echo -e "${WHITE_R}#${RESET} An error occurred. Aborting script..."
  echo -e "${WHITE_R}#${RESET} Please open an issue (https://github.com/pfelk/pfelk) on github!\\n"
  echo -e "${WHITE_R}#${RESET} Creating support file..."
  mkdir -p "/tmp/pfELK/support" &> /dev/null
  if dpkg -l lsb-release 2> /dev/null | grep -iq "^ii\\|^hi"; then lsb_release -a &> "/tmp/pfELK/support/lsb-release"; fi
  df -h &> "/tmp/pfELK/support/df"
  free -hm &> "/tmp/pfELK/support/memory"
  uname -a &> "/tmp/pfELK/support/uname"
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
  pfELK_dir='/tmp/pfELK'
fi
#Start
start_script() {
  mkdir -p /tmp/pfELK/upgrade/ 2> /dev/null
  mkdir -p /tmp/pfELK/logs 2> /dev/null
  mkdir -p /tmp/pfELK/upgrade/ 2> /dev/null
  mkdir -p /tmp/pfELK/dpkg/ 2> /dev/null
  mkdir -p /tmp/pfELK/geoip/ 2> /dev/null  
  header
  script_logo
  echo -e "${GREEN}...............................................................................................(0%)"
  echo -e "\\n${WHITE_R}#${RESET} Starting the pfELK Install Script..."
  echo -e "${WHITE_R}#${RESET} Thank you for using pfELK Install Script :-)\\n\\n"
  sleep 4
}
start_script
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
#Update
header
script_logo
echo -e "${GREEN}###............................................................................................(4%)"
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
  apt-get update &> /tmp/pfELK/keys/apt_update
  if grep -qo 'NO_PUBKEY.*' /tmp/pfELK/keys/apt_update; then
    if [[ "${hide_apt_update}" == 'true' ]]; then hide_apt_update=true; fi
    run_apt_get_update
  fi
  fi
}
#Cancel Script
cancel_script() {
  if [[ "${set_lc_all}" == 'true' ]]; then unset LC_ALL &> /dev/null; fi
  header
  echo -e "${WHITE_R}#${RESET} Cancelling the script!\\n\\n"
  exit 0
}
#Distro Listing
get_distro() {
  if [[ -z "$(command -v lsb_release)" ]]; then
  if [[ -f "/etc/os-release" ]]; then
    if grep -iq VERSION_CODENAME /etc/os-release; then os_codename=$(grep VERSION_CODENAME /etc/os-release | sed 's/VERSION_CODENAME//g' | tr -d '="' | tr '[:upper:]' '[:lower:]')
    elif ! grep -iq VERSION_CODENAME /etc/os-release; then os_codename=$(grep PRETTY_NAME /etc/os-release | sed 's/PRETTY_NAME=//g' | tr -d '="' | awk '{print $4}' | sed 's/\((\|)\)//g' | sed 's/\/sid//g' | tr '[:upper:]' '[:lower:]')
    if [[ -z "${os_codename}" ]]; then os_codename=$(grep PRETTY_NAME /etc/os-release | sed 's/PRETTY_NAME=//g' | tr -d '="' | awk '{print $3}' | sed 's/\((\|)\)//g' | sed 's/\/sid//g' | tr '[:upper:]' '[:lower:]')
    fi
    fi
  fi
  else
  os_codename=$(lsb_release -cs | tr '[:upper:]' '[:lower:]')
  if [[ "${os_codename}" == 'n/a' ]]; then os_codename=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
  fi
  if [[ "${os_codename}" =~ (jammy) ]]; then os_codename=jammy; fi
  if [[ "${os_codename}" =~ (impish|hirsute) ]]; then os_codename=focal; fi
  fi
}
get_distro
#Codenames
if ! [[ "${os_codename}" =~ (focal|jammy|bullseye|bookworm)  ]]; then
  clear
  header_red
  echo -e "${WHITE_R}#${RESET} This script is not made for your OS."
  echo -e ""
  echo -e "OS_CODENAME = ${os_codename}"
  echo -e ""
  exit 1
fi
#Localhost
if ! grep -iq '^127.0.0.1.*localhost' /etc/hosts; then
  clear
  header_red
  scrip_logo
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
#Path
if [[ $(echo "${PATH}" | grep -c "/sbin") -eq 0 ]]; then
  PATH="$PATH:/sbin:/bin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/local/bin"
fi
#Repositories
if ! [[ -d /etc/apt/sources.list.d ]]; then mkdir -p /etc/apt/sources.list.d; fi
if ! [[ -d /tmp/pfELK/keys ]]; then mkdir -p /tmp/pfELK/keys; fi
#Check if --show-progress is supported in wget version
if wget --help | grep -q '\--show-progress'; then echo "--show-progress" &>> /tmp/pfELK/wget_option; fi
if [[ -f /tmp/pfELK/wget_option && -s /tmp/pfELK/wget_option ]]; then IFS=" " read -r -a wget_progress <<< "$(tr '\r\n' ' ' < /tmp/pfELK/wget_option)"; fi
#Check if MaxMind GeoIP is already installed
if dpkg -l | grep "geoipupdate" | grep -q "^ii\\|^hi"; then
  header
  script_logo
  echo -e "${GREEN}...............................................................................................(0%)"
  echo -e "${WHITE_R}#${RESET} MaxMind GeoIP is already installed on your system!${RESET}\\n\\n"
  read -rp $'\033[39m#\033[0m Would you like to remove MaxMind GeoIP? (Y/n) ' yes_no
  case "$yes_no" in
    [Yy]*|"")
    rm --force "$0" 2> /dev/null
    apt purge geoipupdate;;
    [Nn]*);;
  esac
fi
#Check if Elasticsearch is already installed
if dpkg -l | grep "elasticsearch" | grep -q "^ii\\|^hi"; then
  header
  script_logo
  echo -e "${GREEN}...............................................................................................(0%)"
  echo -e "${WHITE_R}#${RESET} Elasticsearch is already installed on your system!${RESET}\\n\\n"
  read -rp $'\033[39m#\033[0m Would you like to remove Elasticsearch? (Y/n) ' yes_no
  case "$yes_no" in
    [Yy]*|"")
    rm --force "$0" 2> /dev/null
    apt purge elasticsearch;;
    [Nn]*);;
  esac
fi
#Check if Logstash is already installed
if dpkg -l | grep "logstash" | grep -q "^ii\\|^hi"; then
  header
  script_logo
  echo -e "${GREEN}...............................................................................................(0%)"
  echo -e "${WHITE_R}#${RESET} Logstash is already installed on your system!${RESET}\\n\\n"
  read -rp $'\033[39m#\033[0m Would you like to remove Logstash? (Y/n) ' yes_no
  case "$yes_no" in
    [Yy]*|"")
    rm --force "$0" 2> /dev/null
    apt purge logstash;; 
    [Nn]*);; 
  esac
fi
#Check if Kibana is already installed
if dpkg -l | grep "kibana" | grep -q "^ii\\|^hi"; then
  header
  script_logo
  echo -e "${GREEN}...............................................................................................(0%)"
  echo -e "${WHITE_R}#${RESET} Kibana is already installed on your system!${RESET}\\n\\n"
  read -rp $'\033[39m#\033[0m Would you like to remove Kibana? (Y/n) ' yes_no
  case "$yes_no" in
    [Yy]*|"")
    rm --force "$0" 2> /dev/null
    apt purge kibana;; 
    [Nn]*);;
  esac
fi
#Packages Locked
dpkg_locked_message() {
  header_red
  echo -e "${WHITE_R}#${RESET} dpkg is locked... Waiting for other software managers to finish!"
  echo -e "${WHITE_R}#${RESET} If this is everlasting, please open an issue on pfELK on github!\\n\\n"
  sleep 5
  if [[ -z "$dpkg_wait" ]]; then
  echo "pfelk_lock_active" >> /tmp/pfelk_lock
  fi
}
#Packages Locked Wait
dpkg_locked_60_message() {
  header
  echo -e "${WHITE_R}#${RESET} dpkg is already locked for 60 seconds..."
  echo -e "${WHITE_R}#${RESET} Would you like to force remove the lock?\\n\\n"
}
#Packages Locked Check
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
#Script Version Check
script_version_check() {
  if dpkg -l curl 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  version=$(grep -i "# Version" "$0" | awk '{print $4}' | cut -d'-' -f1)
  script_online_version_dots=$(curl "https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/scripts/pfelk-installer.sh" -s | grep "# Version" | awk '{print $4}' | head -1)
  script_local_version_dots=$(grep "# Version" "$0" | awk '{print $4}' | head -1)
  script_online_version="${script_online_version_dots//./}"
  script_local_version="${script_local_version_dots//./}"
  # Script version check.
  if [[ "${script_online_version::3}" -gt "${script_local_version::3}" ]]; then
    header_red
    echo -e "${WHITE_R}#${RESET} You're currently running script version ${script_local_version_dots} while ${script_online_version_dots} is the latest!"
    echo -e "${WHITE_R}#${RESET} Downloading and executing version ${script_online_version_dots} of the pfELK Installation Script..\\n\\n"
    sleep 3
    rm --force "$0" 2> /dev/null
    rm --force "pfelk-install-${version}.sh" 2> /dev/null
    wget -q "${wget_progress[@]}" "https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/scripts/pfelk-installer.sh" && bash "pfelk-installer.sh"; exit 0
  fi
  else
  curl_missing=true
  fi
}
script_version_check
########################################################
#Variables                                             #
########################################################
system_memory=$(awk '/MemTotal/ {printf( "%.0f\n", $2 / 1024 / 1024)}' /proc/meminfo)
system_swap=$(awk '/SwapTotal/ {printf( "%.0f\n", $2 / 1024 / 1024)}' /proc/meminfo)
system_swap_var=0
system_mem_var=8
#MaxMind
maxmind_username=$(echo "${maxmind_username}")
maxmind_password=$(echo "${maxmind_password}")
maxmind_install=''
system_free_disk_space=$(df -kh / | awk '{print $4}' | tail -n1)
system_free_disk_space_tmp=$(df -kh /tmp | awk '{print $4}' | tail -n1)
#IP Address
SERVER_IP=$(ip addr | grep -A8 -m1 MULTICAST | grep -m1 inet | cut -d' ' -f6 | cut -d'/' -f1)
if [[ -z "${SERVER_IP}" ]]; then SERVER_IP=$(hostname -I | head -n 1 | awk '{ print $NF; }'); fi
PUBLIC_SERVER_IP=$(curl ifconfi.me/ -s)
architecture=$(dpkg --print-architecture)
get_distro
#Port Check
port_5601_in_use=''
port_5601_pid=''
port_5601_service=''
port_5140_in_use=''
port_5140_pid=''
port_5140_service=''
port_5040_in_use=''
port_5040_pid=''
port_5040_service=''
elk_version=8.8.1
maxmind_version=5.1.1
########################################################
#Required Packages                                     #
########################################################
# Install needed packages if not installed
install_required_packages() {
  sleep 2
  installing_required_package=yes
  script_logo
  header
  echo -e "${GREEN}...............................................................................................(1%)"
  echo -e "${WHITE_R}#${RESET} Installing required packages for the script.\\n"
  hide_apt_update=true
  run_apt_get_update
}
#Package Installation
if ! dpkg -l sudo 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing sudo..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install sudo &>> "${pfELK_dir}/logs/required.log"; then
  echo -e "${RED}#${RESET} Failed to install sudo in the first run...\\n"
  if [[ "${os_codename}" =~ (focal|jammy) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu ${os_codename} main") -eq 0 ]]; then
    echo -e "deb http://us.archive.ubuntu.com/ubuntu ${os_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  elif [[ "${os_codename}" =~ (bullseye|bookworm) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${os_codename} main") -eq 0 ]]; then
    echo -e "deb http://ftp.us.debian.org/debian ${os_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  fi
  required_package="sudo"
  apt_get_install_package
  else
  echo -e "${GREEN}#${RESET} Successfully installed sudo! \\n" && sleep 2
  fi
fi
#MaxMind GeoIP install
if dpkg -l | grep "geoipupdate" | grep -q "^ii\\|^hi"; then
   header
   echo -e "${WHITE_R}#${RESET} MaxMind GeoIP is already installed!${RESET}"; 
   echo -e "${WHITE_R}#${RESET} Ensure MaxMind GeoIP is properly configured!${RESET}";
   echo -e "${RED}# WARNING${RESET} Running Logstash without properly configured GeoIP settings will result in fatal errors...\\n\\n"
i=100005
sp="/-\|"
echo -n ' '
while [ $i -gt 1 ]
do
printf "\b${sp:i--%${#sp}:1}"
done;
else
header
script_logo
echo -e "${GREEN}...............................................................................................(1%)"
echo -e "${WHITE_R}#${RESET} Select GeoIP Database Type.${RESET}"; 
GeoIPType='Please specify GeoIP database type: '
options=("MaxMind" "Elastic")
select opt in "${options[@]}"
  do
  case $opt in
    "MaxMind")
    echo -e "${RED}#${RESET} MaxMind GeoIP Selected!\\n"
    #sleep 3
    read -rp $'\033[39m#\033[0m Do you have your MaxMind Account and Password credentials? (y/N) ' yes_no
      case "$yes_no" in
       [Yy]*)
       if [[ "${script_option_geoip}" != 'true' ]]; then
         maxmind_install=true
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
#GeoIP Cronjob
       echo "00 17 * * 0 geoipupdate -d /var/lib/GeoIP" > /etc/cron.weekly/geoipupdate
       sed -i 's/EditionIDs.*/EditionIDs GeoLite2-Country GeoLite2-City GeoLite2-ASN/g' /etc/GeoIP.conf
       maxmind_username=$(echo "${maxmind_username}")
       maxmind_password=$(echo "${maxmind_password}")
       read -p "Enter your MaxMind Account ID: " maxmind_username
       read -p "Enter your MaxMind License Key: " maxmind_password
       sed -i "s/AccountID.*/AccountID ${maxmind_username}/g" /etc/GeoIP.conf
       sed -i "s/LicenseKey.*/LicenseKey ${maxmind_password}/g" /etc/GeoIP.conf
       echo -e "\\n";
       mkdir -p /var/lib/GeoIP
       geoipupdate -d /var/lib/GeoIP
       sleep 2
       echo -e "\\n";;
       [Nn]*|"") 
       echo -e "${RED}#${RESET} MaxMind v${maxmind_version} not installed!"
       echo -e "${RED}#WARNING${RESET} Running Logstash without MaxMind will result in fatal errors...\\n"
       maxmind_install=false
       i=100005
       sp="/-\|"
       echo -n ' '
       while [ $i -gt 1 ]
       do
       printf "\b${sp:i--%${#sp}:1}"
       done;;
       esac
    echo -e "\\n"
    break
    ;;
    "Elastic")
    echo -e "${RED}#${RESET} Elastic's Built-In GeoIP Selected!\\n"
    i=100005
    sp="/-\|"
    echo -n ' '
    while [ $i -gt 1 ]
    do
    printf "\b${sp:i--%${#sp}:1}"
    done
    echo -e "\\n"
    break
    ;;
    *) echo "invalid option $REPLY";;
  esac
  done
fi
#lsb-release install
if ! dpkg -l lsb-release 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing lsb-release..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install lsb-release &>> "${pfELK_dir}/logs/required.log"; then
  echo -e "${RED}#${RESET} Failed to install lsb-release in the first run...\\n"
  if [[ "${os_codename}" =~ (focal|jammy) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu/ ${os_codename} main universe") -eq 0 ]]; then
    echo -e "deb http://us.archive.ubuntu.com/ubuntu/ ${os_codename} main universe" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  elif [[ "${os_codename}" =~ (bullseye|bookworm) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${os_codename} main") -eq 0 ]]; then
    echo -e "deb http://ftp.us.debian.org/debian ${os_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  fi
  required_package="lsb-release"
  apt_get_install_package
  else
  echo -e "${GREEN}#${RESET} Successfully installed lsb-release! \\n" && sleep 2
  fi
fi
#apt-transport install
if ! dpkg -l apt-transport-https 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing apt-transport-https..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install apt-transport-https &>> "${pfELK_dir}/logs/required.log"; then
  echo -e "${RED}#${RESET} Failed to install apt-transport-https on first attempt...\\n"
  if [[ "${os_codename}" =~ (focal|jammy) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu ${os_codename} main universe") -eq 0 ]]; then
    echo -e "deb http://us.archive.ubuntu.com/ubuntu ${os_codename} main universe" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  elif [[ "${os_codename}" =~ (bullseye|bookworm) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${os_codename} main") -eq 0 ]]; then
    echo -e "deb http://ftp.us.debian.org/debian ${os_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  fi
  required_package="apt-transport-https"
  apt_get_install_package
  else
  echo -e "${GREEN}#${RESET} Successfully installed apt-transport-https! \\n" && sleep 2
  fi
fi
#software-properties-common install
if ! dpkg -l software-properties-common 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing software-properties-common..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install software-properties-common &>> "${pfELK_dir}/logs/required.log"; then
  echo -e "${RED}#${RESET} Failed to install software-properties-common in the first run...\\n"
  if [[ "${os_codename}" =~ (focal|jammy) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu ${os_codename} main") -eq 0 ]]; then
    echo -e "deb http://us.archive.ubuntu.com/ubuntu ${os_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  elif [[ "${os_codename}" =~ (bullseye|bookworm) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${os_codename} main") -eq 0 ]]; then
    echo -e "deb http://ftp.us.debian.org/debian ${os_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  fi
  required_package="software-properties-common"
  apt_get_install_package
  else
  echo -e "${GREEN}#${RESET} Successfully installed software-properties-common! \\n" && sleep 2
  fi
fi
#curl install
if ! dpkg -l curl 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing curl..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install curl &>> "${pfELK_dir}/logs/required.log"; then
  echo -e "${RED}#${RESET} Failed to install curl in the first run...\\n"
  if [[ "${os_codename}" =~ (focal|jammy) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu ${os_codename} main") -eq 0 ]]; then
    echo -e "deb http://us.archive.ubuntu.com/ubuntu ${os_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  elif [[ "${os_codename}" =~ (bullseye|bookworm) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${os_codename} main") -eq 0 ]]; then
    echo -e "deb http://ftp.us.debian.org/debian ${os_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  fi
  required_package="curl"
  apt_get_install_package
  else
  echo -e "${GREEN}#${RESET} Successfully installed curl! \\n" && sleep 2
  fi
fi
#dirmngr install
if ! dpkg -l dirmngr 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing dirmngr..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install dirmngr &>> "${pfELK_dir}/logs/required.log"; then
  echo -e "${RED}#${RESET} Failed to install dirmngr in the first run...\\n"
  if [[ "${os_codename}" =~ (focal|jammy) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu/ ${os_codename} universe") -eq 0 ]]; then
    echo -e "deb http://us.archive.ubuntu.com/ubuntu/ ${os_codename} universe" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu/ ${os_codename} main restricted") -eq 0 ]]; then
    echo -e "deb http://us.archive.ubuntu.com/ubuntu/ ${os_codename} main restricted" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  elif [[ "${os_codename}" =~ (bullseye|bookworm) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${os_codename} main") -eq 0 ]]; then
    echo -e "deb http://ftp.us.debian.org/debian ${os_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  fi
  required_package="dirmngr"
  apt_get_install_package
  else
  echo -e "${GREEN}#${RESET} Successfully installed dirmngr! \\n" && sleep 2
  fi
fi
#wget install
if ! dpkg -l wget 2> /dev/null | awk '{print $1}' | grep -iq "^ii\\|^hi"; then
  if [[ "${installing_required_package}" != 'yes' ]]; then install_required_packages; fi
  echo -e "${WHITE_R}#${RESET} Installing wget..."
  if ! DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install wget &>> "${pfELK_dir}/logs/required.log"; then
  echo -e "${RED}#${RESET} Failed to install wget in the first run...\\n"
  if [[ "${os_codename}" =~ (focal|jammy) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://[A-Za-z0-9]*.archive.ubuntu.com/ubuntu ${os_codename} main") -eq 0 ]]; then
    echo -e "deb http://us.archive.ubuntu.com/ubuntu ${os_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  elif [[ "${os_codename}" =~ (bullseye|bookworm) ]]; then
    if [[ $(find /etc/apt/ -name "*.list" -type f -print0 | xargs -0 cat | grep -c "^deb http[s]*://ftp.[A-Za-z0-9]*.debian.org/debian ${os_codename} main") -eq 0 ]]; then
    echo -e "deb http://ftp.us.debian.org/debian ${os_codename} main" >>/etc/apt/sources.list.d/pfelk-install-script.list || abort
    fi
  fi
  required_package="wget"
  apt_get_install_package
  else
  echo -e "${GREEN}#${RESET} Successfully installed wget! \\n" && sleep 2
  fi
fi

if [[ "${curl_missing}" == 'true' ]]; then script_version_check; fi
########################################################
#Checks                                                #
########################################################
#Temporarily Disk Space
if [ "${system_free_disk_space_tmp}" -lt "5" ]; then
  header_red
  echo -e "${WHITE_R}#${RESET} Temporarily disk space is below 5GB. Please expand the disk size!"
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
#Disk Space
if [ "${system_free_disk_space}" -lt "5" ]; then
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
#Memory
if [ "${system_swap}" == "0" ]; then
  header_red
  script_logo
  echo -e "${GREEN}#..............................................................................................(1%)"
  echo -e "${WHITE_R}#${RESET} Disabling swap!"
  swapoff -a
  sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
i=100005
sp="/-\|"
echo -n ' '
while [ $i -gt 1 ]
do
printf "\b${sp:i--%${#sp}:1}"
done
fi
if [ "${system_memory}" -le "4" ]; then
  header_red
  script_logo
  echo -e "${RED}#${RESET} System memory does not meet minimum and may not run!"
  echo -e "${RED}#${RESET} This system has "${system_memory}"GB of RAM configured!"
  echo -e "${RED}#${RESET} It is recommend that ram is expanded to at least 8GB\\n\\n"
  sleep 2
  if [[ "${script_option_mem_skip}" != 'true' ]]; then
    read -rp "Do you want to proceed at your own risk? (Y/n)" yes_no
    case "$yes_no" in
      [Yy]*|"") ;;
      [Nn]*) cancel_script;;
    esac
    else
    cancel_script
  fi
else
  header
  script_logo
  echo -e "${GREEN}#.............................................................................................(2%)"
  echo -e "${WHITE_R}#${RESET} Memory Meets Minimum Requirements!\\n"
  echo -e "${GREEN}#${RESET} This system has "${system_memory}"GB of RAM configured!"
  echo -e "${GREEN}#${RESET} This system has "${system_swap}"GB swap allocated!"
  swapoff -a
  i=100005
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
fi
########################################################
#Installation Script starts here                       #
########################################################
start_pfelk() {
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --yes --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
  header
  script_logo
  i=100005
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
}
start_pfelk
#Upgrade Packages
system_upgrade() {
  header
  script_logo
  echo -e "${GREEN}##.............................................................................................(3%)"
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
  i=100005
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
}
#Upgrade Packages
rm --force /tmp/pfELK/upgrade/upgrade_list &> /dev/null
header
script_logo
echo -e "${GREEN}##.............................................................................................(3%)"
echo -e "${WHITE_R}#${RESET} Checking if your system is up-to-date...\\n" && sleep 1
hide_apt_update=true
run_apt_get_update
#Upgrade Packages
echo -e "${WHITE_R}#${RESET} The package(s) below can be upgraded!"
echo -e "\\n${WHITE_R}----${RESET}\\n"
rm --force /tmp/pfELK/upgrade/upgrade_list &> /dev/null
{ apt-get --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print "$1 ( \e[1;34m$2\e[0m -> \e[1;32m$3\e[0m )\n"}';} | while read -r line; do echo -en "${WHITE_R}-${RESET} $line\n"; echo -en "$line\n" | awk '{print $1}' &>> /tmp/pfELK/upgrade/upgrade_list; done;
if [[ -f /tmp/pfELK/upgrade/upgrade_list ]]; then number_of_updates=$(wc -l < /tmp/pfELK/upgrade/upgrade_list); else number_of_updates='0'; fi
if [[ "${number_of_updates}" == '0' ]]; then echo -e "${WHITE_R}#${RESET} There are no packages that need an upgrade..."; fi
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
i=100005
sp="/-\|"
echo -n ' '
while [ $i -gt 1 ]
do
printf "\b${sp:i--%${#sp}:1}"
done
########################################################
#Download and Configure pfELK Files                    #
########################################################
download_pfelk() {
  mkdir -p /etc/pfelk/{conf.d,config,logs,docker,databases,patterns,scripts,templates}
  wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/01-inputs.pfelk -P /etc/pfelk/conf.d/
  wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/05-apps.pfelk -P /etc/pfelk/conf.d/
  wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/30-geoip.pfelk -P /etc/pfelk/conf.d/
  wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/49-cleanup.pfelk -P /etc/pfelk/conf.d/
  wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/50-outputs.pfelk -P /etc/pfelk/conf.d/
  wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/patterns/pfelk.grok -P /etc/pfelk/patterns/
  wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/patterns/openvpn.grok -P /etc/pfelk/patterns/
  wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/scripts/error-data.sh -P /etc/pfelk/scripts/
  wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/.env -P /etc/pfelk/docker/
  wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/docker-compose.yml -P /etc/pfelk/docker/
  wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/config/logstash.yml -P /etc/pfelk/config/
  wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/config/pipelines.yml -P /etc/pfelk/config/
  chmod +x /etc/pfelk/scripts/pfelk-error.sh
  header
  script_logo
  echo -e "${GREEN}###............................................................................................(5%)"
  echo -e "\\n${WHITE_R}#${RESET} Setting up pfELK File Structure...\\n"
  i=100005
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
}
download_pfelk
#MaxMind
maxmind_geoip() {
#MaxMind check to ensure GeoIP database files were downloaded - Success
if [[ "${maxmind_install}" == 'true' ]] && [[ -f /var/lib/GeoIP/GeoLite2-City.mmdb ]] && [[ -f /var/lib/GeoIP/GeoLite2-ASN.mmdb ]]; then
  echo -e "\\n${GREEN}#${RESET} MaxMind Files Present"
  i=100005
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
fi
#MaxMind check to ensure GeoIP database files are downloaded - Error Display
if [[ "${maxmind_install}" == 'true' ]] && ! [[ -f /var/lib/GeoIP/GeoLite2-City.mmdb ]] && ! [[ -f /var/lib/GeoIP/GeoLite2-ASN.mmdb ]]; then
  echo -e "\\n${RED}#${RESET} Please Check Your MaxMind Configuration!"
  echo -e "${RED}#${RESET} MaxMind Files Where Not Found."
  echo -e "${RED}#${RESET} Defaulting to Elastic GeoIP Database Files."
  maxmind_install=false
  i=100005
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
fi
#MaxMind configuration, if utilized 
if [[ "${maxmind_install}" == 'true' ]]; then
  header
  echo -e "\\n${RED}#${RED} Modifying 30-geoip.pfelk for MaxMind!${RESET}\\n\\n";
  sed -i 's/^#MMR#//' /etc/pfelk/conf.d/30-geoip.pfelk
  i=100005
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
fi
}
maxmind_geoip
#Elasticsearch install
if dpkg -l | grep "elasticsearch" | grep -q "^ii\\|^hi"; then
  header
  echo -e "${WHITE_R}#${RESET} Elasticsearch is already installed!${RESET}\\n\\n";
else
  header
  script_logo
  echo -e "${GREEN}###............................................................................................(5%)"
  echo -e "${WHITE_R}#${RESET} Installing Elasticsearch...\\n"
  i=300005
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
  if [[ "${script_option_elasticsearch}" != 'true' ]]; then
    elasticsearch_temp="$(mktemp --tmpdir=/tmp elasticsearch_"${elk_version}"_XXX.deb)"
    echo -e "${WHITE_R}#${RESET} Downloading Elasticsearch..."
    if wget "${wget_progress[@]}" -qO "$elasticsearch_temp" "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${elk_version}-amd64.deb"; then echo -e "${GREEN}#${RESET} Successfully downloaded Elasticsearch version ${elk_version}! \\n"; else echo -e "${RED}#${RESET} Failed to download Elasticsearch...\\n"; abort; fi;
  else
    echo -e "${GREEN}#${RESET} Elasticsearch has already been downloaded!"
  fi
  echo -e "${WHITE_R}#${RESET} Installing Elasticsearch..."
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
#Logstash install
if dpkg -l | grep "logstash" | grep -q "^ii\\|^hi"; then
  header
  script_logo
  echo -e "${GREEN}####################...........................................................................(30%)"
  echo -e "${WHITE_R}#${RESET} Logstash is already installed!${RESET}\\n\\n";
else
  header
  echo -e "${WHITE_R}#${RESET} Installing Logstash...\\n"
  i=300005
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
  if [[ "${script_option_logstash}" != 'true' ]]; then
    logstash_temp="$(mktemp --tmpdir=/tmp logstash_"${elk_version}"_XXX.deb)"
    echo -e "${WHITE_R}#${RESET} Downloading Logstash..."
    if wget "${wget_progress[@]}" -qO "$logstash_temp" "https://artifacts.elastic.co/downloads/logstash/logstash-${elk_version}-amd64.deb"; then echo -e "${GREEN}#${RESET} Successfully downloaded Logstash version ${elk_version}! \\n"; else echo -e "${RED}#${RESET} Failed to download Logstash...\\n"; abort; fi;
  else
    echo -e "${GREEN}#${RESET} Logstash has already been downloaded!"
  fi
  echo -e "${WHITE_R}#${RESET} Installing Logstash..."
  echo "logstash logstash/has_backup boolean true" 2> /dev/null | debconf-set-selections
  if DEBIAN_FRONTEND=noninteractive dpkg -i "$logstash_temp" &>> "${pfELK_dir}/logs/logstash_install.log"; then
    echo -e "${GREEN}#${RESET} Successfully installed Logstash! \\n"
    i=300005
    sp="/-\|"
    echo -n ' '
    while [ $i -gt 1 ]
    do
    printf "\b${sp:i--%${#sp}:1}"
    done
  else
    echo -e "${RED}#${RESET} Failed to install Logstash...\\n"
    i=300005
    sp="/-\|"
    echo -n ' '
    while [ $i -gt 1 ]
    do
    printf "\b${sp:i--%${#sp}:1}"
    done
  fi
fi
rm --force "$logstash_temp" 2> /dev/null
#Updating logstash.yml & Restarting Logstash
update_logstash() {
  header
  script_logo
  echo -e "${GREEN}#####################################..........................................................(45%)"
  rm /etc/logstash/pipelines.yml
  wget -q -N https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/config/pipelines.yml -P /etc/logstash/
  chown logstash /etc/logstash/pipelines.yml
  echo -e "\\n${WHITE_R}#${RESET} Updated logstash.yml..."
  i=300005
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
}
update_logstash
#Kibana install
if dpkg -l | grep "kibana" | grep -q "^ii\\|^hi"; then
  header
  script_logo
  echo -e "${GREEN}#######################################........................................................(46%)"
  echo -e "${WHITE_R}#${RESET} Kibana is already installed!${RESET}\\n\\n";
else
  header
  echo -e "${WHITE_R}#${RESET} Installing Kibana...\\n"
  i=300005
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
  if [[ "${script_option_kibana}" != 'true' ]]; then
    kibana_temp="$(mktemp --tmpdir=/tmp kibana_"${elk_version}"_XXX.deb)"
    echo -e "${WHITE_R}#${RESET} Downloading Kibana..."
    if wget "${wget_progress[@]}" -qO "$kibana_temp" "https://artifacts.elastic.co/downloads/kibana/kibana-${elk_version}-amd64.deb"; then echo -e "${GREEN}#${RESET} Successfully downloaded Kibana version ${elk_version}! \\n"; else echo -e "${RED}#${RESET} Failed to download Kibana...\\n"; abort; fi;
  else
    echo -e "${GREEN}#${RESET} Kibana has already been downloaded!"
  fi
  echo -e "${WHITE_R}#${RESET} Installing Kibana..."
  echo "kibana kibana/has_backup boolean true" 2> /dev/null | debconf-set-selections
  if DEBIAN_FRONTEND=noninteractive dpkg -i "$kibana_temp" &>> "${pfELK_dir}/logs/kibana_install.log"; then
    echo -e "${GREEN}#${RESET} Successfully installed Kibana! \\n"
  else
    echo -e "${RED}#${RESET} Failed to install Kibana...\\n"
  fi
fi
rm --force "$kibana_temp" 2> /dev/null
#Update Kibana.yml
update_kibana() {
  header
  script_logo
  echo -e "${GREEN}###########################################################....................................(67%)"
  sed -i 's/#server.port: 5601/server.port: 5601/'  /etc/kibana/kibana.yml
  sed -i 's/#server.host: "localhost"/server.host: "0.0.0.0"/' /etc/kibana/kibana.yml
  echo -e "\\n${WHITE_R}#${RESET} Updating Kibana.yml..."
  i=300005
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
}
update_kibana
#Restart Kibana
service kibana start || abort
i=300005
sp="/-\|"
echo -n ' '
while [ $i -gt 1 ]
do
printf "\b${sp:i--%${#sp}:1}"
done
########################################################
#Finish                                                #
########################################################
#Check if Elasticsearch service is enabled
if [[ "${os_codename}" =~ (focal|jammy|bullseye|bookworm) ]]; then
  SERVICE_ELASTIC=$(systemctl is-enabled elasticsearch)
  if [ "$SERVICE_ELASTIC" = 'disabled' ]; then
    systemctl enable elasticsearch 2>/dev/null || { echo -e "${RED}#${RESET} Failed to enable service | Elasticsearch"; sleep 3; }
  fi
fi
#Add symbolic link for elasticsearch
add_es_syslink() {
  cd /etc/rc0.d
  ln -sf ../init.d/elasticsearch K02elasticsearch
  cd /etc/rc6.d
  ln -sf ../init.d/elasticsearch K02elasticsearch
}
add_es_syslink
#Check if Logstash service is enabled
if [[ "${os_codename}" =~ (focal|jammy|bullseye|bookworm) ]]; then
  SERVICE_LOGSTASH=$(systemctl is-enabled logstash)
  if [ "$SERVICE_LOGSTASH" = 'disabled' ]; then
    systemctl enable logstash 2>/dev/null || { echo -e "${RED}#${RESET} Failed to enable service | Logstash"; sleep 3; }
  fi
fi
#Check if Kibana service is enabled
if [[ "${os_codename}" =~ (focal|jammy|bullseye|bookworm) ]]; then
  SERVICE_KIBANA=$(systemctl is-enabled kibana)
  if [ "$SERVICE_KIBANA" = 'disabled' ]; then
    systemctl enable kibana 2>/dev/null || { echo -e "${RED}#${RESET} Failed to enable service | Kibana"; sleep 3; }
  fi
fi
#Check if elastic is active
STATUS_ELASTIC=$(systemctl is-active elasticsearch)
  if [ "$STATUS_ELASTIC" = 'active' ]; then
  echo -e "Elastic is running and active\\n"
  elif [ "$STATUS_ELASTIC" = 'inactive' ]; then
    echo -e "Elastic is not active\\n"
     INPUT="y"
     n=0
     while true; do
     echo -n "Press 'y' to try again or 's' to skip: "; read INPUT;
     if [ "$INPUT" == "y" ]; then
        until [ "$n" -ge 3 ]
        do
        systemctl is-active elasticsearch && break
        n=$((n+1))
        sleep 3
        done
        n=0
     elif [ "$INPUT" == "s" ]; then
     echo "Let's roll the dice."
     sleep 2
     break
     else
     n=0
  fi
done
fi
#Check if kibana is active
STATUS_KIBANA=$(systemctl is-active kibana)
  if [ "$STATUS_KIBANA" = 'active' ]; then
  echo -e "Kibana is running and active\\n"
  elif [ "$STATUS_KIBANA" = 'inactive' ]; then
    echo -e "Kibana is not active\\n"
     INPUT="y"
     n=0
     while true; do
     echo -n "Press 'y' to try again or 's' to skip: "; read INPUT;
     if [ "$INPUT" == "y" ]; then
        until [ "$n" -ge 3 ]
        do
        systemctl is-active kibana && break
        n=$((n+1))
        sleep 3
        done
        n=0
     elif [ "$INPUT" == "s" ]; then
     echo "Let's roll the dice."
     sleep 2
     break
     else
     n=0
  fi
done
fi
#Check if logstash is active
STATUS_LOGSTASH=$(systemctl is-active logstash)
  if [ "$STATUS_LOGSTASH" = 'active' ]; then
  echo -e "Logstash is running and active"
  elif [ "$STATUS_LOGSTASH" = 'inactive' ]; then
    echo -e "Logstash is not active\\n"
     INPUT="y"
     n=0
     while true; do
     echo "You Musth Skip! - security must be configured prior to logstash being active and running"
     echo -n "Press 'y' to try again or 's' to skip: "; read INPUT;
     if [ "$INPUT" == "y" ]; then
        until [ "$n" -ge 3 ]
        do
        systemctl is-active logstash && break
        n=$((n+1))
        sleep 3
        done
        n=0
     elif [ "$INPUT" == "s" ]; then
     echo "Let's roll the dice."
     sleep 2
     break
     else
     n=0
  fi
done
fi

#Download/Install Kibana saved objects
install_kibana_saved_objects() {
header
script_logo
echo -e "${GREEN}###############################################################................................(71%)"
if [[ "${os_codename}" =~ (focal|jammy|bullseye|bookworm) ]]; then
  SERVICE_KIBANA=$(systemctl is-active kibana)
  if ! [ "$SERVICE_KIBANA" = 'active' ]; then
     { echo -e "\\n${RED}#${RESET} Failed to Download pfELK - Kibana Saved Objects\\n\\n"; sleep 3; }
  else
     echo -e "\\n${WHITE_R}#${RESET} Downloading Kibana Saved Objects!${RESET}";
     wget -q https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/scripts/pfelk-kibana-saved-objects.sh -P /etc/pfelk/tmp/
     chmod +x /etc/pfelk/tmp/pfelk-kibana-saved-objects.sh
      echo -e "${GREEN}#${RESET} Done."
      i=300005
      sp="/-\|"
      echo -n ' '
      while [ $i -gt 1 ]
      do
      printf "\b${sp:i--%${#sp}:1}"
      done
  fi
fi
}
install_kibana_saved_objects
#Final Checks
if dpkg -l | grep "logstash" | grep -q "^ii\\|^hi"; then
  header
  script_logo
  echo -e "${GREEN}####################################################################...........................(74%)"
  echo -e "\\n"
  echo -e "${GREEN}#${RESET} pfELK was installed successfully"
  systemctl is-active -q kibana && echo -e "${GREEN}#${RESET} Logstash is active ( running )" || echo -e "${RED}#${RESET} Logstash failed to start... Please open an issue (https://github.com/pfelk/pfelk) on github!"

#Finalization
  header
  script_logo
  echo -e "${GREEN}##############################################################################################.(99%)${RESET}"
  echo -e "Navigate broswer to: ${GREEN}http://$SERVER_IP:5601${RESET}\\n"
  echo -e "Finish conguring Elastic Stack security --> ${GREEN}https://github.com/pfelk/pfelk/blob/main/install/security.md${RESET}\\n"
  echo -e "Finish conguring pfSense/OPNsense --> ${GREEN}https://github.com/pfelk/pfelk/blob/main/install/configuration.md${RESET}\\n"
  echo -e "${GREEN} Enrollment Token${RESET}"
  /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana --url "https://$SERVER_IP:9200"
  echo -e "\\n"
  echo -e "${GREEN} Kibana Verification Code${RESET}"
  /usr/share/kibana/bin/kibana-verification-code
  echo -e "\\n"
  mkdir -p /etc/logstash/config/
  cp /etc/elasticsearch/certs /etc/logstash/config/ -r
  chown -R logstash /etc/logstash/config/
  i=30000
  sp="/-\|"
  echo -n ' '
  while [ $i -gt 1 ]
  do
  printf "\b${sp:i--%${#sp}:1}"
  done
else
  header_red
  script_logo
  echo -e "\\n${RED}#${RESET} Failed to install pfELK"
  echo -e "${RED}#${RESET} Please contact pfELK (${RED}https://github.com/pfelk/pfelk${RESET}) via github!${RESET}\\n\\n"
fi
