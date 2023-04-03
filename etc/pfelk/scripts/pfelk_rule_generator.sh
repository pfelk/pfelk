#!/bin/sh
# pfELK Firewall rules description generator

# Color Codes 
normal=`echo "\033[0m"`
blwhite=`echo "\033[01m"`
blue=`echo "\033[36m"` #Blue
yellow=`echo "\033[33m"` #yellow
red=`echo "\033[01;31m"`

script_logo() {
  cat << "EOF"
        ________________.____     ____  __. 
_______/ ____\_   _____/|    |   |    |/ _|
\____ \   __\ |    __)_ |    |   |      <  
|  |_> >  |   |        \|    |___|    |  \ 
|   __/|__|  /_______  /|_______ \____|__ \ 
|__|                 \/         \/       \/
    pfELK rule description generator v1

EOF
}

input-text(){
  clear
  script_logo
  help_script
}

help_script() {
  echo -e "Script usage:
sh $0 [options]
  
Script options:
  ${yellow}--opn-opt1		${normal}Generates the description of all rules for ${blue}OPNsense${normal}
  ${yellow}--opn-opt2		${normal}Generates only the description of the rules that are logged for ${blue}OPNsense${normal}
  ${yellow}--opn-opt3		${normal}Generates only the description of the rules you have created for ${blue}OPNsense${normal}
  ${yellow}--install-sync	${normal}Install the auto update script for ${red}OPNsense${normal}
  ${yellow}--remove-sync		${normal}remove the auto update script for ${red}OPNsense${normal}
  ${yellow}--pf-opt1		${normal}Generates the description of all rules ${blue}pfSense${normal}
  ${yellow}--pf-opt2		${normal}Generates only the description of the rules that are logged ${blue}pfSense${normal}
  ${yellow}--pf-opt3		${normal}Generates only the description of the rules you have created ${blue}pfSense${normal}
  "
}

show_menu_1(){
    printf "Please select your firewall distribution\n"
    printf "${yellow} (1)${normal} OPNsense\n"
    printf "${yellow} (2)${normal} pfSense\n"
    printf "Enter a number ${red}(q to quit)${normal}: "
    read opt
}

show_menu_2(){
  if [ "$opt" = "1" ]
  then
    firewall_opt opnsense
  else
    firewall_opt pfsense
  fi
    printf "Please select your verbose format\n"
    printf "${blue}${yellow} (1)${normal} All the rules ${blue}(${count_opt1} lines)${normal}\n"
    printf "${blue}${yellow} (2)${normal} Only rules that are logged by the firewall ${blue}(${count_opt2} lines)${normal}\n"
    printf "${blue}${yellow} (3)${normal} Only the rules you created ${blue}(${count_opt3} lines)${normal}\n"
    printf "Enter a number ${red}(q to quit)${normal}: "
    read opt2
}

firewall_opt(){
  $1_pfctl 2> /dev/null
  $1_opt1 2> /dev/null
  $1_opt2 2> /dev/null
  $1_opt3 2> /dev/null
  count_opt1=`count_opt opt1`
  count_opt2=`count_opt opt2`
  count_opt3=`count_opt opt3`
}

opnsense_pfctl(){
  pfctl -vv -sr | grep label | sed -r 's/@([[:digit:]]+).*"([^"]{32})".*/"\2","\1"/g' | sort -k 1.1 > /tmp/pfelk_rules_pfctl.tmp
}

opnsense_opt1(){
  cat /tmp/rules.debug | egrep -o '(\w{32}).*' | sed -r 's/([[:alnum:]]{32})(" # : |" # )(.*)/"\1","\3"/g' | sort -t, -u -k1.1 > /tmp/pfelk_rules_opt1.tmp
  opnsense_join opt1
}

opnsense_opt2(){
  cat /tmp/rules.debug | grep log | egrep -o '(\w{32}).*' | sed -r 's/(.*)([[:alnum:]]{32})(" # : |" # )(.*)/"\2","\4"/g' | sort -t, -u -k1.1 > /tmp/pfelk_rules_opt2.tmp
  opnsense_join opt2
}

opnsense_opt3(){
  cat /tmp/rules.debug | grep log | egrep -o '(\w{32}).*' | sed -r 's/([[:alnum:]]{32})(" # : )(.*)/"\1","\3"/g' | sort -t, -u -k1.1 > /tmp/pfelk_rules_opt3.tmp
  opnsense_join opt3
}

opnsense_join(){
  join -t "," -o 1.2,2.2 /tmp/pfelk_rules_pfctl.tmp /tmp/pfelk_rules_$1.tmp | sort -V | awk 'NR==1{$0="\"Rule\",\"Label\""RS$0}7' > /tmp/pfelk_rules_names_$1.csv
}

pfsense_opt1(){
  pfctl -vv -sr | grep label | sed -r 's/@([[:digit:]]+).*(label "|label "USER_RULE: )(.*)".*/"\1","\3"/g' | sort -V -u | awk 'NR==1{$0="\"Rule\",\"Label\""RS$0}7' > /tmp/pfelk_rules_names_opt1.csv
}

pfsense_opt2(){
  pfctl -vv -sr | grep label | grep log | sed -r 's/@([[:digit:]]+).*(label "|label "USER_RULE: )(.*)".*/"\1","\3"/g' | sort -V -u | awk 'NR==1{$0="\"Rule\",\"Label\""RS$0}7' > /tmp/pfelk_rules_names_opt2.csv
}

pfsense_opt3(){
  pfctl -vv -sr | grep USER_RULE | sed -r 's/@([[:digit:]]+).*(label "|label "USER_RULE: )(.*)".*/"\1","\3"/g' | sort -V -u | awk 'NR==1{$0="\"Rule\",\"Label\""RS$0}7' > /tmp/pfelk_rules_names_opt3.csv
}

count_opt(){
  grep -c ^ /tmp/pfelk_rules_names_$1.csv
}

output(){
  cp /tmp/pfelk_rules_names_$1.csv /tmp/rule-names.csv
  count=`grep -c ^ /tmp/rule-names.csv`
  path=`ls -d /tmp/rule-names.csv`
  if [ "$2" = "opn" ]
  then
    printf "${blue}${count}${normal} rules have been created for ${blue}OPNsense${normal}\n";
  fi
  if [ "$2" = "pf" ]
  then
    printf "${count} rules have been created for pfSense\n";
    cat /tmp/rule-names.csv
  fi
  if [ "$3" = "help" ]
  then
    printf "Now go to your pfELK server and paste the results from ${yellow}${path}${normal} into ${blue}/etc/pfelk/databases/rule-names.csv${normal}\n";
  fi
  rm /tmp/pfelk_rules*
}

install-sync(){
  clear
  echo -e "Downloading the ${yellow}pfelk_rule_sync.sh${normal} script..."
  curl --create-dirs https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/scripts/pfelk_rule_sync.sh -o /usr/local/opnsense/scripts/pfelk/pfelk_rule_sync.sh
  echo -e "The file ${yellow}/usr/local/opnsense/scripts/pfelk/pfelk_rule_sync.sh${normal} has been ${blue}created${normal}"
  chmod +x /usr/local/opnsense/scripts/pfelk/pfelk_rule_sync.sh
  echo -e "\nPlease provide the ${yellow}IP address (LAN) or Hostname${normal} for your ${blue}pfELK${normal}"; 
  read -p "Enter Your pfELK's IP Address/Hostname: " pfelk_ip
  sed -i '' 's/pfelk_ip=.*/pfelk_ip='"${pfelk_ip}"'/' /usr/local/opnsense/scripts/pfelk/pfelk_rule_sync.sh
  FILE=/usr/local/opnsense/service/conf/actions.d/actions_filter.conf.bak
  if [ ! -f "$FILE" ]; then
    echo -e "\nBackup from the original file ${yellow}actions_filter.conf${normal} to ${yellow}actions_filter.conf.bak${normal}"
    cp /usr/local/opnsense/service/conf/actions.d/actions_filter.conf /usr/local/opnsense/service/conf/actions.d/actions_filter.conf.bak
  else
    echo -e "\nThe backup file ${yellow}actions_filter.conf.bak${normal} exists"
  fi
  echo -e "Updated file ${yellow}actions_filter.conf${normal} to integrate the pfELK script"
  sed -i '' 's/command:\/usr\/local\/etc\/rc\.filter_configure.*/command:\/usr\/local\/etc\/rc\.filter_configure;\/usr\/local\/opnsense\/scripts\/pfelk\/pfelk_rule_sync.sh --sync/' /usr/local/opnsense/service/conf/actions.d/actions_filter.conf
  echo -e "\nRestart the ${yellow}configd service${normal}"
  service configd restart
  echo -e "\nStart the ${yellow}OPNSense filter service${normal}"
  configctl filter reload
  echo -e "\nYou will now see the message ${yellow}\"Reloading filter\"${normal} in the OPNsense log view here ${blue}System > Log Files > Backend${normal}"
}

remove-sync(){
  clear
  echo -e "Remove the ${yellow}pfelk_rule_sync.sh${normal} script..."
  rm -r /usr/local/opnsense/scripts/pfelk
  echo -e "Updated file ${yellow}actions_filter.conf${normal} to default"
  sed -i '' 's/command:\/usr\/local\/etc\/rc\.filter_configure.*/command:\/usr\/local\/etc\/rc\.filter_configure/' /usr/local/opnsense/service/conf/actions.d/actions_filter.conf
  rm /usr/local/opnsense/service/conf/actions.d/actions_filter.conf.bak
  echo -e "\nRestart the ${yellow}configd service${normal}"
  service configd restart
  echo -e "\nThe script was correctly ${yellow}uninstalled${normal}"
}

while [ -n "$1" ]; do
  case "$1" in
  --opn-opt1)
    var=opt1
    opnsense_pfctl 2> /dev/null
    opnsense_$var
    output $var opn
    exit;;
  --opn-opt2)
    var=opt2
    opnsense_pfctl 2> /dev/null
    opnsense_$var
    output $var opn
    exit;;
  --opn-opt3)
    var=opt3
    opnsense_pfctl 2> /dev/null
    opnsense_$var
    output $var opn
    exit;;
  --pf-opt1)
    var=opt1
    pfsense_$var 2> /dev/null
    output $var pf
    exit;;
  --pf-opt2)
    var=opt2
    pfsense_$var 2> /dev/null
    output $var pf
    exit;;
  --pf-opt3)
    var=opt3
    pfsense_$var 2> /dev/null
    output $var pf
    exit;;
  --sync)
    var=opt1
    opnsense_pfctl 2> /dev/null
    opnsense_$var
    output $var
    exit;;
  --install-sync)
    install-sync
    exit;;
  --remove-sync)
    remove-sync
    exit;;
  *)
    input-text
    printf "${red}option $1 is unknown${normal}\n";
    exit;;
  esac
  shift
done

input-text
show_menu_1

while [ $opt != '' ]
  do
  if [ $opt = '' ]; then
    exit;
  else
    case $opt in
    1) input-text
      printf "${blue}OPNsense selected!${normal}\n";
      show_menu_2
      while [ $opt2 != '' ]
        do
        if [ $opt2 = '' ]; then
          exit;
        else
          case $opt2 in
          1) input-text
            var=opt1
            output $var opn help
            exit;
          ;;
          2) input-text
            var=opt2
            output $var opn help
            exit;
          ;;
          3) input-text
            var=opt3
            output $var opn help
            exit;
          ;;
          q)exit;
          ;;
          \n)exit;
          ;;
          *)clear
            script_logo
            help_script
            printf "${red}Pick an option from the menu${normal}\n";
            show_menu_2;
          ;;
          esac
        fi
      done
    ;;
    2) input-text
      printf "${blue}pfSense selected!${normal}\n";
      show_menu_2
      while [ $opt2 != '' ]
        do
        if [ $opt2 = '' ]; then
          exit;
        else
          case $opt2 in
          1) input-text
            var=opt1
            output $var pf help
            exit;
          ;;
          2) input-text
            var=opt2
            output $var pf help
            exit;
          ;;
          3) input-text
            var=opt3
            output $var pf help
            exit;
          ;;
          q)exit;
          ;;
          \n)exit;
          ;;
          *)clear
            script_logo
            help_script
            printf "${red}Pick an option from the menu${normal}\n";
            show_menu_2;
          ;;
          esac
        fi
      done
    ;;
    q)exit;
    ;;
    \n)exit;
    ;;
    *)clear
      script_logo
      help_script
      printf "${red}Pick an option from the menu${normal}\n";
      show_menu_1;
    ;;
    esac
  fi
done
