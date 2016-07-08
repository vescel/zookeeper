#!/bin/bash

if [[ -z ${CONSUL} ]]; then
  fatal "Missing CONSUL environment variable"
  exit 1
fi

generateConfig() {
  debug "Generating config"

  if [ ! -z "$DEBUG" ]; then
    log_level="-log-level debug"
  fi

  confd -onetime -backend env ${log_level}

  debug "----------------- Configuration -----------------"
  debug $(cat /etc/logstash/**.*)
  debug "-----------------------------------------------------"
}

onStart() {
  generateConfig
}

reload() {
  current_config=$(cat /etc/logstash/**.*)

  generateConfig

  new_config=$(cat /etc/logstash/**.*)

  if [ "$current_config" != "$new_config" ]; then
    info "******* Rebooting Logstash *******"
    if [ -f /opt/logstash/pid ]; then
      kill -SIGTERM $(cat /opt/logstash/pid)
    fi
  else
    debug "Configs are identical. No need to reload."
  fi
}

health() {
  nc -z localhost ${SYSLOG_PORT}
}

start() {
  info "Boostrapping..."

  # Logstash doesn't have a hot-reload mechanism until 2.3 comes out.
  # This hackery allows us to restart logstash without killing the container.
  # The `/bin/manage.sh reload` function will kill logstash if it detects new configuration.
  while true; do

    # check if logstash is already running
    pid=$(test -f /opt/logstash/pid && test -d /proc/$(cat /opt/logstash/pid) && cat /opt/logstash/pid)

    # If it's not running then start it
    if [ -z "$pid" ]; then

      info "******* Starting Logstash *******"

      su logstash -m -c "/opt/logstash/bin/logstash -f /etc/logstash" &
      echo $! > /opt/logstash/pid

      debug "PID: $(cat /opt/logstash/pid)"

      exitcode=$?
      if [ $exitcode -gt 0 ]; then
        exit $exitcode
      fi
    fi

    sleep 1s
  done
}

debug() {
  if [ ! -z "$DEBUG" ]; then
    echo "=======> DEBUG: $@"
  fi
}

info() {
  echo "=======> INFO: $@"
}

fatal() {
  echo "=======> FATAL: $@"
}

# do whatever the arg is
$1