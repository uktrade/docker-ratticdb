# groventure/ratticdb-uwsgi

This repository builds the group of images for
[groventure/ratticdb-uwsgi](https://hub.docker.com/r/groventure/ratticdb-uwsgi/).

Available Tags:
+ [latest](https://github.com/groventure/docker-ratticdb-uwsgi/tree/latest)
+ [1.3](https://github.com/groventure/docker-ratticdb-uwsgi/tree/1.3)
+ [1.3.1](https://github.com/groventure/docker-ratticdb-uwsgi/tree/1.3.1)

*This image is not usable alone, and will only work with
[groventure/ratticdb-nginx](https://hub.docker.com/r/groventure/ratticdb-nginx/)
and [postgres:9.4](https://hub.docker.com/_/postgres/).*

## Usage

```shell
docker run \
  --name 'ratticdb-uwsgi' \
  --link 'ratticdb-postgresql:postgres' \
  -e 'TIMEZONE=UTC' \
  -e 'VIRTUAL_HOST=somedomain.example.com' \
  -e 'SECRETKEY=someverysecretkeyforsessions' \
  -e 'EMAIL_HOST=smtp.example.com' \
  -e 'EMAIL_PORT=587' \
  -e 'EMAIL_USER=example@example.com' \
  -e 'EMAIL_PASSWORD=someemailpassword' \
  -e 'EMAIL_FROM=emailed-from@example.com' \
  groventure/ratticdb-uwsgi:1.3
```

