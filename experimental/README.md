## Suricata & ~Snort~ Enrichment

### Requirements 
- [ ] Installation of pfELK
- [ ] Copy files located in the [conf.d](https://github.com/pfelk/pfelk/tree/master/experimental/conf.d) folder to `/etc/logstash/conf.d/`
- [ ] Copy files located in the [ruby](https://github.com/pfelk/pfelk/tree/master/experimental/conf.d/ruby) folder to `/etc/logstash/conf.d/ruby/`
- [ ] Copy files located in the [databases](https://github.com/pfelk/pfelk/tree/master/experimental/conf.d/databases) folder to `/etc/logstash/conf.d/databases/`
  - Be sure to unzip [ip_rep_basic.yml.zip](https://github.com/pfelk/pfelk/raw/master/experimental/conf.d/databases/ip_rep_basic.yml.zip)
    - The file was too large to upload dirclty to GitHub

- [ ] Restart logstash 

### Roadmap
~- [ ] Enrich Snort~
- [ ] Build out Suricata Dashboard *currenlty works with the built-in SIEM*
- [ ] Build out Snort Dashboard 

 :warning: Please only report bugs at this time... and feel free to contribute (enhance) as the rollout for this is low priority

References:

https://github.com/ipworkx/ecs-suricata

https://github.com/robcowart/synesis_lite_snort
