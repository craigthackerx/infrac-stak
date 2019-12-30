#Credit to https://github.com/piersonjarvis/webmin-samba-docker for the inspiration to this container.
#Use Ubuntu
FROM ubuntu:latest

#Set Enviroment Variables for personal preference below
EXPOSE 80 443 139 445

#Set timezone
ENV TIME_ZONE=Europe/London

#Set home enviroment
ENV HOME /home/$NORMAL_USER

#Set System Locale 
ENV LOCALE_CODE en_GB.UTF-8

#Set user for personal preference and password. These are used later on.
ENV NORMAL_USER cthacker
ENV USER_PASSWORD Sp00kyP4SS!

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
        apt-transport-https \
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
        samba \
        samba-common \
        software-properties-common \
        sudo \
        tmux \
        unzip \
        wget \
        zip

#Make folder structure for webmin
RUN mkdir /media/storage /data /data/samba /data/webmin

#Add Volume for storage
VOLUME /data

#Add Locale
RUN locale-gen $LOCALE_CODE
RUN update-locale LANG=$LOCALE_CODE

#Fix Systemctl because you forgot how to use SystemV
RUN wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /usr/local/bin/systemctl
RUN chmod a+x /usr/local/bin/systemctl

#Add Webmin source
RUN echo "deb https://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list && \
cd /root && \
wget http://www.webmin.com/jcameron-key.asc && \
apt-key add jcameron-key.asc 

#Fix for Webmin install
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes && \
apt-get purge apt-show-versions -y && \
rm /var/lib/apt/lists/*lz4 && \
apt-get -o Acquire::GzipIndexes=false update -y

#Install Webmins
RUN apt-get update && apt-get install webmin -y

#Edit the miniserv.conf
RUN sed -i 's/10000/80/g' /etc/webmin/miniserv.conf && \
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf 

#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN echo root:$USER_PASSWORD | chpasswd
RUN chmod 777 -R /usr/local

#Execute with sudo password to prevent root escalation
ENTRYPOINT echo "$USER_PASSWORD" | sudo -S service ssh start \ 
    && echo "$USER_PASSWORD" | sudo -S service webmin start \
    && echo "$USER_PASSWORD" | sudo -S service smbd start \
    && echo "$USER_PASSWORD" | sudo -S service nmbd start \
    && bash

#Change back to normal user
USER $NORMAL_USER
WORKDIR $HOME/$NORMAL_USER