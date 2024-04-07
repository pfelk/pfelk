# Templates 
## Table of Contents
- [Templates](#one-templates)
- [Dashboards](#two-dashboards)
  - [Manual-Method](#a-manual-method)
  - [Scripted-Method](#b-scripted-method-page_with_curl)
- [Logstash](#three-start-logstash)


# :one: Templates
  1. In your web browser navigate to the pfELK IP address using port 5601 (example: 192.168.0.1:5601)
  2. Click ☰ in the upper left corner
  3. Click on _Dev Tools_ located near the bottom under the _Management_ heading
  4. Paste the contents of each template file located in the [template :file_folder:](https://github.com/pfelk/pfelk/tree/main/etc/pfelk/templates) and links below
    - Component Templates
    - :small_red_triangle: **NOTE** _Component Templates must be installed first and in sequential order (e.g. pfelk-settings, pfelk-mappings)_
      - [component_pfelk-mappings](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/component_template_pfelk-mappings) - Install First
      - [component_pfelk-settings](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/component_template_pfelk-settings) - Install Second
      - [pfelk-ilm](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-ilm) - Install Third        
    - Index Templates
      - Click the green triangle after pasting the contents (one at a time) into the console
        - [pfelk-firewall](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/index_template_pfelk-firewall)
        - [pfelk-kea-dhcp](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/index_template_pfelk-kea-dhcp) - Optional 
        - [pfelk-dhcp](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/index_template_pfelk-dhcp) - Depreciated
        - [pfelk-unbound](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/index_template_pfelk-unbound) - Optional
        - [pfelk-other](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/index_template_pfelk-other) - Optional
        - [pfelk-haproxy](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-haproxy) - Optional
        - [pfelk-nginx](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-nginx) - Optional
        - [pfelk-suricata](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-suricata) - Optional
  5. :pushpin: References
      - [:movie_camera: YouTube Guide](https://youtu.be/KV27ouVUGuc?t=6)

# :two: Dashboards 
- ### :a: Manual Method
  1. In your web browser go to the pfELK IP address followed by port 5601 (e.g. 192.168.0.1:5601)
  2. Click the menu icon (☰ three horizontal lines) in the upper left
  3. Under _Management_ click -> _Stack Management_ 
  4. Under _Kibana_ click -> _Saved Objects_
  5. The dashboards are located in the [dashboard :file_folder:](https://github.com/pfelk/pfelk/tree/main/etc/pfelk/dashboard) and linked below
  6. Import one at a time by clicking the import button in the top-right corner
      - [Firewall Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/23.09-firewall.ndjson)
      - [Captive Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-captive.ndjson) - Optional
      - [DHCP Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/24.02-dhcp.ndjson) - DHCPv4 & DHCPv6
      - [HAProxy Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-haproxy.ndjson) - Optional
      - [NGINX Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-nginx.ndjson) - Optional
      - [Snort Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-snort.ndjson) - Optional
      - [Squid Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-squid.ndjson) - Optional
      - [Suricata Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-suricata.ndjson) - Optional
      - [Unbound Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/23.08-unbound.ndjson) - Optional
  8. :pushpin: References
      - [:movie_camera: YouTube Guide](https://youtu.be/KV27ouVUGuc?t=281)

- ### :b: Scripted Method :page_with_curl: (Not for docker)
  1. Download the pfelk-dashboard-installer
      - `wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/scripts/pfelk-kibana-saved-objects.sh`
  2. Update with the elastic password
      - `sudo nano pfelk-kibana-saved-objects.sh`
      - or
      - ` sed -i 's?PASSWORDGOESHERE?newpassword?' pfelk-kibana-saved-objects.sh` where `newpassword` is replaced with the elastic password from [installation step, i2](https://github.com/pfelk/pfelk/blob/main/install/install.md#i2-%EF%B8%8F-obatin-and-note-built-in-superuser-password-%EF%B8%8F)
        
  3. Make the file executable 
      - `sudo chmod +x pfelk-kibana-saved-objects.sh`
  4. Execute the file
      - `sudo ./pfelk-kibana-saved-objects.sh`
  5. :pushpin: References
      - [:movie_camera: YouTube Guide](https://youtu.be/KV27ouVUGuc?t=228)

# :three: Start Logstash
  1. `systemctl start logstash.service`

# Proceed to Install ➡️ [Configuration](configuration.md)

<sub>[Preparation](preparation.md)</sub> • <sub>[Install](install.md)</sub> • <sub>[Security](security.md)</sub> • **[Templates](templates.md)** • <sub>[Configuration](configuration.md)</sub>
