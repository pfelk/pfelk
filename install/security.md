# pfELK security and access

## Docker deployment

- Run `pfelk-docker-init.sh` to create a private, mode-`0600` `.env` from
  `.env.example`. Never commit, share, or put `.env` in diagnostics.
- Elasticsearch listens on host loopback by default and uses TLS.
- Kibana uses HTTPS with a local certificate authority. Restrict `KIBANA_BIND`
  to approved networks and trust the issuing CA on client computers.
- Firewall syslog arrives on UDP/TCP port 5140 **without transport encryption
  by default**. Restrict source IPs and listener exposure; consider a TLS-enabled
  TCP collector, VPN, or dedicated syslog relay where appropriate.
- Logstash should use the restricted `pfelk_writer` identity, never `elastic`.
- Back up Elasticsearch with snapshots stored outside the same host; regularly
  test disaster recovery. A persistent queue is not a substitute for backups.

## Native Debian/Ubuntu deployment

The native installer binds Kibana to `127.0.0.1:5601` by default to avoid
exposing a plaintext browser session to the network. For remote administration,
forward the port through SSH:

```bash
ssh -L 5601:127.0.0.1:5601 user@pfelk-host
```

Then visit `http://127.0.0.1:5601` in your browser. If access must be shared
across a LAN, deploy a **TLS-secured reverse proxy** with access controls and
proper certificate validation, or configure native Kibana TLS; change the
binding only after confirming TLS terminates the browser connection.

The Elastic superuser should only be used for initial setup/administration.
Protect `/etc/pfelk/secrets` and the Logstash keystore, and avoid logging
credentials. Native GeoLite2 updates should keep the downloaded `.mmdb` files
readable by the Logstash process without exposing MaxMind license credentials.

## Evidence handling and data privacy

Network telemetry may contain addresses, hostnames, URLs and identifiers.
Define an appropriate retention policy, restrict user access, protect backups,
and avoid sharing `event.original` without reviewing sensitive content. For
investigative or legal evidence handling, retain separately authenticated raw
logs and hash manifests; Elasticsearch documents are not immutable evidence.
