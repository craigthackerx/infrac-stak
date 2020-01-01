#Use Ubuntu
FROM ubuntu:latest

#Set Enviroment Timezone
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Setup Normal User
ENV NORMAL_USER cthacker
ENV USER_PASSWORD Sp00kyP4SS!
ENV HOME /home/${NORMAL_USER}

#Use Bash
SHELL ["/bin/bash", "-c"]

#Update and install things
RUN apt-get update -y && apt-get -y install \
        apache2 \
        bash \
        build-essential \
        curl \
        fonts-liberation \
        git \
        gnupg \
        ifupdown \
        libapache2-mod-php \
        libappindicator3-1 \
        libgd-dev \
        libgtk-3-0 \
        libssl-dev \
        libxss1 \
        locales \
        lsb-release \
        nagios-plugins \
        nano \
        openssh-server \
        openssl \
        perl \
        php \
        php-gd \
        python \
        software-properties-common \
        sudo \
        tmux \
        unzip \
        vim \
        wget \
        xdg-utils \
        zip

#Clean the update cache
RUN apt-get autoclean

#Generate Locales
RUN locale-gen en_GB.UTF-8
RUN update-locale LANG=en_GB.UTF-8

#Fix Systemctl in Docker container
RUN wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /usr/local/bin/systemctl
RUN chmod a+x /usr/local/bin/systemctl

#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash nagios 
RUN usermod -aG sudo nagios
RUN groupadd nagcmd
RUN usermod -aG nagcmd nagios
RUN usermod -aG nagcmd www-data
RUN echo nagios:Sp00kyP4ss | chpasswd
RUN chmod 777 /usr/local
RUN chmod 777 /home/nagios
RUN export DISPLAY=localhost:0
RUN export NO_AT_BRIDGE=1
RUN exec dbus-run-session -- bash

#Install Nagios
WORKDIR /opt
RUN wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.5.tar.gz
RUN tar xzf nagios-4.4.5.tar.gz
RUN rm nagios-4.4.5.tar.gz
WORKDIR /opt/nagios-4.4.5
RUN ./configure --with-command-group=nagcmd
RUN make all
RUN make install
RUN make install-init
RUN make install-daemoninit
RUN make install-config
RUN make install-commandmode
RUN make install-exfoliation
RUN cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
RUN chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
ADD nagios.conf /etc/apache2/conf-available/nagios.conf

#Make Nagios admin account & prepare apache
RUN htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin $USER_PASSWORD
RUN a2enconf nagios
RUN a2enmod cgi rewrite

#Add Scipts & Config
RUN chmod 777 -R /usr/local/nagios

#Add a standard user for later and open permissions to the needed directories, you're not important enough to use root 
RUN useradd -m -s /bin/bash $NORMAL_USER 
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN chmod 777 /usr/local
RUN chmod 777 -R $HOME
USER $NORMAL_USER 


#Expose Ports
EXPOSE 80/tcp
EXPOSE 5666/tcp
EXPOSE 12489/tcp
WORKDIR /usr/local/nagios

ENTRYPOINT echo $USER_PASSWORD | sudo -S service apache2 start \
        && echo $USER_PASSWORD | sudo -S service nagios start \
        && echo $USER_PASSWORD | sudo -S service ssh start \
        && tail -f /dev/null 