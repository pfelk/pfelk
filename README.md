## Welcome to pfSense + ELK

You can view installation guide guide on [3ilson.org YouTube Channel ](https://www.youtube.com/3ilsonorg).



### Prerequisites 
- Ubuntu Server v18.04+
- pfSense v2.4.4+


# Preparation

###1. Add Oracle Java Repository
```markdown
'sudo add-apt-repository ppa:webupd8team/java'

###2. Download and install the public GPG signing key
```markdown
'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -'

###3. Download and install apt-transport-https package 
```markdown
'sudo apt-get install apt-transport-https'


###4. Add Elasticsearch|Logstash|Kibana Repositories (version 6+) 
```markdown
'echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list'

###5. Update
```markdown
'sudo apt-get update'


###6. Install Java 8
```markdown
'sudo apt-get install oracle-java8-installer'


# Install
- Elasticsearch v6.6+ | Kibana v6.6+ | Logstash v6.6+

###8. Install Elasticsearch|Kibana|Logstash
```markdown
'sudo apt-get install elasticsearch && sudo apt-get install kibana && sudo apt-get install logstash'

# Configure Kibana|v6.6+

###9. Configure Kibana
```markdown
'sudo nano /etc/kibana/kibana.yml'

###10. Amend host file (/etc/kibana/kibana.yml)
```markdown
'server.port: 5601'
'server.host: "0.0.0.0"'

# Configure Logstash|v6.6+

###11. Change Directory
```markdown
'cd /etc/logstash/conf.d'

###12. Download the following configuration files
```markdown
'sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/01-inputs.conf'

```markdown
'sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/10-syslog.conf'

```markdown
'sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/11-pfsense.conf'

```markdown
'sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/30-outputs.conf'

###13. Make Patterns Folder
```markdown
'sudo mkdir /etc/logstash/conf.d/patterns'

###14. Navigate to Patterns Folder
```markdown
'cd /etc/logstash/conf.d/patterns/'

###15. Download the following configuration file
```markdown
'sudo wget https://raw.githubusercontent.com/a3ilson/pfelk/master/pfsense_2_4_2.grok'

###16. Edit (10-syslog.conf)arkdown
```markdown
'sudo nano /etc/logstash/conf.d/10-syslog.conf'

###17. Revise/Update w/pfsense IP address (10-syslog.conf)
```markdown
'Change line 3; the "if [host]..." should point to your pfSense IP address'
'Change line 9 to point to your second PfSense IP address of comment out'

###18. Edit (11-pfsense.conf)
```markdown
'sudo nano /etc/logstash/conf.d/11-pfsense.conf'

###19. Resive/Update timezone
```markdown
Change line 12 to the same timezone as your phSense configruation
_Note if the timezone is offset or mismatched, you may not see any logs_

###20. Download and install the MaxMind GeoIP database
```markdown
'cd /etc/logstash'

###21. Download and install the MaxMind GeoIP database
```markdown
'sudo wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz'

###22. Download and install the MaxMind GeoIP database
```markdown
'sudo gunzip GeoLite2-City.mmdb.gz'

#Configure Services

###Start Services on Boot as Services (you'll need to reboot or start manually to proceed)
```markdown
'sudo /bin/systemctl daemon-reload'
'sudo /bin/systemctl enable elasticsearch.service'
'sudo /bin/systemctl enable kibana.service'
'sudo /bin/systemctl enable logstash.service'

###Start Services Manually
```markdown
'sudo -i service elasticsearch start'
'sudo -i service kibana start'
'sudo -i service logstash start'

###Status
```markdown
'systemctl status elasticsearch.service'

'systemctl status kibana.service'

'systemctl status logstash.service'

###Troubleshooting
```markdown
'/var/log/logstash'

'cat/nano/vi the files within this location to view Logstash logs'
