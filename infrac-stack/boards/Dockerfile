#Use Ubuntu or u dum dum
FROM ubuntu:latest

#Set Enviroment Variables for personal preference below

#Set Kanboard Versions
ENV KANBOARD_VERSION 1.2.13

#Set timezone
ENV TIME_ZONE=Europe/London

#Set System Locale 
ENV LOCALE_CODE en_GB.UTF-8

#Set user for personal preference and password. These are used later on.
ENV NORMAL_USER cthacker
ENV USER_PASSWORD Sp00kyP4SS!

#Set home enviroment
ENV HOME /home/$NORMAL_USER

#Use bash from now on
SHELL ["/bin/bash", "-c"]

#Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone

#Install & update hings
RUN apt-get update -y && apt-get -y install \ 
        apt-utils \
        bash \
        curl \
        ifupdown \
        locales \
        mariadb-client \
        mariadb-server \
        nano \
        nginx \
        openssh-server \
        openssl \
        php7.2 \
        php7.2-cli \
        php7.2-common \
        php7.2-fpm \
        php7.2-gd \
        php7.2-json \
        php7.2-json \
        php7.2-ldap \
        php7.2-mbstring \
        php7.2-mysql \
        php7.2-opcache \
        php7.2-sqlite3 \
        php7.2-xml \
        php7.2-zip \
        software-properties-common \
        sudo \
        tmux \
        unzip \
        wget \
        zip

#Add Locale
RUN locale-gen $LOCALE_CODE
RUN update-locale LANG=$LOCALE_CODE

#Fix Systemctl because you forgot how to use SystemV
RUN wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /usr/local/bin/systemctl
RUN chmod a+x /usr/local/bin/systemctl

RUN service mysql start \ 
    && mysql -u root -e "CREATE DATABASE kanboard;" \
    && mysql -u root -e "CREATE USER 'kanboarduser'@'localhost' IDENTIFIED BY 'yourpassword';" \
    && mysql -u root -e "GRANT ALL PRIVILEGES ON kanboard.* TO 'kanboarduser'@'localhost' IDENTIFIED BY 'yourpassword' WITH GRANT OPTION;" \
    && mysql -u root -e "FLUSH PRIVILEGES;"

#Add Boards source code
RUN cd /var/www/html \
    && wget https://github.com/kanboard/kanboard/archive/v$KANBOARD_VERSION.zip \
    && unzip *.zip \
    && mv /var/www/html/kanboard-$KANBOARD_VERSION /var/www/html/kanboard/ \
    && chown -R www-data:www-data /var/www/html/kanboard/data \
    && rm *.zip

#Prepare php & nginx
RUN mv /var/www//html/kanboard/config.default.php /var/www/html/kanboard/config.php
ADD config.php /var/www/html/kanboard/
RUN chown -R www-data:www-data /var/www/html/kanboard
ADD kanboard.conf /etc/nginx/conf.d/
RUN service nginx start && nginx -t
EXPOSE 8080/tcp

#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN chmod 777 -R /usr/local
USER $NORMAL_USER
WORKDIR $HOME

#Add Start up service for Nginx
ENTRYPOINT echo $USER_PASSWORD | sudo -S service mysql start \
        && echo $USER_PASSWORD | sudo -S service nginx start \
        && echo $USER_PASSWORD | sudo -S service php7.2-fpm start \
        && tail -f /dev/null 