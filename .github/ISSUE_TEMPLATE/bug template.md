---
name: Bug/Error report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Firewall System (please complete the following information):**
 - pfSense or OPNsense
 - Version 
 
**Operating System (please complete the following information):**
 - OS (`printf "$(uname -srm)\n$(cat /etc/os-release)\n"`):
 
 **Installation method (manual, ansible-playbook, docker, script):**
 
**Elasticsearch, Logstash, Kibana (please complete the following information):**
 - Version of ELK components (`dpkg -l [elasticsearch]|[logstash]|[kibana]`)
 
 **Elasticsearch, Logstash, Kibana logs:**
 - Elasticsearch logs (`tail -f /var/log/elasticsearch/[your-elk-cluster-name].log`)
 - Logstash logs (`tail -f /var/log/logstash/logstash-plain.log`)
 - Kibana logs (`journalctl -u kibana.service`)

**Additional context**
Add any other context about the problem here.

**Attach the pfELK Error Log (error.pfelk), for Better Assistance***
 - Do not copy/paste log; attach as a file
