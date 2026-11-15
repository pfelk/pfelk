# Docker Compose installation (Elastic Stack 9.x)

This guide applies to the current pfELK source checkout. **Do not mix files
from different branches or from an older upstream Docker guide.**

## Prerequisites

- A Linux host with Docker Engine and the **Compose v2 plugin** (`docker compose`).
- At least 8 GiB RAM; 16 GiB or more is recommended for sustained ingestion.
- Sufficient SSD storage for the planned event volume and retention.
- A trusted LAN interface or private network where firewall syslog can reach port 5140.
- A configured hostname for Kibana. The default `pfelk.local` must resolve on
  client machines if used. TLS certificates are generated on first deployment.

For Linux, set the Elasticsearch virtual-memory map allowance:

```bash
sudo sysctl -w vm.max_map_count=262144
# To make it persistent on a dedicated host:
echo 'vm.max_map_count=262144' | sudo tee /etc/sysctl.d/99-pfelk.conf
```

## Install

```bash
git clone https://github.com/4n6-monster/pfelk.git
cd pfelk
./etc/pfelk/scripts/pfelk-docker-init.sh
```

The script creates a private `.env` from `.env.example`, with three distinct
random passwords and mode `0600`. It refuses to replace an existing `.env`.
**Never commit `.env` or upload it with support logs.**

Edit `.env` to match your system:

- `KIBANA_SERVER_NAME`: DNS name clients use for the Kibana TLS certificate.
- `KIBANA_BIND`: host interface for HTTPS Kibana (prefer loopback or trusted LAN).
- `SYSLOG_BIND`: host LAN address receiving firewall syslog; protect with host ACLs.
- `PFELK_TIMEZONE`: IANA timezone for RFC3164 records without a timezone.
- `PFELK_RETENTION`, `PFELK_ERROR_RETENTION`: data-stream retention.
- `ES_MEM_LIMIT`, `LS_MEM_LIMIT`, and JVM heap settings: available host RAM.

```bash
docker compose config --quiet
docker compose up -d
docker compose ps
docker compose logs --tail=100 setup logstash
```

Access Kibana at `https://<KIBANA_SERVER_NAME>:5601`. The deployment generates
a private certificate authority (CA). Import and trust the CA appropriately;
do not disable certificate verification as a permanent workaround. To reach a
loopback-only Kibana from another workstation, use an SSH tunnel or a secured
reverse proxy that preserves TLS verification.

## Firewall configuration

Configure pfSense or OPNsense to forward selected logs to `<SYSLOG_BIND>:5140`.
Both UDP and TCP inputs are supported by the supplied Logstash configuration.
**Neither input has TLS enabled by default**; use only on an isolated/trusted
network, apply firewall source-IP ACLs, or configure TCP TLS with proper server
certificates and compatible clients. UDP can lose messages during congestion.
See [firewall configuration](configuration.md) and [security](security.md).

## Verify

```bash
docker compose ps
docker compose logs --tail=100 logstash
# Connect from an approved sender; then check the data streams in Kibana.
```

The deployed stack uses dataset-oriented data streams such as
`logs-pfelk.firewall-default` and `logs-pfelk.pipeline_error-default`.
Check the latter when unexpected messages do not parse correctly. Container
health checks alone do not prove end-to-end ingestion.

## Operations

- Back up the generated CA and credentials using an encrypted secret manager.
- Configure **off-host Elasticsearch snapshots** and test restoration; a Docker
  volume alone is not a recoverable backup.
- Monitor persistent queue size, DLQ growth, disk space, pipeline-error counts,
  input throughput, and log arrival delays.
- Pin a tested release or Git commit for production deployments.
- Review upstream Elastic release notes before changing `STACK_VERSION`; take
  a snapshot and document rollback procedures before upgrades.
- Do not expose Elasticsearch or Kibana directly to the internet.

### Troubleshooting

- `Missing .env.example`: verify this is the updated checkout.
- `.env already exists`: review the file; the initializer intentionally refuses
  to replace credentials. Never regenerate passwords on an existing stack
  without planning how the built-in users will be updated.
- Kibana certificate error: ensure the hostname matches `KIBANA_SERVER_NAME`
  and the generated CA is trusted. Changing the hostname after certificates
  have been generated requires a deliberate certificate rotation.
- Missing logs: verify source ACLs, listener port 5140, Logstash logs, parser
  errors, writer privileges, and Elasticsearch data-stream mappings.
