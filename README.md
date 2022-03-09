<h1>Enonic Cloud Vector image</h1>

- [Usage](#usage)
- [Configuration](#configuration)
- [Configuring Apache](#configuring-apache)
- [Example output data](#example-output-data)

## Usage

```yaml
version: '3'

services:
  vector:
    image: enoniccloud/vector:0.20.0-alpine-1
    network_mode: host # Has to be for correct host metrics
    hostname: "organization-project-instance"
    environment:
      EC_ORG: organization
      EC_PROJ: project
      EC_INST: instance
      
    volumes:
      - ./your_output.yml:/etc/vector/output/output.yml:ro
      - /var/run/docker.sock:/var/run/docker.sock
```

## Configuration

Environmental variables:

| Name | Default | Description |
| --- | --- | --- |
| APACHE_CONTAINER_NAME | apache | Name of Apache container to collect logs |
| APACHE_LOG_TYPE | common | Log type of Apache logs |
| APACHE_SCRAPE_ENDPOINT | http://localhost:80/server-status/?auto | Endpoint for Apache metrics scraping |
| APACHE_SCRAPE_INTERVAL | 30 | Interval for Apache metrics scraping |
| XP_CONTAINER_NAME | exp | Name of XP container to collect logs |
| XP_SCRAPE_INTERVAL | 30 | Interval for XP metrics scraping |
| XP_SCRAPE_ENDPOINT | http://localhost:2609 | Endpoint for Apache metrics scraping |
| XP_SCRAPE_TIMEOUT | 30 | Timeout for XP metrics scraping |
| HOST_SCRAPE_DISK_DEVICE | sdb | Disk to scrape for read/write data |
| HOST_SCRAPE_NETWORK_DEVICE | ens3 | Network card for io metrics |
| HOST_SCRAPE_FILESYSTEM_DEVICE | overlay | Disk device to scrape for disk usage data |
| HOST_SCRAPE_INTERVAL | 30 | Interval for XP metrics scraping |
| EC_ORG | NONE | Enonic Cloud Organization |
| EC_PROJ | NONE | Enonic Cloud Project |
| EC_INST | NONE | Enonic Cloud Instance |
| VECTOR_CONFIG_DIR | /etc/vector/* | Configuration directories |
| VECTOR_WATCH_CONFIG | /etc/vector | Directory to watch for config changes |

## Configuring Apache

To expose status endpoint for metric scraping in apache:

```
<Location "/server-status">
    SetHandler server-status
    Order deny,allow
    Deny from all
    Allow from 127.0.0.0/8
    Allow from 172.0.0.0/8
</Location>
```

## Example output data

Apache httpd logs:

```json
{
  "ip_address": "172.24.0.1",
  "method": "GET",
  "namespace": "apache",
  "path": "/server-status/?auto",
  "protocol": "HTTP/1.1",
  "size": 1180,
  "status": 200,
  "tags": {
    "host": "organization-project-instance",
    "instance": "instance",
    "organization": "organization",
    "project": "project"
  },
  "timestamp": "2022-03-09T16:56:19.459859944Z"
}
```

Enonic XP logs:

```json
{
  "class": "c.e.x.c.i.app.ApplicationServiceImpl",
  "level": "INFO",
  "message": "Searching for installed applications",
  "namespace": "xp",
  "tags": {
    "host": "organization-project-instance",
    "instance": "instance",
    "organization": "organization",
    "project": "project"
  },
  "timestamp": "2022-03-09T13:55:56.241305034Z"
}
```

Metrics:

```json
{
  "name": "cluster_elasticsearch_nodes",
  "namespace": "xp",
  "tags": {
    "collector": "cluster.elasticsearch",
    "host": "organization-project-instance",
    "instance": "instance",
    "organization": "organization",
    "project": "project"
  },
  "timestamp": "2022-03-09T16:57:39.452689635Z",
  "kind": "absolute",
  "gauge": { "value": 1.0 }
}
```

# Release

```
$ git tag -a 0.20.0-alpine-1 -m "0.20.0-alpine-1"
$ make docker-push
```