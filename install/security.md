# Security 

  1. Obtain the Enrollment token
     - `sudo /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token --scope kibana`
       
  1. Navigate to the pfELK IP address (example: 192.168.0.1:5601)
     - 🅰️ Input Enrollment Token
     - ![token](https://github.com/pfelk/pfelk/raw/main/Images/security/enrollment%20token.png)
     - 🅱️ Input Kibana Verification Code
     - `sudo /usr/share/kibana/bin/kibana-verification-code`
     - ![code](https://github.com/pfelk/pfelk/raw/main/Images/security/kcode.png)

  3. Navigate to the pfELK IP address (example: 192.168.0.1:5601)
     - Input `elastic` as the user name and the password utilized to upgrade 50-outputs.pfelk in the [installation step](https://github.com/pfelk/pfelk/blob/main/install/install.md#i2-%EF%B8%8F-obatin-and-note-built-in-superuser-password-%EF%B8%8F)

# Proceed to Install ➡️ [Templates](templates.md)

<sub>[Preparation](preparation.md)</sub> • <sub>[Install](install.md)</sub> • **[Security](security.md)** • <sub>[Templates](templates.md)</sub> • <sub>[Configuration](configuration.md)</sub>
