# Configuring 
## Table of Contents
- [Security](#zero-security)
- [Certificates](#one-certificates)
- [Templates](#two-templates)
- [Dashboards](#three-dashboards)
  - [Manual-Method](a-manual-method)
  - [Scripted-Method](#b-scripted-method-page_with_curl)
- [Logstash](#four-start-logstash)

# :zero: Security
  0. Obtain the Enrollment token
     - `sudo /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token --scope kibana`
  1. Navigate to the pfELK IP address (example: 192.168.0.1:5601)
     - Input Enrollment Token
     - ![token](https://github.com/pfelk/pfelk/raw/main/Images/security/enrollment%20token.png)
     - Input Kibana Verification Code
     - `sudo /usr/share/kibana/bin/kibana-verification-code`
     - ![code](https://github.com/pfelk/pfelk/raw/main/Images/security/kcode.png)
  2. Reset the elastic user password to a known password
     - `sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic`
  3. Navigate to the pfELK IP address (example: 192.168.0.1:5601)
     - Input `elastic` as the user name and the password provided in step 1 above
     - ![elastic](https://github.com/pfelk/pfelk/raw/main/Images/security/elasticlogin.png)
  4. Add Roles (copy and past each into the CLI and update with elastic password from step 2 above)
     - ![writer](https://github.com/pfelk/pfelk/raw/main/Images/security/pfelkwriter.png)
     - ![viewer](https://github.com/pfelk/pfelk/raw/main/Images/security/pfelkviewer.png)
    a. 
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
     b.
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
     - ![logstash](https://github.com/pfelk/pfelk/raw/main/Images/security/logstash_user.png)
  7. Create `pfelk_viewer` user
     - ![viewer](https://github.com/pfelk/pfelk/raw/main/Images/security/viewer_user.png)
  9. Update 50-outputs.pfelk (only if you used a password other than `pf31k-l0g$tas#-p@sSw0Rd`)
     - `sudo nano /etc/pfelk/conf.d/50-outputs.conf`
       - update password to the pfelk_logstash user password from step 5
       - ![output](https://github.com/pfelk/pfelk/raw/main/Images/security/50-outputs.png)

# :one: Certificates
  1. `mkdir /etc/logstash/config/`
     - Create directory for certificates accessible by logstash
  3. `cp /etc/elasticsearch/certs /etc/logstash/config/ -r`
     - Copy the Elasticsearch certificates to logstash directory
  5. `chown -R logstash /etc/logstash/config/`
     - Make new folder and contents accessible by the logstash user

# :three: Configuration --> # [Templates](templates.md)
