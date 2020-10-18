# Configuring (pfSense/OPNsense) + Elasticstack 
## Table of Contents
- [Edit Rule Description](#rule)
- [Services](#services)
- [Firewall](#firewall)
- [Kibana](#kibana)
# Rule Description (Optional & pfSense Only)
### 1a. Retrieve Rules w/Descriptions (Optional & pfSense Only)
- Go to your pfSense GUI and go to Firewall -> Rules.
- Ensure the rules have a description, this is the text you will see in Kibana.
- Block rules normaly have logging on, if you want to see good traffic also, enable logging for pass rules.  

### 1b. Extract rule descriptions with associated tracking number (Optional & pfSense Only)
- In pfSense and go to diganotics -> Command Prompt
- Enter the following command in the execute shell command box and click the execute button
```
pfctl -vv -sr | grep USER_RULE | sed 's/@\([^(]*\).*"USER_RULE: *\([^"]*\).*/"\1","\2"/' | sort -t ' ' -k 1,1 -u
```
The results will look something like this:
```
"55","NAT Redirect DNS"
"56","NAT Redirect DNS"
"57","NAT Redirect DNS TLS"
"58","NAT Redirect DNS TLS"
"60","BypassVPN"
```
Copy the entire results to your clipboard and past within the rule-names.csv as follows:

```
"Rule","Label"
"55","NAT Redirect DNS"
"56","NAT Redirect DNS"
"57","NAT Redirect DNS TLS"
"58","NAT Redirect DNS TLS"
"60","BypassVPN"
```

### 1c. Update the logstash configuration (Optional & pfSense Only)
- Go back to the server you installed pfELK on.
```
sudo nano /etc/logstash/conf.d/databases/rule-names.csv
```
- Paste the the results from pfSense into the first blank line after `"0","null"` 
- Example:
```
"0","null"
"1","Input Firewall Description Here
```
#### You must repeat step 1 (Rules) if you add new rules in pfSense and then restart logstash

### 1d. Update firewall interfaces
- Amend the ```05-firewall.conf``` file 
```
sudo nano /etc/logstash/conf.d/05-firewall.conf
```
- Adjust the interface name(s) to correspond with your hardware (e.g. the interface below is referenced as ```igb0``` with a corresponding “Development” name for identification/filtering within pfELK).  Add/remove sections, depending on the number of interfaces.
```
      # Change interface as desired
        if [interface][name] =~ /^igb0$/ {
          mutate {
            add_field => { "[interface][alias]" => "DEV" }
            add_field => { "[network][name]" => "Development" }
        }
      }
```

# Services
### 4a. Start Services on Boot as Services (you'll need to reboot or start manually to proceed)
```
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl enable kibana.service
sudo /bin/systemctl enable logstash.service
```
### 4b. Start Services Manually
```
systemctl start elasticsearch.service 
systemctl start kibana.service
systemctl start logstash.service
```
# Firewall 
### 5a. Login to pfSense and forward syslogs
- In pfSense navigate to Status->System Logs, then click on Settings.
- At the bottom check "Enable Remote Logging"
- (Optional) Select a specific interface to use for forwarding
- Enter the ELK local IP into the field "Remote log servers" with port 5140 (eg 192.168.100.50:5140)
- Under "Remote Syslog Contents" check "Everything"
- Click Save
### 5b. Login to OPNsense and forward syslogs
- In OPNsense navigate to System->Settings->Logging/Targets
- Add a new Logging/Target (Click the plus icon)
![OPNsense](https://raw.githubusercontent.com/3ilson/pfelk/master/Images/opnsense-logs.png)
- Transport = UDP(4)
- Applications = Nothing Selected
- Levels = Nothing Selected
- Facilities = Nothing Selected
- Hostname = Enter the IP address of where pfELK is installed (eg 192.168.100.50)
- Port = 5140
- Description = pfELK
- Click Save
![OPNsense](https://raw.githubusercontent.com/3ilson/pfelk/master/Images/opnsense-remote.png)
### 5c. Configure Suricata for log forwarding - pfSense (Optional) 
 - On your pfSense web UI got to Services / Suricata / Interfaces, and enable Suricata on desired interfaces
 - You can have separate configuration on each of your interfaces, you can edit them via clicking on the pencil icon
 - You sould enable the EVE JSON output format for log forwarding, you should have the following options enabled at the EVE Output Settings section:
   - Eve JSON log: Suricata will output selected info in JSON format to a single file or to syslog. 
   - EVE Output type: SYSLOG
   - EVE Syslog Output Facility: AUTH
   - EVE Syslog Output Priority: NOTICE 
   - EVE Log Alerts: Suricata will output Alerts via EVE
   - Saving this will auto-enable settings at the Logging Settings menu, the Log Facility here should be LOCAL1, and the Log Priority should be NOTICE.
### 5d. Configure Suricata for log forwarding - OPNsense (Optional)    
 - In OPNsense navigate to Services->Intrusion Detection->Administration
 - Enable = [X]
 - IPS mode = [ ] or [X]
 - Promiscuous mode = [ ] or [X]
 - Enable syslog alerts = [ ] or [X]
 - Enable eve syslog output [X]
 - Pattern matcher = Default / Aho-Corasick /Hyperscan
 - Interfaces = Select As Nessessary (must have at least one or nothing will be detected)
 - Rotate log = Default / Weekly / Daily
 - Save logs = Any Value You Desire
 - Click Apply
![OPNsense-Suricata](https://raw.githubusercontent.com/3ilson/pfelk/master/Images/opnsense-suricata.png)
### 5e. Configure Snort for log forwarding - pfsense (Optional)
- In pfsense navigate to Services->Snort->Snort Interfaces
 - For each interface you have configured, choose the edit pencil to the right (repeat these steps for each)
 - In each "Interface" Settings -> under Alert Settings check Send Alerts to System Log
 - Scroll down and Choose Save
 ![Snort-Log-Settings](https://raw.githubusercontent.com/3ilson/pfelk/master/Images/snort-log-settings.png)
### 5f. Configure HAProxy for log forwarding - OPNsense (Optional)
 - In OPNsense navigate to Services->HAProxy->Settings->Settings->Logging Configuration
 - Log Host = ELK IP
 - Syslog facility = local0[default]
 - Filter syslog level = info[default]
 - Add the "httplog" under HAProxy->Settings->Virtual Services->Public Servers -> edit your public service
 - Enable "advanced mode" and scroll down
 - Under "Option pass-through" add "option httplog"
 ![OPNsense-HAProxy](https://raw.githubusercontent.com/3ilson/pfelk/master/Images/opnsense_haproxy_http_log.PNG)
### 5g. Configure Squid for log forwarding - OPNsense (Optional)
 - In OPNsense navigate to Services->Web Proxy->Administration->General Proxy Settings
 - Enable "advanced mode"
 - Access log target = Syslog(Json)
 ![OPNsense-Squid](https://raw.githubusercontent.com/3ilson/pfelk/master/Images/opnsense_squid_syslog.PNG)
### 5h. Configure Unbound DNS for full query log forwarding - OPNsense (Optional)
 - In OPNsense navigate to Services->Unbound DNS->Advanced
 - Log Queries = [X]
 ![OPNsense-Unbound](https://raw.githubusercontent.com/3ilson/pfelk/master/Images/opnsense_unbound_queries.PNG)
# Kibana 
### 6. Import dashboards
[YouTube Guide](https://www.youtube.com/watch?v=r7ZXQH4UFX8)
 - In your web browser go to the pfELK local IP using port 5601 (ex: 192.168.0.1:5601)
 - Click the ☰ menu icon (three horizontal lines) in the upper left
 - Under Management click -> Stack Management 
 - Under Kibana click -> Saved Objects
 - You can import the dashboards found in the [dashboard](https://github.com/3ilson/pfelk/tree/master/Dashboard) folder via the Import button in the top-right corner.
 - [pfELK Dashboard](https://raw.githubusercontent.com/3ilson/pfelk/master/Dashboard/v6.0/v6.0%20-%20Firewall.ndjson)
 - [Unbound Dashboard](https://raw.githubusercontent.com/3ilson/pfelk/master/Dashboard/v6.0/v6.0%20-%20Unbound.ndjson)
 - [Squid Dashboard](https://raw.githubusercontent.com/3ilson/pfelk/master/Dashboard/v6.0/v6.0%20-%20Squid.ndjson)
 - [Suricata Dashboard](https://raw.githubusercontent.com/3ilson/pfelk/master/Dashboard/v6.0/v6.0%20-%20Suricata.ndjson)
 - [Snort Dashboard](#) - Coming Soon
 - [HAProxy Dashboard](#) - Coming Soon
