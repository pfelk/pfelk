# Configuring 
## Table of Contents
- [Firewall](#zero-firewall)
  - [OPNsense](#a-opnsense)
  - [pfSense](#b-pfsense)
    - [Suricata](#one-suricata---optional)
    - [Snort](#two-snort---optional)
    - [Proxy](#three-proxy---optional)
      - [HAProxy](#a-haproxy---opnsense)
      - [NGINX](#b-nginx---opnsense)
    - [Squid](#four-squid---optional)
    - [Unbound](#five-unbound---optional)
- [Extras](#six-extras---optional)
- [Finished](#seven-finished)

# :zero: Firewall 
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
      - :o: [Screenshot](https://raw.githubusercontent.com/pfelk/pfelk/main/Images/opnsense-remote.png)
      - [:movie_camera: YouTube Guide](https://youtu.be/KV27ouVUGuc?t=369)
      - [WiKi Reference](https://github.com/pfelk/pfelk/wiki/How-To:-Prerequisite-%7C--pfSense-OPNsense-Logging)

- ### :b: pfSense 
  1. Navigate to _Status -> System Logs_, then click on _Settings_
  2. At the bottom check _Enable Remote Logging_
  3. (Optional) Select a specific interface to use for forwarding
  4. Input the ELK IP address into the field _Remote log servers_ followed by port 5140 (e.g. 192.168.100.50:5140)
  5. Under _Remote Syslog Contents_ check _Everything_
  6. Click Save
  7. :pushpin: References
      - :o: [Screenshot](https://raw.githubusercontent.com/pfelk/pfelk/main/Images/pfsenselogs.png)
      - [WiKi Reference](https://github.com/pfelk/pfelk/wiki/How-To:-Prerequisite-%7C--pfSense-OPNsense-Logging)

## :one: Suricata - (Optional)
- ### :a: OPNsense     
 1. In OPNsense navigate to _Services -> Intrusion Detection -> Administration_
     - Enable = [X]
     - IPS mode = [ ] or [X]
     - Promiscuous mode = [ ] or [X]
     - Enable syslog alerts = [ ] or [X]
     - Enable eve syslog output [X]
     - Pattern matcher = Default / Aho-Corasick /Hyperscan
     - Interfaces = Select As Necessary (must have at least one or nothing will be detected)
     - Rotate log = Default / Weekly / Daily
     - Save logs = Any Value You Desire
     - Click Apply
   
  2. :pushpin: References 
     - [:movie_camera: YouTube Guide](https://raw.githubusercontent.com/pfelk/pfelk/main/Images/opnsense-suricata.PNG)

- ### :b: pfSense 
 1. On your pfSense web UI go to _Services -> Suricata -> Interfaces_, and enable Suricata on desired interfaces
 2. You can have separate configuration for each of your interfaces, you can edit them via clicking on the pencil icon
 3. Enable the EVE JSON output format for log forwarding, enabled the following options within the EVE Output Settings section:
     - EVE JSON log: Suricata will output selected info in JSON format to a single file or to syslog. 
     - EVE Output type: FILE
     - EVE Syslog Output Facility: AUTH
     - EVE Syslog Output Priority: NOTICE 
     - EVE Log Alerts: Suricata will output Alerts via EVE
     - Saving this will auto-enable settings at the Logging Settings menu, the Log Facility should be "LOCAL1", and the Log Priority should be "NOTICE".
  4. :pushpin: References
     - :x: In-Depth Guide Located [Here](https://github.com/pfelk/pfelk/wiki/How-To:-Suricata-on-pfSense)

## :two: Snort - (Optional)
- ### :a: pfSense - Only
   1. Navigate to _Services -> Snort -> Snort Interfaces_
   2. For each configured interface, click on the pencil, to the right, to edit (repeat these steps for each)
   3. In each "Interface" Settings -> under _Alert Settings_ check _Send Alerts to System Log_
   4. Scroll down and choose _Save_
   5. :pushpin:  References 
       - :o: [Screenshot](https://raw.githubusercontent.com/pfelk/pfelk/main/Images/snort-log-settings.png)

## :three: Proxy - (Optional)
- ### :a: HAProxy - (OPNsense)
   1. Navigate to _Services -> HAProxy -> Settings -> Settings -> Logging Configuration_
   2. Log Host = Enter the IP address of where pfELK is installed and the Port 5140 (e.g. 192.168.100.50:5140)
   3. Syslog facility = local0[default]
   4. Filter syslog level = info[default]
   5. Add the _httplog_ under _HAProxy -> Settings -> Virtual Services -> Public Servers_ -> edit your public service
   6. Enable _advanced mode_ and scroll down
   7. Under _Option pass-through_ add _option httplog_
   8. :pushpin: References
       - :o: [Screenshot](https://raw.githubusercontent.com/pfelk/pfelk/main/Images/opnsense_haproxy_http_log.PNG)
       
- ### :b: NGINX - (OPNsense)
   1. Navigate to _Services -> Nginx -> Other -> SYSLOG Targets_
   2. Host = Enter the IP address of where pfELK is installed and the Port 5140 (e.g. 192.168.100.50:5140)
   3. Facility = local0
   4. Filter syslog level = info
   5. Add the created syslog target to your HTTP Server(s) under _HTTP(S) -> HTTP Server -> Select Server -> advanced mode -> SYSLOG Targets_
   6. Enable Extended Log on same page under _Access Log Format_ -> _Extended_
   
- ### :b: NGINX - (pfSense)
   - [WiKi Reference](https://github.com/pfelk/pfelk/wiki/How-To:-NGINX-on-pfSense)
   
## :four: Squid - (Optional)
- ### :a: OPNsense
   1. In OPNsense navigate to _Services -> Web Proxy -> Administration -> General Proxy Settings_
   2. Enable _advanced mode_
   3. Access log target = Syslog(JSON)
   4. :pushpin: References
       - :o: [Screenshot](https://raw.githubusercontent.com/pfelk/pfelk/main/Images/opnsense_squid_syslog.PNG)

## :five: Unbound - (Optional)
- ### :a: OPNsense
   1. In OPNsense navigate to _Services -> Unbound DNS -> Advanced_
   2. Log level verbosity = ```Level 0```
   3. Log Queries = [X]
   4. :pushpin: References
       - :o: [Screenshot](https://raw.githubusercontent.com/pfelk/pfelk/main/Images/unbound_logging.png)
   
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
   4. Set **Log Level** to `Level 0`: No Logging**

## :six: Extras - (Optional)
- ### :a: Grafana Dashborads (Externally Supported)
  - Visit [here](https://github.com/b4b857f6ee/opnsense_grafana_dashboard) to install/configure Grafana Dashboard
- ### :b: Microsoft Azure Sentinel (Externally Supported)
  - Visit [here](https://github.com/noodlemctwoodle/pfsense-azure-sentinel) to configure for Azure Sentinel
 
# :seven: Finished
- ### :clock5: Wait a few minutes after configuring the above and explore the enriched visualizations.

:end:
