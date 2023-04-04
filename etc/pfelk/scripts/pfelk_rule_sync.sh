#!/bin/sh
# pfELK Firewall rules description sync

# pfELK variables
pfelk_ip=10.0.0.43

# Color Codes 
normal=`echo "\033[0;0m"`
blwhite=`echo "\033[0;01m"`
blue=`echo "\033[0;36m"` #Blue
yellow=`echo "\033[0;33m"` #yellow
red=`echo "\033[0;31m"`
green=`echo "\033[0;32m"`  # Green

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
  ${yellow}--sync	${normal}Force sync to ${blue}pfELK${normal} (${pfelk_ip})
  ${yellow}--check	${normal}Checks if the rules have been changed
  "
}

opnsense_pfctl(){
	pfctl -vv -sr | grep label | sed -r 's/@([[:digit:]]+).*"([^"]{32})".*/"\2","\1"/g' | sort -k 1.1 > /tmp/pfelk_rules_pfctl.tmp
}

opnsense_opt1(){
	cat /tmp/rules.debug | egrep -o '(\w{32}).*' | sed -r 's/([[:alnum:]]{32})(" # : |" # )(.*)/"\1","\3"/g' | sort -t, -u -k1.1 > /tmp/pfelk_rules_opt1.tmp
	opnsense_join opt1
}

opnsense_join(){
	join -t "," -o 1.2,2.2 /tmp/pfelk_rules_pfctl.tmp /tmp/pfelk_rules_$1.tmp | sort -V | awk 'NR==1{$0="\"Rule\",\"Label\""RS$0}7' > /tmp/pfelk_rules_names_$1.csv
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
		printf "Now go to your pfELK server and paste the results from ${yellow}${path}${normal} into ${blue}/etc/logstash/conf.d/databases/rule-names.csv${normal}\n";
	fi
	rm /tmp/pfelk_rules*
}

sync(){
	count=`grep -c ^ /tmp/rule-names.csv`
	printf "${blue}${count}${normal} rules have been sync to ${blue}pfELK$ ${yellow}(${pfelk_ip})${normal}\n";
	scp /tmp/rule-names.csv root@${pfelk_ip}:/etc/logstash/conf.d/databases/rule-names.csv
}

check(){
# Input file
FILE=/tmp/rules.debug
FILE2=/tmp/rule-names.csv
# How many seconds before file is deemed "newer"
OLDTIME=10
# Get current and file times
FILETIME=$(stat -t %s -f %m $FILE)
FILE2TIME=$(stat -t %s -f %m $FILE2)
READABLEFILETIME=$(stat -f %Sm $FILE)
READABLEFILE2TIME=$(stat -f %Sm $FILE2)
TIMEDIFF=$(expr $FILETIME - $FILE2TIME)

# Check if the file has been modified
	if [ $TIMEDIFF -gt $OLDTIME ]; then
	   printf "Please start the synchronization: ${blue}$0 --sync${normal}\n"
	   printf "Last modification of OPNsense rules on ${yellow}$READABLEFILETIME${normal}\n"
	   printf "Last modification of rules-names.csv on ${red}$READABLEFILE2TIME${normal}\n"
	else
	   printf "${yellow}Last change detected${normal} on ${blue}$READABLEFILETIME${normal}\n"
	fi
}


while [ -n "$1" ]; do
  case "$1" in
  --sync)
  		var=opt1
		opnsense_pfctl 2> /dev/null
		opnsense_$var
		output $var
		sync
		exit;;
  --check)
		check
		exit;;
  *)
		input-text
		printf "${red}option $1 is unknown${normal}\n";
		exit;;
  esac
  shift
done

input-text
