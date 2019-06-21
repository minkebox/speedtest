#!/usr/bin/env bash
echo "Starting run.sh"

cat /var/www/html/config/crontab.default > /var/www/html/config/crontab

if [ ! -f /var/www/html/data/result.csv ]; then
    echo "timestamp,ping,download,upload" > /var/www/html/data/result.csv
    echo "0,0,0,0" >> /var/www/html/data/result.csv
fi


if [[ ${CRONJOB_ITERATION} && ${CRONJOB_ITERATION-x} ]]; then
    sed -i -e "s/0/${CRONJOB_ITERATION}/g" /var/www/html/config/crontab
fi
crontab /var/www/html/config/crontab

echo "Run immediately"
/var/www/html/scripts/speedtest.js &

if [ "${CRONJOB_RUN}" != "false" ]; then
    echo "Starting Cronjob"
    crond -l 2 -f &
fi

echo "Starting nginx"
exec nginx -g "daemon off;"

exit 0;
