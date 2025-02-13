# PowerDNS Docker Images
Modified 
This repository contains four Docker images - pdns-mysql, pdns-recursor, pdns-admin-static and pdns-admin-uwsgi. Image **pdns-mysql** contains completely configurable [PowerDNS 4.x server](https://www.powerdns.com/) with mysql backend (without mysql server). Image **pdns-recursor** contains completely configurable [PowerDNS 4.x recursor](https://www.powerdns.com/). Images **pdns-admin-static** and **pdns-admin-uwsgi** contains fronted (nginx) and backend (uWSGI) for [PowerDNS Admin](https://github.com/PowerDNS-Admin/PowerDNS-Admin) web app, written in Flask, for managing PowerDNS servers.

The pdns-mysql and pdns-recursor images have also the `alpine` tag thanks to the @PoppyPop .

All images are available on Docker Hub:

https://hub.docker.com/r/petrhung9/pdns-mysql/

https://hub.docker.com/r/petrhung9/pdns-recursor/

https://hub.docker.com/r/petrhung9/pdns-admin-uwsgi/

https://hub.docker.com/r/petrhung9/pdns-admin-static/

## pdns-mysql

![Docker Image Size (tag)](https://img.shields.io/docker/image-size/petrhung9/pdns-mysql/latest?label=latest) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/petrhung9/pdns-mysql/alpine?label=alpine) ![Docker Pulls](https://img.shields.io/docker/pulls/petrhung9/pdns-mysql)

https://hub.docker.com/r/petrhung9/pdns-mysql/

Docker image with [PowerDNS 4.x server](https://www.powerdns.com/) and mysql backend (without mysql server). For running, it needs external mysql server. Env vars for mysql configuration:
```
(name=default value)

PDNS_gmysql_host=mysql
PDNS_gmysql_port=3306
PDNS_gmysql_user=root
PDNS_gmysql_password=powerdns
PDNS_gmysql_dbname=powerdns
```
If linked with official [mariadb](https://hub.docker.com/_/mariadb/) image with alias `mysql`, the connection can be automatically configured, so you don't need to specify any of the above. Also, DB is automatically initialized if tables are missing.

PowerDNS server is configurable via env vars. Every variable starting with `PDNS_` will be inserted into `/etc/pdns/pdns.conf` conf file in the following way: prefix `PDNS_` will be stripped and every `_` will be replaced with `-`. For example, from above mysql config, `PDNS_gmysql_host=mysql` will became `gmysql-host=mysql` in `/etc/pdns/pdns.conf` file. This way, you can configure PowerDNS server any way you need within a `docker run` command.

There is also a `SUPERMASTER_IPS` env var supported, which can be used to configure supermasters for slave dns server. [Docs](https://doc.powerdns.com/md/authoritative/modes-of-operation/#supermaster-automatic-provisioning-of-slaves). Multiple ip addresses separated by space should work.

You can find [here](https://doc.powerdns.com/md/authoritative/) all available settings.

### Examples

Master server with API enabled and with one slave server configured:
```
docker run -d -p 53:53 -p 53:53/udp --name pdns-master \
  --hostname ns1.example.com --link mariadb:mysql \
  -e PDNS_master=yes \
  -e PDNS_api=yes \
  -e PDNS_api_key=secret \
  -e PDNS_webserver=yes \
  -e PDNS_webserver_address=0.0.0.0 \
  -e PDNS_webserver_password=secret2 \
  -e PDNS_version_string=anonymous \
  -e PDNS_default_ttl=1500 \
  -e PDNS_allow_axfr_ips=172.5.0.21 \
  -e PDNS_only_notify=172.5.0.21 \
  petrhung9/pdns-mysql
```

Slave server with supermaster:
```
docker run -d -p 53:53 -p 53:53/udp --name pdns-slave \
  --hostname ns2.example.com --link mariadb:mysql \
  -e PDNS_gmysql_dbname=powerdnsslave \
  -e PDNS_slave=yes \
  -e PDNS_version_string=anonymous \
  -e PDNS_disable_axfr=yes \
  -e PDNS_allow_notify_from=172.5.0.20 \
  -e SUPERMASTER_IPS=172.5.0.20 \
  petrhung9/pdns-mysql
```

## pdns-recursor

![Docker Image Size (tag)](https://img.shields.io/docker/image-size/petrhung9/pdns-recursor/latest?label=latest) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/petrhung9/pdns-recursor/alpine?label=alpine) ![Docker Pulls](https://img.shields.io/docker/pulls/petrhung9/pdns-recursor)

https://hub.docker.com/r/petrhung9/pdns-recursor/

Docker image with [PowerDNS 4.x recursor](https://www.powerdns.com/).

PowerDNS recursor is configurable via env vars. Every variable starting with `PDNS_` will be inserted into `/etc/pdns/recursor.conf` conf file in the following way: prefix `PDNS_` will be stripped and every `_` will be replaced with `-`. For example, from above mysql config, `PDNS_gmysql_host=mysql` will became `gmysql-host=mysql` in `/etc/pdns/recursor.conf` file. This way, you can configure PowerDNS recursor any way you need within a `docker run` command.

You can find [here](https://doc.powerdns.com/md/recursor/settings/) all available settings.

### Examples

Recursor server with API enabled:
```
docker run -d -p 53:53 -p 53:53/udp --name pdns-recursor \
  -e PDNS_api_key=secret \
  -e PDNS_webserver=yes \
  -e PDNS_webserver_address=0.0.0.0 \
  -e PDNS_webserver_password=secret2 \
  petrhung9/pdns-recursor
```

## pdns-admin-uwsgi

![Docker Image Size (tag)](https://img.shields.io/docker/image-size/petrhung9/pdns-admin-uwsgi/latest?label=latest) ![Docker Pulls](https://img.shields.io/docker/pulls/petrhung9/pdns-admin-uwsgi)

https://hub.docker.com/r/petrhung9/pdns-admin-uwsgi/

Docker image with backend of [PowerDNS Admin](https://github.com/PowerDNS-Admin/PowerDNS-Admin) web app, written in Flask, for managing PowerDNS servers. This image contains the python part of the app running under uWSGI. It needs external mysql server. Env vars for mysql configuration:
```
(name=default value)

PDNS_ADMIN_SQLA_DB_HOST="mysql"
PDNS_ADMIN_SQLA_DB_PORT="3306"
PDNS_ADMIN_SQLA_DB_USER="root"
PDNS_ADMIN_SQLA_DB_PASSWORD="powerdnsadmin"
PDNS_ADMIN_SQLA_DB_NAME="powerdnsadmin"
```
If linked with official [mariadb](https://hub.docker.com/_/mariadb/) image with alias `mysql`, the connection can be automatically configured, so you don't need to specify any of the above. Also, DB is automatically initialized if tables are missing.

Similar to the pdns-mysql, pdns-admin is also completely configurable via env vars. Prefix in this case is `PDNS_ADMIN_`, configuration will be written to the `/opt/powerdns-admin/config.py` file.

### Connecting to the PowerDNS server

For the pdns-admin to make sense, it needs a PowerDNS server to manage. The PowerDNS server needs to have exposed API (example configuration for PowerDNS 4.x):
```
api=yes
api-key=secret
webserver=yes
webserver-address=0.0.0.0
webserver-allow-from=172.5.0.0/16
```

And again, PowerDNS connection is configured via env vars (it needs url of the PowerDNS server, api key and a version of PowerDNS server, for example 4.0):
```
(name=default value)

PDNS_API_URL="http://pdns:8081/"
PDNS_API_KEY=""
PDNS_VERSION=""
```

If this container is linked with pdns-mysql from this repo with alias `pdns`, it will be configured automatically and none of the env vars from above are needed to be specified.

### PowerDNS Admin API keys and SALT

In order to be able to generate an API Key, you will need to specify the SALT via `PDNS_ADMIN_SALT` env var. This is a secret value, which can be generated via command:
```
python3 -c 'import bcrypt; print(bcrypt.gensalt().decode("utf-8"));'
```
Example value looks like `$2b$12$xxxxxxxxxxxxxxxxxxxxxx` - remember that when using docker-compose, literal `$` must be specified as `$$`.

### Persistent data

There is a directory with user uploads which should be persistent: `/opt/powerdns-admin/upload`

### Example

When linked with pdns-mysql from this repo and with LDAP auth:
```
docker run -d --name pdns-admin-uwsgi \
  --link mariadb:mysql --link pdns-master:pdns \
  -v pdns-admin-upload:/opt/powerdns-admin/upload \
  petrhung9/pdns-admin-uwsgi
```

## pdns-admin-static

![Docker Image Size (tag)](https://img.shields.io/docker/image-size/petrhung9/pdns-admin-static/latest?label=latest) ![Docker Pulls](https://img.shields.io/docker/pulls/petrhung9/pdns-admin-static)

https://hub.docker.com/r/petrhung9/pdns-admin-static/

Fronted image with nginx and static files for [PowerDNS Admin](https://github.com/PowerDNS-Admin/PowerDNS-Admin). Exposes port 80 for connections, expects uWSGI backend image under `pdns-admin-uwsgi` alias.

### Example

```
docker run -d -p 8080:80 --name pdns-admin-static \
  --link pdns-admin-uwsgi:pdns-admin-uwsgi \
  petrhung9/pdns-admin-static
```

## ansible-playbook.yml

Included ansible playbook can be used to build and run the containers from this repo. Run it with:
```
ansible-playbook ansible-playbook.yml
```
