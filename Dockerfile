FROM php:7.4-apache
ENV DEBIAN_FRONTEND=noninteractive
ARG WORKDIR

RUN a2enmod rewrite

RUN echo 'deb http://deb.debian.org/debian bullseye main' > /etc/apt/sources.list
RUN echo 'deb-src http://deb.debian.org/debian bullseye main' >> /etc/apt/sources.list

RUN echo 'deb http://deb.debian.org/debian-security/ bullseye-security main' >> /etc/apt/sources.list
RUN echo 'deb-src http://deb.debian.org/debian-security/ bullseye-security main' >> /etc/apt/sources.list

RUN echo 'deb http://deb.debian.org/debian bullseye-updates main' >> /etc/apt/sources.list
RUN echo 'deb-src http://deb.debian.org/debian bullseye-updates main' >> /etc/apt/sources.list

RUN apt -y update
RUN apt -y upgrade
RUN apt -y dist-upgrade
RUN apt -y autoremove

RUN apt -y install wget gnupg software-properties-common ca-certificates lsb-release apt-transport-https
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

RUN apt -y update

RUN rm /etc/apt/preferences.d/no-debian-php

RUN apt -y install php7.4 unzip cron tzdata sudo

RUN cp /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
RUN echo "Europe/Stockholm" > /etc/timezone
RUN rm -rf /var/cache/apk/*

ENV WORKDIR=$WORKDIR

COPY docker_cron /etc/cron.d/docker_cron
RUN chmod 0644 /etc/cron.d/docker_cron
RUN crontab /etc/cron.d/docker_cron

COPY cron_job.sh /root/cron_job.sh
RUN chmod +x /root/cron_job.sh

COPY prepare_env.sh /root/prepare_env.sh
RUN chmod +x /root/prepare_env.sh

RUN sed -i 's/^exec /\n\n\/root\/prepare_env.sh\n\nservice cron start\n\nexec /' /usr/local/bin/apache2-foreground

#RUN cat /container.env

COPY bin/ /var/www/bin/
COPY include/ /var/www/include/
COPY src/ /var/www/html/
