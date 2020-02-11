# Docker Staus = "Work in progress"
- [X] Docker Working
- [ ] Create download script
- [X] Create Instructions
- [ ] Create Video Tutorial 

### (1) Required Prerequisits 
- [X] Docker 
- [X] Docker-Compose
- [X] Maxmind 

#### (1a) Docker Install
```
sudo apt-get install docker
```
```
sudo apt-get install docker-compose
```
#### (1b) MaxMind Install
```
sudo add-apt-repository ppa:maxmind/ppa
```
```
sudo apt-get install geoipupdate
```
### (2) Download pfELK Docker
```
sudo wget https://github.com/a3ilson/pfelk/raw/master/docker/pfelk.zip
```
#### (2a) Unzip pfelk.zip
```
sudo unzip pfelk.zip
```
#### (2b) Copy GeoIP Files (pfelk.zip:/logstash/GeoIP)
- [X] GeoLike2-ASN.mmdb 
- [X] GeoLite2-City.mmdb
- [X] GeoLite2-Country.mmdb 
```
sudo cp XXXX pfelk.zip:/logstash/GeoIP
```
### (3) Memory 
#### (3a) Set vm.max_map_count to no less than 262144 (must run each time host is booted)
```
sudo sysctl -w vm.max_map_count=262144
```
#### (3b) Set vm.max_map_count to no less than 262144 (one time configuration) 
```
grep vm.max_map_count /etc/sysctl.conf
vm.max_map_count=262144
```
### (4) Start Docker 
#### (3a) Set vm.max_map_count to no less than 262144 (must run each time host is booted)
```
sudo docker-compose up
```
### (5) Configuration
#### (5a) Edit 01-inputs.conf (pfelk.zip:/logstash/pipeline/01-inputs.conf)
Amend line #9 to match your pfSense or OPNsense IP address
#### (5b) Edit 01-inputs.conf (pfelk.zip:/logstash/pipeline/01-inputs.conf)
Amend line 24-29 comment or uncomment the OPNsense or pfSense grok pattern
### (6) Start Docker 
Once fully running, naviage to the host ip (ex: 192.168.0.100:5601)
