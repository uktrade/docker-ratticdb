set -e

if [[ -z "$POSTGRES_PORT_5432_TCP_ADDR" ]]; then
  echo '$POSTGRES_PORT_5432_TCP_ADDR not defined. Aborting...' >&2
  exit 1
fi

if [[ -z "$POSTGRES_PORT_5432_TCP_PORT" ]]; then
  echo '$POSTGRES_PORT_5432_TCP_PORT not defined. Aborting...' >&2
  exit 1
fi

if [[ -z "$POSTGRES_ENV_POSTGRES_USER" ]]; then
  echo '$POSTGRES_ENV_POSTGRES_USER not defined. Aborting...' >&2
  exit 1
fi

if [[ -z "$POSTGRES_ENV_POSTGRES_PASSWORD" ]]; then
  echo '$POSTGRES_ENV_POSTGRES_PASSWORD not defined. Aborting...' >&2
  exit 1
fi

database_host="$POSTGRES_PORT_5432_TCP_ADDR"
database_port="$POSTGRES_PORT_5432_TCP_PORT"
database_user="$POSTGRES_ENV_POSTGRES_USER"
database_password="$POSTGRES_ENV_POSTGRES_PASSWORD"

if [[ -z "$VIRTUAL_HOST" ]]; then
  hostname='localhost'
else
  hostname="$VIRTUAL_HOST"
fi

if [[ -z "$TIMEZONE" ]]; then
  timezone='UTC'
else
  timezone="$TIMEZONE"
fi

python='/usr/bin/python2.7'
uwsgi='/usr/local/bin/uwsgi'
localconf_tmpl_path='/usr/local/etc/rattic/local.tmpl.cfg'
localconf_path='/srv/rattic/conf/local.cfg'

install -Zm 0600 "$localconf_tmpl_path" "$localconf_path"
sed -ir \
  's/{{\s*timezone\s*}}/'"$(echo $timezone | sed -r 's/\//\\\//g')"'/g' \
  "$localconf_path"

sed -ir \
  's/{{\s*secretkey\s*}}/k6tc4Lg3XmEftMtabEE3Gf3q4TscrprfeR7iY7ZxJpk3q4HXwsTesm8gNAzUUmHsSdGqkJa8rzkNWncjA7h9ifs49cgygjvLK4h4mFTNxjGnxG3Ry7NeE7DBdpuNj4RNb9gCksCa3JKKnKk83SjFrgTeB5YS2WXxGHxbhVb666ZEA5eCmiS7kE2DhU5ivH2Fsyo2bcFNdeSZDyNWhD5qyKdonymWz4AyjGXjX6i3No9wUrJ87B3LbK4yrPViLq8Y/g' \
  "$localconf_path"

sed -ir \
  's/{{\s*hostname\s*}}/'"$hostname"'/g' \
  "$localconf_path"

sed -ir \
  's/{{\s*database_host\s*}}/'"$database_host"'/g' \
  "$localconf_path"

sed -ir \
  's/{{\s*database_port\s*}}/'"$database_port"'/g' \
  "$localconf_path"

sed -ir \
  's/{{\s*database_name\s*}}/postgres/g' \
  "$localconf_path"

sed -ir \
  's/{{\s*database_user\s*}}/'"$database_user"'/g' \
  "$localconf_path"

sed -ir \
  's/{{\s*database_password\s*}}/'"$database_password"'/g' \
  "$localconf_path"

rm -f "${localconf_path}r"

$python manage.py syncdb --noinput
$python manage.py migrate --all

if [[ "$1" == 'init' ]]; then
  sleep 10
  $python manage.py demosetup
fi

$python manage.py collectstatic --noinput
$python manage.py compilemessages

if [[ "$1" != 'init' ]]; then
  exec $uwsgi --ini '/usr/local/etc/rattic/uwsgi.ini'
fi

set +e
