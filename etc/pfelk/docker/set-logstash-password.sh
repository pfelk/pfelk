#!/bin/sh

elastic_password="$(grep "ELASTIC_PASSWORD" .env | cut -d "=" -f 2)"
logstash_system_password="$(grep "LOGSTASH_PASSWORD" .env | cut -d "=" -f 2)"
if [ "$logstash_system_password" = "changeme" ]; then
  echo "Set the LOGSTASH_PASSWORD environment variable in the .env file";
  exit 1;
fi
if [ "$elastic_password" = "changeme" ]; then
  echo "Set the ELASTIC_PASSWORD environment variable in the .env file";
  exit 1;
fi

sed -i "s/changeme/${elastic_password}/" etc/logstash/config/logstash.yml
sed -i "s/changeme/${elastic_password}/" etc/pfelk/conf.d/50-outputs.pfelk

echo "Successfully changed passwords in logstash configs."
