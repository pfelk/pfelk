# Configuring (pfSense/OPNsense) + Elasticstack 
## Table of Contents
- [Services](#services)
- [Templates](#templates)
- [Kibana](#kibana)
- [Firewall](#firewall)
- [Finished](#finished)

# Services
### 1a. Start Services on Boot (you'll need to reboot or start manually to proceed)
```
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl enable kibana.service
sudo /bin/systemctl enable logstash.service
```
### 1b. Start Services Manually
```
systemctl start elasticsearch.service 
systemctl start kibana.service
systemctl start logstash.service
```

# Templates
### 2. Import required templates
>- In your web browser go to the pfELK local IP using port 5601 (ex: 192.168.0.1:5601)
>- Click ☰ in the upper left corner
>- Click on Dev Tools located near the bottom under the Management heading
>- Paste the contents of each template file located [here](https://github.com/pfelk/pfelk/tree/master/etc/logstash/conf.d/templates)
  >- [pfelk](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk)
  >- [pfelk-dhcp](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-dhcp)
  >- [pfelk-haproxy](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-haproxy)
  >- [pfelk-mappings-ecs](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-mappings-ecs)
  >- [pfelk-settings](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-settings)
  >- [pfelk-suricata](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-suricata)
>- Click the green triangle after pasting the contents (one at a time) into the console

![Templates](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/template-import.PNG)

# Kibana 
### 3a. Import required dashboards
>[YouTube Guide](https://www.youtube.com/watch?v=r7ZXQH4UFX8)
 >- In your web browser go to the pfELK local IP using port 5601 (ex: 192.168.0.1:5601)
 >- Click the menu icon (☰ three horizontal lines) in the upper left
 >- Under Management click -> Stack Management 
 >- Under Kibana click -> Saved Objects
 >- You can import the dashboards found in the [dashboard](https://github.com/pfelk/pfelk/tree/master/Dashboard) folder via the Import button in the top-right corner.
 >- [Firewall Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/v6.1%20-%20Firewall.ndjson)
 >- [DHCP Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/v6.1%20-%20DHCP.ndjson) - DHCPv4
 >- [HAProxy Dashboard](https://github.com/pfelk/pfelk/tree/master/Dashboard/v6.1) - Coming Soon
 >- [Unbound Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/v6.1%20-%20Unbound.ndjson)
 >- [Snort Dashboard](https://github.com/pfelk/pfelk/tree/master/Dashboard/v6.1) - Coming Soon
 >- [Squid Dashboard](https://github.com/pfelk/pfelk/tree/master/Dashboard/v6.1) - Coming Soon (after OPNSense v21 w/ECS for Squid)
 >- [Suricata Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/v6.1%20-%20Suricata.ndjson)

## Grafana
### 3b. Grafana - Alternative / Option (Externally Supported)
 - Visit [here](https://github.com/b4b857f6ee/opnsense_grafana_dashboard) to install/configure Grafana Dashboard
 
# Firewall 
### 4a. Login to pfSense and forward syslogs
- In pfSense navigate to Status->System Logs, then click on Settings.
- At the bottom check "Enable Remote Logging"
- (Optional) Select a specific interface to use for forwarding
- Enter the ELK local IP into the field "Remote log servers" with port 5140 (eg 192.168.100.50:5140)
- Under "Remote Syslog Contents" check "Everything"
- Click Save
![pfSense](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/pfsenselogs.png)
### 4b. Login to OPNsense and forward syslogs
- In OPNsense navigate to System->Settings->Logging/Targets
- Add a new Logging/Target (Click the plus icon)
![OPNsense](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense-logs.png)
- Transport = UDP(4)
- Applications = Nothing Selected
- Levels = Nothing Selected
- Facilities = Nothing Selected
- Hostname = Enter the IP address of where pfELK is installed (eg 192.168.100.50)
- Port = 5140
- Description = pfELK
- Click Save
![OPNsense](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense-remote.png)
### 4c. Configure Suricata for log forwarding - pfSense (Optional) 
[In-Depth Guide Here](https://github.com/pfelk/pfelk/wiki/How-To:-Suricata-on-pfSense)
 - On your pfSense web UI got to Services / Suricata / Interfaces, and enable Suricata on desired interfaces
 - You can have separate configuration on each of your interfaces, you can edit them via clicking on the pencil icon
 - You sould enable the EVE JSON output format for log forwarding, you should have the following options enabled at the EVE Output Settings section:
   - Eve JSON log: Suricata will output selected info in JSON format to a single file or to syslog. 
   - EVE Output type: SYSLOG
   - EVE Syslog Output Facility: AUTH
   - EVE Syslog Output Priority: NOTICE 
   - EVE Log Alerts: Suricata will output Alerts via EVE
   - Saving this will auto-enable settings at the Logging Settings menu, the Log Facility here should be LOCAL1, and the Log Priority should be NOTICE.
### 4d. Configure Suricata for log forwarding - OPNsense (Optional)    
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
![OPNsense-Suricata](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense-suricata.PNG)
### 4e. Configure Snort for log forwarding - pfsense (Optional)
- In pfsense navigate to Services->Snort->Snort Interfaces
 - For each interface you have configured, choose the edit pencil to the right (repeat these steps for each)
 - In each "Interface" Settings -> under Alert Settings check Send Alerts to System Log
 - Scroll down and Choose Save
 ![Snort-Log-Settings](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/snort-log-settings.png)
### 4f. Configure HAProxy for log forwarding - OPNsense (Optional)
 - In OPNsense navigate to Services->HAProxy->Settings->Settings->Logging Configuration
 - Log Host = Enter the IP address of where pfELK is installed and the Port 5190 (eg 192.168.100.50:5190)
 - Syslog facility = local0[default]
 - Filter syslog level = info[default]
 - Add the "httplog" under HAProxy->Settings->Virtual Services->Public Servers -> edit your public service
 - Enable "advanced mode" and scroll down
 - Under "Option pass-through" add "option httplog"
 ![OPNsense-HAProxy](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense_haproxy_http_log.PNG)
### 4g. Configure Squid for log forwarding - OPNsense (Optional)
 - In OPNsense navigate to Services->Web Proxy->Administration->General Proxy Settings
 - Enable "advanced mode"
 - Access log target = Syslog(Json)
 ![OPNsense-Squid](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense_squid_syslog.PNG)
### 4h. Configure Unbound DNS for full query log forwarding - pfSense/OPNsense (Optional)
 - In OPNsense navigate to Services->Unbound DNS->Advanced
 - Log level verbosity = ```Level 0```
 - Log Queries = [X]
 ![pfSense/OPNsense-Unbound](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/unbound_logging.png)
# Finished
### 5. Wait a few mintues after configuring the above and explore the enriched visualizations.
