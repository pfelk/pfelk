# Configuring (pfSense/OPNsense) + Elasticstack 
## Table of Contents
- [Disable Swap](#swap)
- [Date/Time](#time)
- [Services](#services)
- [Firewall](#firewall)
# Swap
#### - 1. Disabling Swap
If Elasticsearch (Elasticstack) is the only service running; there should be no need to have swap enabled.
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
#### - 4. Login to pfSense/OPNsense and forward syslogs
- In pfSense navigate to Status->System Logs, then click on Settings.
- In OPNsense navigate to System->Settings->Logging
- At the bottom check "Enable Remote Logging"
- (Optional) Select a specific interface to use for forwarding
- Enter the ELK local IP into the field "Remote log servers" with port 5140 (eg 192.168.100.50:5140)
- Under "Remote Syslog Contents" check "Everything"
- Click Save
