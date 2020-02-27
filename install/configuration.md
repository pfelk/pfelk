# Configuring (pfSense/OPNsense) + Elasticstack 
## Table of Contents
- [Disable Swap](#swap)
- [Date/Time](#time)
- [Services](#services)
- [Firewall](#firewall)
- [Kibana](#kibana)
# Swap
#### - 1. Disabling Swap
Swapping needs to be disabled for performance and stability.
```
sudo swapoff -a
```
# Time
#### - 2. Configuration Date/Time Zone
The box running this configuration will reports firewall logs based on its clock.  The command below will set the timezone to Eastern Standard Time (EST).  To view available timezones type `sudo timedatectl list-timezones`
```
sudo timedatectl set-timezone EST
```
# Services
#### - 3a. Start Services on Boot as Services (you'll need to reboot or start manually to proceed)
```
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl enable kibana.service
sudo /bin/systemctl enable logstash.service
```
#### - 3b. Start Services Manually
```
systemctl start elasticsearch 
systemctl start kibana 
systemctl start logstash 
```
# Firewall 
#### - 4a. Login to pfSense/OPNsense and forward syslogs
- In pfSense navigate to Status->System Logs, then click on Settings.
- In OPNsense navigate to System->Settings->Logging
- At the bottom check "Enable Remote Logging"
- (Optional) Select a specific interface to use for forwarding
- Enter the ELK local IP into the field "Remote log servers" with port 5140 (eg 192.168.100.50:5140)
- Under "Remote Syslog Contents" check "Everything"
- Click Save
#### - 4b. (Optional) Configure Suricata for log forwarding
 - On your pfSense web UI got to Services / Suricata / Interfaces, and enable Suricata on desired interfaces
 - You can have separate configuration on each of your interfaces, you can edit them via clicking on the pencil icon
 - You sould enable the EVE JSON output format for log forwarding, you should have the following options enabled at the EVE Output Settings section:
   - Eve JSON log: Suricata will output selected info in JSON format to a single file or to syslog. 
   - EVE Output type: SYSLOG
   - EVE Syslog Output Facility: AUTH
   - EVE Syslog Output Priority: NOTICE 
   - EVE Log Alerts: Suricata will output Alerts via EVE
   - Saving this will auto-enable settings at the Logging Settings menu, the Log Facility here should be LOCAL1, and the Log Priority should be NOTICE.
# Kibana 
#### - 5a. Configuring Patterns
- In your web browser go to the ELK local IP using port 5601 (ex: 192.168.0.1:5601)
- Click the wrench (Dev Tools) icon in the left pannel 
- Input the following and press the click to send request button (triangle)
- https://raw.githubusercontent.com/3ilson/pfelk/master/Dashboard/GeoIP(Template)
- Click the gear icon (management) in the lower left
- Click Kibana -> Index Patters
- Click Create New Index Pattern
- Type "pf-*" into the input box, then click Next Step
#### - 5b. Import dashboards
 - In your web browser go to the ELK local IP using port 5601 (ex: 192.168.0.1:5601)
 - Click Management -> Saved Objects
 - You can import the dashboards found in the `Dashboard` folder via the Import buttom in the top-right corner.
