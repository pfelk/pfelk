## Simple Installation Guide (pfSense/OPNsense) + Elastic Stack 

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Services](#services)
- [Certificates](#certificates)

# 1️⃣ Installation
- Elasticsearch v8+ | Kibana v8+ | Logstash v8+

### i1. Install Elasticsearch|Kibana|Logstash
```
sudo apt-get install elasticsearch kibana logstash
```

### i2. ⚠️ Obatin and Note Built-in superuser Password ⚠️ 
Scroll up after the installation and observer the output line which reads: `The generated password for the elastic built-in superuser is :`
- Copy the password for later use
- If skipped, a later step is provided for resetting this password

# 2️⃣ Configuration

### i3. Configure Kibana
```
sudo sed -i 's/#server.port: 5601/server.port: 5601/'  /etc/kibana/kibana.yml
```
```
sudo sed -i 's/#server.host: "localhost"/server.host: "0.0.0.0"/' /etc/kibana/kibana.yml
```

### i4. Configure Logstash
```
sudo wget -q -N https://raw.githubusercontent.com/pfelk/pfelk/main/etc/logstash/pipelines.yml -P /etc/logstash/
```

### i5. Create Required Directories
```
sudo mkdir -p /etc/pfelk/{conf.d,config,logs,databases,patterns,scripts,templates}
```

### i6. Download the following configuration files
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/01-inputs.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/02-firewall.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/05-apps.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/30-geoip.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/49-cleanup.pfelk -P /etc/pfelk/conf.d/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/conf.d/50-outputs.pfelk -P /etc/pfelk/conf.d/
```

### i7. Download the grok pattern
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/patterns/pfelk.grok -P /etc/pfelk/patterns/
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/patterns/openvpn.grok -P /etc/pfelk/patterns/
```

# 3️⃣ Services

### i8. (Optional) Start Services Automatically on Boot 
```
sudo /bin/systemctl daemon-reload
```
```
sudo /bin/systemctl enable elasticsearch.service
```
```
sudo /bin/systemctl enable kibana.service
```
```
sudo /bin/systemctl enable logstash.service
```

### i9a. Start Elasticsearch & Kibana
```
systemctl start elasticsearch.service
```
```
systemctl start kibana.service
```

### i10. Update the 50-outputs.pfelk with the password from step i2 above

  🅰️ Update 50-outputs.pfelk 
- `sudo nano /etc/pfelk/conf.d/50-outputs.pfelk`
- update password to the pfelk_logstash user password from step i2
- ![output](https://github.com/pfelk/pfelk/raw/main/Images/security/50-outputs.png)

  🅱️ Reset to obtain new password
- `sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic`


# 4️⃣ Certificates

### i11. Create directory for certificates accessible by logstash
- `sudo mkdir /etc/logstash/config/`

### i12. Copy the Elasticsearch certificates to logstash directory
- `sudo cp /etc/elasticsearch/certs /etc/logstash/config/ -r`

### i13. Make new folder and contents accessible by the logstash user
- `sudo chown -R logstash /etc/logstash/config/`


# Proceed to Install ➡️ [Security](security.md)

<sub>[Preparation](preparation.md)</sub> • **[Install](install.md)** • <sub>[Security](security.md)</sub> • <sub>[Templates](templates.md)</sub> • <sub>[Configuration](configuration.md)</sub>
