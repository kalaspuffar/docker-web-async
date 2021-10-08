#!/bin/bash

export $(grep -v '^#' /container.env | xargs -d '\n')
sudo -E -u www-data php /var/www/bin/background.php 2>&1 > /tmp/cron.log

