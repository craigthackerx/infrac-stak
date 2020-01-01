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

#Ports
EXPOSE 80 443 9999

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
        mariadb-client\
        mariadb-server \
        nano \
        openjdk-8-jdk \
        openssh-server \
        openssl \
        php7.2 \
        php7.2-mysql \
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

#Install Apache GUI - go to http://docker-ip:9999/ApacheGUI
RUN mkdir /usr/local/apachegui
RUN cd /usr/local/apachegui \
        && wget https://excellmedia.dl.sourceforge.net/project/apachegui/1.12-Linux-Solaris-Mac/ApacheGUI-1.12.0.tar.gz \
        && tar -xvzf ApacheGUI-1.12.0.tar.gz \
        && rm *.tar.gz
ADD run.sh /usr/local/apachegui/ApacheGUI/bin/run.sh

#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN echo 'export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"' >> $HOME/.bashrc 
RUN chmod 777 -R /usr/local

ENTRYPOINT echo $USER_PASSWORD | sudo -S service apache2 start \
        && echo $USER_PASSWORD | sudo -S service ssh start \
        && /usr/local/apachegui/ApacheGUI/bin/run.sh \
        && tail -f /dev/null 

#Change back to normal user 
USER ${NORMAL_USER}
WORKDIR ${HOME}