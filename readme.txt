Instructions for using the pfelk scripted installation.
Please report any bugs or feature requests by opening an issue at https://github.com/3ilson/pfelk/issues

Basic Installation steps required:
 1) Download pfelk installation script from https://github.com/3ilson/pfelk
   a) sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/ez-pfelk-installer.sh
  I) Docker-pfelk from https://github.com/3ilson/docker-pfelk
  II) Docker-ansible from https://github.com/3ilson/ansible-pfelk
 2) Install 
   a) pfelk: ./ez-pfelk-installer.sh
   b) Docker-pfelk: docker-compose up
   c) Ansible-pfelk: ansible-playbook -i hosts --ask-become deploy-stack.yml
 3) Install Maxmind
   a) Create account at https://www.maxmind.com/en/geolite2/signup
   b) Input Maxmind (Line 7 & 8) credentials in /etc/GeoIP.conf
   c) Update EditionIDs (Line 13) to include "GeoLite2-City" "GeoLite2-Country" "GeoLite2-ASN"
 4) Update configuration file
      /data/pfELK/configurations/01-inputs.conf
      - Amend line 12 to match your pfSense/OPNsense IP address
      - Amend lines 34 & 31 
        - For pfSense uncommit line 34 and commit out line 31
        - For OPNsense uncommit line 31 and commit out line 34
 5) Configure Kibana
      /etc/kibana/kibana.yml
      - Amend file as follows:
        - server.port: 5601
        - server.host: "0.0.0.0"
 7) Start everything
   a) Start Manually:
      systemctl start elasticsearch.service 
	  systemctl start kibana.service
	  systemctl start logstash.service
   b) Start Services on Boot as Services
      sudo /bin/systemctl daemon-reload
      sudo /bin/systemctl enable elasticsearch.service
      sudo /bin/systemctl enable kibana.service
      sudo /bin/systemctl enable logstash.service
 8) View log files for errors
      /data/pfELK/logs/
 9) Visit http://PFELKIPADDRESSHERE:5601 with your favorite browser.

This is a basic installation not intended for production.  Highly recommend a customized Elastic Stack configuration for production.  For help or assistance with a recommended configuration contact support@pfelk.com   

Additional information can be found at:
  * https://github.com/3ilson/pfelk
Open forum chat can be accessible at:
  * https://gitter.im/pfelk/community
