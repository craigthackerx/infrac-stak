#Use Ubuntu or u dum dum
FROM ubuntu:latest

#Set Enviroment Variables for personal preference below

EXPOSE 80 27017 8080 8081

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

#Set Node paths
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.16.0
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

#Set Gradle Version
ENV GRADLE_VERSION gradle 4.8.1

#Use bash from now on
SHELL ["/bin/bash", "-c"]

#Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone

#Install & update hings
RUN apt-get update -y && apt-get -y install \ 
  apt-utils \
#    apache2 \
    bash \
    curl \
    ifupdown \
    locales \
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
    && mysql -u root -e "CREATE DATABASE kanboard CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" \
    && mysql -u root -e "GRANT ALL PRIVILEGES ON kanboard.* TO 'kanboard'@'localhost' IDENTIFIED BY 'mypassword';" \
    && mysql -u root -e "FLUSH PRIVILEGES;"

RUN cd /var/www/html \
    && wget https://github.com/kanboard/kanboard/archive/v$KANBOARD_VERSION.zip \
    && unzip *.zip \
    && mv /var/www/html/kanboard-$KANBOARD_VERSION /var/www/html/kanboard/ \
    && chown -R www-data:www-data /var/www/html/kanboard/data \
    && rm *.zip

RUN mv /var/www//html/kanboard/config.default.php /var/www/html/kanboard/config.php
ADD config.php /var/www/html/kanboard/
RUN chown -R www-data:www-data /var/www/html/kanboard
ADD kanboard.conf /etc/nginx/conf.d/
RUN service nginx start && nginx -t

#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN chmod 777 -R /usr/local
USER $NORMAL_USER
WORKDIR $HOME

#ENTRYPOINT echo $USER_PASSWORD | sudo -S service mysql start \
        #&& echo $USER_PASSWORD | sudo -S service apache2 start \
        #&& echo $USER_PASSWORD | sudo -S service php7.2-fpm start \
        #&& tail -f /dev/null 