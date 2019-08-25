#!/bin/bash
# 2019-07-15 - Reinstall syslog configuration, test-swarm
# curl -sSL https://gitlab.com/NetChris/public/linux/raw/master/scripts/20190715-syslog-test.sh | bash -s

sudo rm -f /etc/rsyslog.d/60-*.conf
sudo rm -f /etc/rsyslog.d/70-*.conf
sudo curl -sSL \
  https://gitlab.com/NetChris/public/linux/raw/master/Ubuntu/etc/rsyslog.d/70-syslog.test.loc.network.conf \
  -o /etc/rsyslog.d/70-syslog.test.loc.network.conf
sudo service rsyslog restart
logger Testing 123 from $HOSTNAME
