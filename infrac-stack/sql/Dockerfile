#Use Ubuntu or u dum dum
FROM ubuntu:latest

#Set Enviroment Variables for personal preference below

#Set timezone
ENV TIME_ZONE=Europe/London

#Set System Locale 
ENV LOCALE_CODE en_GB.UTF-8

#Set user for personal preference and password. These are used later on.
ENV NORMAL_USER cthacker
ENV USER_PASSWORD Sp00kyP4SS!

#Set home enviroment
ENV HOME /home/$NORMAL_USER

#Database Variables
ENV DATABASE_NAME exampledb
ENV DATABASE_USER craig
ENV DATABASE_PASSWORD Sp00kyP4SS!

EXPOSE 80 3306

#Use bash from now on
SHELL ["/bin/bash", "-c"]

#Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone

#Install & update hings
RUN apt-get update -y && apt-get -y install \ 
        apache2 \
        bash \
        curl \
        git \
        ifupdown \
        libaio-dev \
        libaio1 \
        locales \
        mariadb-client \
        mariadb-server \
        nano \
        openjdk-8-jdk \
        openssh-server \
        openssl \
        python \
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

#Install php
RUN export DEBIAN_FRONTEND=noninteractive \ 
        && apt-get install -y php-mbstring php-gettext \
        && apt install -y phpmyadmin

#Create Databases
RUN service mysql start \ 
    && mysql -u root -e "SET GLOBAL innodb_large_prefix=ON;" \
    && mysql -u root -e "SET GLOBAL innodb_file_format=Barracuda;" \
    && mysql -u root -e "SET GLOBAL innodb_file_per_table=ON;" \
    && mysql -u root -e "SET GLOBAL innodb_default_row_format=dynamic" \
    && mysql -u root -e "CREATE DATABASE ${DATABASE_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;" \
    && mysql -u root -e "CREATE USER '${DATABASE_USER}'@'localhost' IDENTIFIED BY '${DATABASE_PASSWORD}';" \
    && mysql -u root -e "GRANT ALL PRIVILEGES ON ${DATABASE_USER}.* TO '${DATABASE_USER}'@'localhost' IDENTIFIED BY '${DATABASE_PASSWORD}' WITH GRANT OPTION;" \
    && mysql -u root -e "FLUSH PRIVILEGES;"

#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN chmod 777 -R /usr/local
USER $NORMAL_USER

#Set entrypoint scripts
ENTRYPOINT echo $USER_PASSWORD | sudo -S service mysql start \
        && echo $USER_PASSWORD | sudo -S service ssh start \
        && tail -f /dev/null 