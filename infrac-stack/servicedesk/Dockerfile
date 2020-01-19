#Use Ubuntu or u dum dum
FROM craigtho/ubuntu:latest

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
ENV DATABASE_NAME osticket
ENV DATABASE_USER osticketuser
ENV DATABASE_PASSWORD Sp00kyP4SS!

EXPOSE 80 443 3306 25 389

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
        libapache2-mod-php7.2 \
        locales \
        mariadb-client \
        mariadb-server \
        nano \
        openjdk-8-jdk \
        openssh-server \
        openssl \
        php7.2 \
        php7.2-apcu \
        php7.2-bcmath \
        php7.2-cli \
        php7.2-common \
        php7.2-curl \
        php7.2-gd \
        php7.2-gmp \
        php7.2-imap \
        php7.2-intl \
        php7.2-ldap \
        php7.2-mbstring \
        php7.2-mysql \
        php7.2-soap \
        php7.2-xml \
        php7.2-xmlrpc \
        php7.2-zip\
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

RUN service mysql start \ 
    && mysql -u root -e "SET GLOBAL innodb_large_prefix=ON;" \
    && mysql -u root -e "SET GLOBAL innodb_file_format=Barracuda;" \
    && mysql -u root -e "SET GLOBAL innodb_file_per_table=ON;" \
    && mysql -u root -e "SET GLOBAL innodb_default_row_format=dynamic" \
    && mysql -u root -e "CREATE DATABASE ${DATABASE_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;" \
    && mysql -u root -e "CREATE USER '${DATABASE_USER}'@'localhost' IDENTIFIED BY '${DATABASE_PASSWORD}';" \
    && mysql -u root -e "GRANT ALL PRIVILEGES ON ${DATABASE_NAME}.* TO '${DATABASE_USER}'@'localhost' IDENTIFIED BY '${DATABASE_PASSWORD}' WITH GRANT OPTION;" \
    && mysql -u root -e "GRANT ALL PRIVILEGES ON ${DATABASE_NAME}.* TO '${DATABASE_USER}'@'%' IDENTIFIED BY '${DATABASE_PASSWORD}' WITH GRANT OPTION;" \
    && mysql -u root -e "FLUSH PRIVILEGES;"

#Install OSTicket
RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
RUN cd /var/www && git clone https://github.com/osTicket/osTicket osticket \
        && cd /var/www/osticket \
        && php manage.php deploy --setup /var/www/osticket/

RUN mv /var/www/osticket/include/ost-sampleconfig.php /var/www/osticket/include/ost-config.php

#Set privleges 
RUN chown -R www-data:www-data /var/www/osticket/
RUN chmod -R 755 /var/www/osticket/

#Setup Apache2
ADD osticket.conf /etc/apache2/sites-available/osticket.conf
RUN a2ensite osticket.conf
RUN a2enmod rewrite
ADD apache2.conf /etc/apache2/apache2.conf
ADD 000-default.conf /etc/apache2/sites-available
RUN echo '172.17.0.2    servicedesk.example.com' > /etc/hosts

#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN chmod 777 -R /usr/local
RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64' >> $HOME/.bashrc
RUN echo 'export APACHE_LOG_DIR=/var/logs' >> $HOME/.bashrc
USER ${NORMAL_USER}

ENTRYPOINT echo $USER_PASSWORD | sudo -S service mysql start \
        && echo $USER_PASSWORD | sudo -S service apache2 start \
        && echo $USER_PASSWORD | sudo -S service ssh start \
        && tail -f /dev/null 