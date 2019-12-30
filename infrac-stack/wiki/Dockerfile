#Use Ubuntu or u dum dum
FROM ubuntu:latest

#Set Enviroment Variables for personal preference below

#Set timezone
ENV TIME_ZONE=Europe/London

EXPOSE 80 443

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
        apache2 \
        bash \
        curl \
        git \
        ifupdown \
        libapache2-mod-php7.2 \
        locales \
        nano \
        openssh-server \
        openssl \
        php7.2 \
        php7.2-cli \
        php7.2-common \
        php7.2-curl \
        php7.2-gd \
        php7.2-intl \
        php7.2-json \
        php7.2-mbstring \
        php7.2-soap \
        php7.2-sqlite3 \
        php7.2-tidy \
        php7.2-xml \
        php7.2-xmlrpc \
        php7.2-zip \
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

#Install docuwiki
ADD php.ini /etc/php/7.2/apache2/php.ini
RUN cd /var/www/html/ \
    && git clone --branch stable https://github.com/splitbrain/dokuwiki.git \
    && chown -R www-data:www-data /var/www/html/dokuwiki/ \
    && chmod -R 755 /var/www/html/dokuwiki/
ADD dokuwiki.conf /etc/apache2/sites-available/dokuwiki.conf
RUN cd /etc/apache2/sites-available \
    && a2ensite dokuwiki.conf \
    && a2enmod rewrite

#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN chmod 777 -R /usr/local
USER $NORMAL_USER
WORKDIR ${HOME}

#Go to http://container-ip/dokuwiki/install.php to access Apache
ENTRYPOINT echo $USER_PASSWORD | sudo -S service ssh start \
        && echo $USER_PASSWORD | sudo -S service apache2 start \
        && tail -f /dev/null