
# Troubleshooting
### t1. Create Logging Directory 
```
sudo mkdir -p /etc/pfelk/logs
```

### t2. Download Script
`error-data.sh`
```
sudo wget https://raw.githubusercontent.com/pfelk/pfelk/main/etc/pfelk/scripts/error-data.sh -P /etc/pfelk/scripts/
```

### t3. Make Script Executable
`error-data.sh` 
```
sudo chmod +x /etc/pfelk/scripts/error-data.sh
```

# Logstash Stop on Failure 
### i9. Amend logstash.service to Stop on Failure
```
sed -i 's?ExecStart=/usr/share/logstash/bin/logstash "--path.settings" "/etc/logstash"?ExecStart=/usr/share/logstash/bin/logstash "--pipeline.unsafe_shutdown" "--path.settings" "/etc/logstash"?' /etc/systemd/system/logstash.service
```
