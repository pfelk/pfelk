# Configuring (pfSense/OPNsense) + Elasticstack 
## Table of Contents
- [Edit Rule Description](#rule)
- [Disable Swap](#swap)
- [Date/Time](#time)
- [Services](#services)
- [Firewall](#firewall)
- [Kibana](#kibana)
# Rule Description (Optional & pfSense Only)
### 1a. Retrieve Rules w/Descriptions (Optional & pfSense Only)
- Go to your pfSense GUI and go to Firewall -> Rules.
- Ensure the rules have a description, this is the text you will see in Kibana.
- Block rules normaly have logging on, if you want to see good traffic also, enable logging for pass rules.  

### 1b. Extract rule descriptions with associated tracking number (Optional & pfSense Only)
- In pfSense and go to diganotics -> commandline
- Enter the following command in the execute shell command box and click the execute button
```
pfctl -vv -sr | grep USER_RULE | sed 's/[^(]*(\([^)]*\).*"USER_RULE: *\([^"]*\).*/"\1"=> "\2"/' | sort -t ' ' -k 1,1 -u
```
The results will look something like this:
```
"1570852062"=> "OpenVPN  UDP 1194"
"1570852366"=> "OpenVPN TCP 444"
"1570891282"=> "LAN-Default Pass"
"1572797267"=> "DMZ-Block"
"1573529058"=> "HTTPS Web Server"
"1573529295"=> "HTTP Web Server"
"1583898798"=> "DMZ-Outbound Only"
"1583947034"=> "SSH node1"
"1770001239"=> "pfB_DNSBL_Ping"
"1770001466"=> "pfB_DNSBL_Permit"
"1770005939"=> "pfB_DNSBLIP_v4 auto rule"
```
Copy the entire results to your clipboard

### 1c. Update the logstash configuration (Optional & pfSense Only)
- Go back to the server you installed pfELK on.
```
sudo nano /etc/logstash/conf.d/35-rules-desc.conf
```
- Paste the the results from pfSense into the first blank line after `"0"=> "null"`
#### You must repeat step 1 (Rules) if you add new rules in pfSense and then restart logstash

# Swap
### 2. Disabling Swap
Swapping should be disabled for performance and stability.
```
sudo swapoff -a
```
# Time
### 3. Configuration Date/Time Zone
The box running this configuration will reports firewall logs based on its clock.  The command below will set the timezone to Eastern Standard Time (EST).  To view available timezones type `sudo timedatectl list-timezones`
```
sudo timedatectl set-timezone EST
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
# Kibana 
### 6a. Configuring Patterns
[YouTube Guide](https://www.youtube.com/watch?v=uBSRaUOgEz8)
- Click the gear icon (management) in the lower left
- Click Kibana -> Index Patters
- Click Create New Index Pattern
- Type "pf-*" into the input box, then click Next Step
### 6b. Import dashboards
[YouTube Guide](https://www.youtube.com/watch?v=r7ZXQH4UFX8)
 - In your web browser go to the ELK local IP using port 5601 (ex: 192.168.0.1:5601)
 - Click Management -> Saved Objects
 - You can import the dashboards found in the `Dashboard` folder via the Import button in the top-right corner.
 - [pfELK Dashboard](https://raw.githubusercontent.com/3ilson/pfelk/master/Dashboard/v4.2%20(042020)%20Dashboard.ndjson)
 - [Suricata Dashboard](https://raw.githubusercontent.com/3ilson/pfelk/master/Dashboard/v4.2%20(042020)%20Suricata%20Dashboard.ndjson)
 - [Snort Dashboard](https://raw.githubusercontent.com/3ilson/pfelk/master/Dashboard/v4.2%20(042020)%20Snort%20Dashboard.ndjson)
