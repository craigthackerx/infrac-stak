#Use Ubuntu or u dum dum
FROM ubuntu:latest

#Set Enviroment Variables for personal preference below
ARG DEBIAN_FRONTEND=noninteractive

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
        bash \
        curl \
        git \
        ifupdown \
        locales \
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

RUN apt-get -q -y update \
        && apt-get -q -y -o "DPkg::Options::=--force-confold" -o "DPkg::Options::=--force-confdef" install apt-utils \
        && rm /etc/dpkg/dpkg.cfg.d/excludes \
        && apt-get -q -y -o "DPkg::Options::=--force-confold" -o "DPkg::Options::=--force-confdef" install dumb-init isc-dhcp-server man \
        && apt-get -q -y autoremove \
        && apt-get -q -y clean \
        && rm -rf /var/lib/apt/lists/* \
        && mkdir /data \
        && chmod 777 -R /data
ADD dhcpd.conf /data/dhcpd.conf

#Add Locale
RUN locale-gen $LOCALE_CODE
RUN update-locale LANG=$LOCALE_CODE

#Fix Systemctl in Docker container
RUN wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /usr/local/bin/systemctl
RUN chmod a+x /usr/local/bin/systemctl

#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN chmod 777 -R /usr/local
COPY entrypoint.sh $HOME/entrypoint.sh
RUN chmod a+x ${HOME}/entrypoint.sh
USER $NORMAL_USER

#Set entrypoint scripts
ENTRYPOINT echo $USER_PASSWORD | sudo -S service ssh start \
#           && echo $USER_PASSWORD | sudo -S sh $HOME/entrypoint.sh \  Subnet conifugration needs to be set before this script will work
           && tail -f /dev/null 