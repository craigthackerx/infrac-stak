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

#Use bash from now on
SHELL ["/bin/bash", "-c"]

#Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone

#Install & update hings
RUN apt-get update -y && apt-get -y install \ 
        apt-transport-https \
        apt-utils \
        bash \
        curl \
        dirmngr \
        git \
        ifupdown \
        locales \
        nano \
        openjdk-8-jdk \
        openssh-server \
        openssl \
        python \
        pwgen \
        software-properties-common \
        sudo \
        tmux \
        unzip \
        uuid-runtime \
        wget \
        zip

#Add Locale
RUN locale-gen $LOCALE_CODE
RUN update-locale LANG=$LOCALE_CODE

#Fix Systemctl because you forgot how to use SystemV
RUN wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /usr/local/bin/systemctl
RUN chmod a+x /usr/local/bin/systemctl

#Install ElasticSearch
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
RUN apt-get update && apt-get install -y elasticsearch
ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

#Install MongoDB
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
RUN apt-get update && apt-get install -y mongodb-org

#Install Graylog
RUN wget https://packages.graylog2.org/repo/packages/graylog-3.0-repository_latest.deb \
        && dpkg -i graylog-3.0-repository_latest.deb \
        && rm graylog*.deb
RUN apt-get update && apt-get install \
        graylog-server \
        graylog-enterprise-plugins \
        graylog-integrations-plugins \
        graylog-enterprise-integrations-plugins
#RUN pwgen -N 1 -s 96 - Run this on first install to generate your own password && echo -n Sp00kyP4SS! | sha256sum
ADD server.conf /etc/graylog/server/server.conf
RUN chmod 777 /etc/elasticsearch/elasticsearch.yml

EXPOSE 9000 27017

#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN echo 'export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"' >> $HOME/.bashrc 
RUN chmod 777 -R /usr/local
USER $NORMAL_USER

#Set entrypoint scripts
ENTRYPOINT echo $USER_PASSWORD | sudo -S service ssh start \
        && echo 'export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"' \
        && echo $USER_PASSWORD | sudo -S service elasticsearch start \
        && echo $USER_PASSWORD | sudo -S service graylog-server start \
        && echo $USER_PASSWORD | sudo -S mongod --config /etc/mongod.conf \
        && tail -f /dev/null 