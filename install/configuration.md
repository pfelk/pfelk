# Configuring 
## Table of Contents
- [Templates](#templates)
  - [Manual-Method](#one-manual-method)
  - [Scripted-Method](#two-scripted-method-page_with_curl)
- [Dashboards](#dashboards)
  - [Manual-Method](https://github.com/pfelk/pfelk/blob/master/install/configuration.md#one-manual-method-1)
  - [Scripted-Method](https://github.com/pfelk/pfelk/blob/master/install/configuration.md#two-scripted-method-page_with_curl-1)
- [Firewall](#firewall)
  - [pfSense](#one-pfsense)
  - [OPNsense](#two-opnsense)
  - [Suricata](#suricata-optional)
    - [pfSense](#three-pfsense)
    - [OPNSense](#four-opnsense)
  - [Snort](#snort-optional)
  - [HAProxy](#haproxy)
  - [Squid](#squid)
  - [Unbound](#unbound)
- [Extras](#extras)
  - [Grafana Dashboard](#one-grafana-dashborads-externally-supported)
  - [Microsoft Azure Sentinel](#two-microsoft-azure-sentinel-externally-supported)
- [Finished](#finished)

# Templates
- This step may be omited, it you installed utilzing the [pflek-installer.sh](https://raw.githubusercontent.com/pfelk/pfelk/master/pfelk-installer.sh) script :page_with_curl:
### :one: Manual Method
- In your web browser navigate to the pfELK IP address using port 5601 (ex: 192.168.0.1:5601)
- Click ☰ in the upper left corner
- Click on _Dev Tools_ located near the bottom under the _Management_ heading
- Paste the contents of each template file located in the [template :file_folder:](https://github.com/pfelk/pfelk/tree/master/etc/logstash/conf.d/templates) and links below
  - Component Templates
  - :small_red_triangle: **NOTE** _Component Templates must be installed first and in sequential order (e.g. pfelk-settings, pfelk-mappings-ecs etc...)_
    - [pfelk-settings](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-settings) - Install First
    - [pfelk-mappings-ecs](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-mappings-ecs) - Install Second
    - [pfelk-ilm](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-ilm) - Install Third
  - Index Templates
    - [pfelk](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk)
    - [pfelk-dhcp](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-dhcp)
    - [pfelk-haproxy](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-haproxy)
    - [pfelk-suricata](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-suricata)
- Click the green triangle after pasting the contents (one at a time) into the console

### :two: Scripted Method :page_with_curl:
- Download the pfelk-template-installer
  - `wget https://raw.githubusercontent.com/pfelk/pfelk/master/pfelk-template-installer.sh`
- Make the file executable 
  - `sudo chmod +x pfelk-template-installer.sh`
- Execute the file
  - `sudo ./pfelk-template-installer.sh`

# Dashboards 
- This step may be omited, it you installed utilzing the [pflek-installer.sh](https://raw.githubusercontent.com/pfelk/pfelk/master/pfelk-installer.sh) script :page_with_curl:
### :one: Manual Method
 - In your web browser go to the pfELK IP address followed by port 5601 (e.g. 192.168.0.1:5601)
 - Click the menu icon (☰ three horizontal lines) in the upper left
 - Under _Management_ click -> _Stack Management_ 
 - Under _Kibana_ click -> _Saved Objects_
 - The dashboards are located in the [dashboard :file_folder:](https://github.com/pfelk/pfelk/tree/master/Dashboard) and linked below
 - Import one at a time by clicking the import button in the top-right corner
   - [Firewall Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/Firewall.ndjson)
   - [DHCP Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/DHCP.ndjson) - DHCPv4
   - [HAProxy Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/HAProxy.ndjson)
   - [Unbound Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/Unbound.ndjson)
   - [Snort Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/Snort.ndjson)
   - [Squid Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/Squid.ndjson)
   - [Suricata Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/Suricata.ndjson)

:bulb: YouTube Guide [here](https://www.youtube.com/watch?v=r7ZXQH4UFX8)

### :two: Scripted Method :page_with_curl:
- Download the pfelk-dashboard-installer
  - `wget https://raw.githubusercontent.com/pfelk/pfelk/master/pfelk-dashboard-installer.sh`
- Make the file executable 
  - `sudo chmod +x pfelk-dashboard-installer.sh`
- Execute the file
  - `sudo ./pfelk-dashboard-installer.sh`
  
# Firewall 
### :one: pfSense 
- Navigate to _Status -> System Logs_, then click on _Settings_
- At the bottom check _Enable Remote Logging_
- (Optional) Select a specific interface to use for forwarding
- Input the ELK IP address into the field _Remote log servers_ followed by port 5140 (e.g. 192.168.100.50:5140)
- Under _Remote Syslog Contents_ check _Everything_
- Click Save

:pushpin: Reference: [Image](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/pfsenselogs.png)
### :two: OPNsense 
- Navigate to _System -> Settings -> Logging/Targets_
- Add a new _Logging/Target_ (Click the plus icon)
  - Transport = UDP(4)
  - Applications = Nothing Selected
  - Levels = Nothing Selected
  - Facilities = Nothing Selected
  - Hostname = Input the ELK IP address ointo (eg 192.168.100.50)
  - Port = 5140
  - Description = pfELK
  - Click Save
  
:pushpin: Reference: [Image](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense-remote.png)
## Suricata (Optional)
### :three: pfSense 
 - On your pfSense web UI go to _Services -> Suricata -> Interfaces_, and enable Suricata on desired interfaces
 - You can have separate configuration for each of your interfaces, you can edit them via clicking on the pencil icon
 - Enable the EVE JSON output format for log forwarding, enabled the following options within the EVE Output Settings section:
   - EVE JSON log: Suricata will output selected info in JSON format to a single file or to syslog. 
   - EVE Output type: SYSLOG
   - EVE Syslog Output Facility: AUTH
   - EVE Syslog Output Priority: NOTICE 
   - EVE Log Alerts: Suricata will output Alerts via EVE
   - Saving this will auto-enable settings at the Logging Settings menu, the Log Facility should be "LOCAL1", and the Log Priority should be "NOTICE".

:pushpin: Reference In-Depth Guide Located [Here](https://github.com/pfelk/pfelk/wiki/How-To:-Suricata-on-pfSense)
### :four: OPNsense     
 - In OPNsense navigate to _Services -> Intrusion Detection -> Administration_
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
   
:pushpin: Reference: [Image](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense-suricata.PNG)
## Snort (Optional)
### :five: pfSense (Only)
 - In pfSense navigate to _Services -> Snort -> Snort Interfaces_
 - For each configured interface, click on the pencil, to the right, to edit (repeat these steps for each)
 - In each "Interface" Settings -> under _Alert Settings_ check _Send Alerts to System Log_
 - Scroll down and choose _Save_


:pushpin: Reference: [Image](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/snort-log-settings.png)
## HAProxy 
### :six: HAProxy log forwarding - OPNsense (Optional)
 - In OPNsense navigate to _Services -> HAProxy -> Settings -> Settings -> Logging Configuration_
 - Log Host = Enter the IP address of where pfELK is installed and the Port 5190 (e.g. 192.168.100.50:5190)
 - Syslog facility = local0[default]
 - Filter syslog level = info[default]
 - Add the _httplog_ under _HAProxy -> Settings -> Virtual Services -> Public Servers_ -> edit your public service
 - Enable _advanced mode_ and scroll down
 - Under _Option pass-through_ add _option httplog_

:pushpin: Reference: [Image](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense_haproxy_http_log.PNG)
## Squid
### :seven: Squid log forwarding - (Optional)
 - In OPNsense navigate to _Services -> Web Proxy -> Administration -> General Proxy Settings_
 - Enable _advanced mode_
 - Access log target = Syslog(JSON)

:pushpin: Reference: [Image](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense_squid_syslog.PNG)
## Unbound
### :eight: Configure Unbound DNS log forwarding - (Optional)
 - In OPNsense navigate to _Services -> Unbound DNS -> Advanced_
 - Log level verbosity = ```Level 0```
 - Log Queries = [X]

:pushpin: Reference: [Image](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/unbound_logging.png)

# Extras (Optional)
### :one: Grafana Dashborads (Externally Supported)
 - Visit [here](https://github.com/b4b857f6ee/opnsense_grafana_dashboard) to install/configure Grafana Dashboard
### :two: Microsoft Azure Sentinel (Externally Supported)
 - Visit [here](https://github.com/noodlemctwoodle/pfsense-azure-sentinel) to configure for Azure Sentinel
 
# Finished
### :clock5: Wait a few mintues after configuring the above and explore the enriched visualizations.

:end:
