# Configuring 
## Table of Contents
- [Templates](#one-templates)
  - [Manual-Method](#a-manual-method)
  - [Scripted-Method](#b-scripted-method-page_with_curl)
- [Dashboards](#two-dashboards)
  - [Manual-Method](#a-manual-method-1)
  - [Scripted-Method](#b-scripted-method-page_with_curl-1)
- [Firewall](#three-firewall)
  - [OPNsense](#b-opnsense)
  - [pfSense](#a-pfsense)
    - [Suricata](#four-suricata---optional)
    - [Snort](#five-snort---optional)
    - [HAProxy](#six-haproxy---optional)
    - [Squid](#seven-squid---optional)
    - [Unbound](#eight-Unbound---optional)
- [Extras](#eight-extras---optional)
- [Finished](#nine-finished)

# :one: Templates
 :triangular_flag_on_post: This step may be omited, it you installed utilzing the [pflek-installer.sh](https://raw.githubusercontent.com/pfelk/pfelk/master/pfelk-installer.sh) script :page_with_curl:
- ### :a: Manual Method
  1. In your web browser navigate to the pfELK IP address using port 5601 (ex: 192.168.0.1:5601)
  2. Click ☰ in the upper left corner
  3. Click on _Dev Tools_ located near the bottom under the _Management_ heading
  4. Paste the contents of each template file located in the [template :file_folder:](https://github.com/pfelk/pfelk/tree/master/etc/logstash/conf.d/templates) and links below
    - Component Templates
    - :small_red_triangle: **NOTE** _Component Templates must be installed first and in sequential order (e.g. pfelk-settings, pfelk-mappings-ecs etc...)_
      - [pfelk-settings](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-settings) - Install First
      - [pfelk-mappings-ecs](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-mappings-ecs) - Install Second
      - [pfelk-ilm](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-ilm) - Install Third
    - Index Templates
      - Click the green triangle after pasting the contents (one at a time) into the console
        - [pfelk](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk)
        - [pfelk-dhcp](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-dhcp)
        - [pfelk-haproxy](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-haproxy)
        - [pfelk-suricata](https://raw.githubusercontent.com/pfelk/pfelk/master/etc/logstash/conf.d/templates/pfelk-suricata)
  5. :pushpin: References
      - [:movie_camera: YouTube Guide](https://youtu.be/KV27ouVUGuc?t=6)

- ### :b: Scripted Method :page_with_curl:
  1. Download the pfelk-template-installer
      - `wget https://raw.githubusercontent.com/pfelk/pfelk/master/pfelk-template-installer.sh`
  2. Make the file executable 
      - `sudo chmod +x pfelk-template-installer.sh`
  3. Execute the file
      - `sudo ./pfelk-template-installer.sh`
  4. :pushpin:  References
      - [:movie_camera: YouTube Guide](https://youtu.be/KV27ouVUGuc?t=60)

# :two: Dashboards 
 :triangular_flag_on_post: This step may be omited, it you installed utilzing the [pflek-installer.sh](https://raw.githubusercontent.com/pfelk/pfelk/master/pfelk-installer.sh) script :page_with_curl:
- ### :a: Manual Method
  1. In your web browser go to the pfELK IP address followed by port 5601 (e.g. 192.168.0.1:5601)
  2. Click the menu icon (☰ three horizontal lines) in the upper left
  3. Under _Management_ click -> _Stack Management_ 
  4. Under _Kibana_ click -> _Saved Objects_
  5. The dashboards are located in the [dashboard :file_folder:](https://github.com/pfelk/pfelk/tree/master/Dashboard) and linked below
  6. Import one at a time by clicking the import button in the top-right corner
      - [Firewall Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/Firewall.ndjson)
      - [DHCP Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/DHCP.ndjson) - DHCPv4
      - [HAProxy Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/HAProxy.ndjson)
      - [Unbound Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/Unbound.ndjson)
      - [Snort Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/Snort.ndjson)
      - [Squid Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/Squid.ndjson)
      - [Suricata Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/master/Dashboard/v6.1/Suricata.ndjson)
  7. :pushpin: References
      - [:movie_camera: YouTube Guide](https://youtu.be/KV27ouVUGuc?t=281)

- ### :b: Scripted Method :page_with_curl:
  1. Download the pfelk-dashboard-installer
      - `wget https://raw.githubusercontent.com/pfelk/pfelk/master/pfelk-dashboard-installer.sh`
  2. Make the file executable 
      - `sudo chmod +x pfelk-dashboard-installer.sh`
  3. Execute the file
      - `sudo ./pfelk-dashboard-installer.sh`
  4. :pushpin: References
      - [:movie_camera: YouTube Guide](https://youtu.be/KV27ouVUGuc?t=228)
      
# :three: Firewall 
- ### :a: OPNsense 
  1. Navigate to _System -> Settings -> Logging/Targets_
  2. Add a new _Logging/Target_ (Click the plus icon)
      - Transport = UDP(4)
      - Applications = Nothing Selected
      - Levels = Nothing Selected
      - Facilities = Nothing Selected
      - Hostname = Input the ELK IP address ointo (eg 192.168.100.50)
      - Port = 5140
      - Description = pfELK
      - Click Save    
  3. :pushpin: References
      - :o: [Screenshot](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense-remote.png)
      - [:movie_camera: YouTube Guide](https://youtu.be/KV27ouVUGuc?t=369)

- ### :b: pfSense 
  1. Navigate to _Status -> System Logs_, then click on _Settings_
  2. At the bottom check _Enable Remote Logging_
  3. (Optional) Select a specific interface to use for forwarding
  4. Input the ELK IP address into the field _Remote log servers_ followed by port 5140 (e.g. 192.168.100.50:5140)
  5. Under _Remote Syslog Contents_ check _Everything_
  6. Click Save
  7. :pushpin: References
      - :o: [Screenshot](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/pfsenselogs.png)

## :four: Suricata - (Optional)
- ### :a: OPNsense     
 1. In OPNsense navigate to _Services -> Intrusion Detection -> Administration_
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
   
  2. :pushpin: References 
     - [:movie_camera: YouTube Guide](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense-suricata.PNG)

- ### :b: pfSense 
 1. On your pfSense web UI go to _Services -> Suricata -> Interfaces_, and enable Suricata on desired interfaces
 2. You can have separate configuration for each of your interfaces, you can edit them via clicking on the pencil icon
 3. Enable the EVE JSON output format for log forwarding, enabled the following options within the EVE Output Settings section:
     - EVE JSON log: Suricata will output selected info in JSON format to a single file or to syslog. 
     - EVE Output type: SYSLOG
     - EVE Syslog Output Facility: AUTH
     - EVE Syslog Output Priority: NOTICE 
     - EVE Log Alerts: Suricata will output Alerts via EVE
     - Saving this will auto-enable settings at the Logging Settings menu, the Log Facility should be "LOCAL1", and the Log Priority should be "NOTICE".
  4. :pushpin: References
     - :x: In-Depth Guide Located [Here](https://github.com/pfelk/pfelk/wiki/How-To:-Suricata-on-pfSense)

## :five: Snort - (Optional)
- ### :a: pfSense - Only
   1. Navigate to _Services -> Snort -> Snort Interfaces_
   2. For each configured interface, click on the pencil, to the right, to edit (repeat these steps for each)
   3. In each "Interface" Settings -> under _Alert Settings_ check _Send Alerts to System Log_
   4. Scroll down and choose _Save_
   5. :pushpin:  References 
       - :o: [Screenshot](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/snort-log-settings.png)

## :six: HAProxy - (Optional)
- ### :a: OPNsense
   1. Navigate to _Services -> HAProxy -> Settings -> Settings -> Logging Configuration_
   2. Log Host = Enter the IP address of where pfELK is installed and the Port 5190 (e.g. 192.168.100.50:5190)
   3. Syslog facility = local0[default]
   4. Filter syslog level = info[default]
   5. Add the _httplog_ under _HAProxy -> Settings -> Virtual Services -> Public Servers_ -> edit your public service
   6. Enable _advanced mode_ and scroll down
   7. Under _Option pass-through_ add _option httplog_
   8. :pushpin: References
       - :o: [Screenshot](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense_haproxy_http_log.PNG)
     
## :seven: Squid - (Optional)
- ### :a: OPNsense
   1. In OPNsense navigate to _Services -> Web Proxy -> Administration -> General Proxy Settings_
   2. Enable _advanced mode_
   3. Access log target = Syslog(JSON)
   4. :pushpin: References
       - :o: [Screenshot](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/opnsense_squid_syslog.PNG)

## :eight: Unbound - (Optional)
- ### :a: OPNsense
   1. In OPNsense navigate to _Services -> Unbound DNS -> Advanced_
   2. Log level verbosity = ```Level 0```
   3. Log Queries = [X]
   4. :pushpin: References
       - :o: [Screenshot](https://raw.githubusercontent.com/pfelk/pfelk/master/Images/unbound_logging.png)
   
- ### :b: pfSense
   1. Navigate to **Services>>DNS Resolver** 
   2. Add the following line to the custom options: 
   ```
   server:
       log-queries: yes
   ........
   * any other custom config options *
   ```
   3. Navigate to **Services>>DNS Resolver>>Advance Settings**
   4. Set **Log Level** to **Level 0: No Logging**

## :eight: Extras - (Optional)
- ### :a: Grafana Dashborads (Externally Supported)
  - Visit [here](https://github.com/b4b857f6ee/opnsense_grafana_dashboard) to install/configure Grafana Dashboard
- ### :b: Microsoft Azure Sentinel (Externally Supported)
  - Visit [here](https://github.com/noodlemctwoodle/pfsense-azure-sentinel) to configure for Azure Sentinel
 
# :nine: Finished
- ### :clock5: Wait a few mintues after configuring the above and explore the enriched visualizations.

:end:
