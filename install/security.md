# Configuring 
## Table of Contents
- [Security](#security)
- [Templates](#zero-templates)
- [Dashboards](#one-dashboards)
  - [Manual-Method](a-manual-method)
  - [Scripted-Method](#b-scripted-method-page_with_curl)
- [Logstash](#three-start-logstash)

# Security
  0. Naviaget to the pfELK IP address (example: 192.168.0.1:5601)
     - Input the blah key 
     - Input the blah pin
  2. Reset the elastic user password to a known password
     - `sudo sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic`
  3. Navigate to the pfELK IP address (example: 192.168.0.1:5601)
     - Input `elastic` as the user name and the password provided in step 2 above
  4. Add Roles (copy and past each into the CLI and update with elastic password from step 2 above)
```
curl -X PUT "localhost:5601/api/security/role/pfelk_writer" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -u elastic:PASSWORDGOESHERE -d'
{
  "metadata" : {
    "version" : 2204
  },
  "elasticsearch": {
    "cluster" : ["manage_index_templates", "monitor", "manage_ilm"],
    "indices" : [{
      "names": [ "*-pfelk-*" ], 
      "privileges": ["write","create","create_index","manage","manage_ilm"]  
    }]
  },
  "kibana": [
    {
      "base": [],
      "feature": {
        "dashboard": ["read"]
      },
      "spaces": [
        "marketing"
      ]
    }
  ]
}
'
```


```
curl -X PUT "localhost:5601/api/security/role/pfelk_viewer" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -u elastic:PASSWORDGOESHERE -d'
{
  "metadata" : {
    "version" : 22
  },
  "elasticsearch": {
    "cluster" : [ ],
    "indices" : [ ]
  },
  "kibana": [
    {
      "base": ["all"],
      "feature": {
      },
      "spaces": [
        "default"
      ]
    }
  ]
}
'
```
  5. Create `pfelk_logstash` user
     - sdf
  7. Create `pfelk_viewer` user
     - sdf 
  9. Update 50-outputs.pfelk (only if you used a password other than `pf31k-l0g$tas#-p@sSw0Rd`)
     - `sudo nano /etc/pfelk/conf.d/50-outputs.conf`
       - update password to the pfelk_logstash user password from step 5

# :zero: Templates
  1. In your web browser navigate to the pfELK IP address using port 5601 (example: 192.168.0.1:5601)
  2. Click ☰ in the upper left corner
  3. Click on _Dev Tools_ located near the bottom under the _Management_ heading
  4. Paste the contents of each template file located in the [template :file_folder:](https://github.com/pfelk/pfelk/tree/main/etc/pfelk/templates) and links below
    - Component Templates
    - :small_red_triangle: **NOTE** _Component Templates must be installed first and in sequential order (e.g. pfelk-settings, pfelk-mappings-ecs etc...)_
      - [pfelk-mappings-ecs](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-mappings-ecs) - Install First
      - [pfelk-ilm](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-ilm) - Install Second
    - Index Templates
      - Click the green triangle after pasting the contents (one at a time) into the console
        - [pfelk](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk)
        - [pfelk-dhcp](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-dhcp)
        - [pfelk-haproxy](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-haproxy) - Optional
        - [pfelk-nginx](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-nginx) - Optional
        - [pfelk-suricata](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/templates/pfelk-suricata) - Optional
  5. :pushpin: References
      - [:movie_camera: YouTube Guide](https://youtu.be/KV27ouVUGuc?t=6)

# :one: Dashboards 
- ### :a: Manual Method
  1. In your web browser go to the pfELK IP address followed by port 5601 (e.g. 192.168.0.1:5601)
  2. Click the menu icon (☰ three horizontal lines) in the upper left
  3. Under _Management_ click -> _Stack Management_ 
  4. Under _Kibana_ click -> _Saved Objects_
  5. The dashboards are located in the [dashboard :file_folder:](https://github.com/pfelk/pfelk/tree/main/etc/pfelk/dashboard) and linked below
  6. Import one at a time by clicking the import button in the top-right corner
      - [Captive Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-captive.ndjson)
      - [DHCP Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-dhcp.ndjson) - DHCPv4
      - [Firewall Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.04-firewall.ndjson)
      - [HAProxy Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-haproxy.ndjson) - Optional
      - [NGINX Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-nginx.ndjson) - Optional
      - [Snort Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-snort.ndjson) - Optional
      - [Squid Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-squid.ndjson) - Optional
      - [Suricata Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-suricata.ndjson) - Optional
      - [Unbound Dashboard](https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/dashboard/22.01-unbound.ndjson) - Optional
  7. :pushpin: References
      - [:movie_camera: YouTube Guide](https://youtu.be/KV27ouVUGuc?t=281)

- ### :b: Scripted Method :page_with_curl:
  1. Download the pfelk-dashboard-installer
      - `wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/scripts/pfelk-kibana-saved-objects.sh`
  2. Update with the elastic password
      - `sudo nano pfelk-kibana-saved-objects.sh`
      - or
      - ` sed -i 's?PASSWORDGOESHERE?newpassword?' pfelk-kibana-saved-objects.sh` where `newpassword` is replaced with the elastic password from Secuirty Step 2
  3. Make the file executable 
      - `sudo chmod +x pfelk-kibana-saved-objects.sh`
  4. Execute the file
      - `sudo ./pfelk-kibana-saved-objects.sh`
  5. :pushpin: References
      - [:movie_camera: YouTube Guide](https://youtu.be/KV27ouVUGuc?t=228)

# :three: Start Logstash
  1. `systemctl start logstash.service`
