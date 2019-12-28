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

#Set Node paths
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.16.0
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

#Set Gradle Version
ENV GRADLE_VERSION gradle 4.8.1

ENV GOGS_CUSTOM /data/gogs

ADD https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 /usr/sbin/gosu


#Use bash from now on
SHELL ["/bin/bash", "-c"]

#Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone

#Install & update hings
RUN apt-get update -y && apt-get -y install \ 
    sudo \
    ca-certificates \
    tzdata \
    rsync \
    bash \
    nano \
    openjdk-8-jdk \ 
    curl \
    nginx \ 
    mariadb-server \
    mariadb-client \
    software-properties-common \
    python \
    wget \
    git \
    locales \
    ifupdown \
    openssl \ 
    openssh-server \ 
    tmux \
    unzip \
    zip

#Add Locale
RUN locale-gen $LOCALE_CODE
RUN update-locale LANG=$LOCALE_CODE

#Fix Systemctl because you forgot how to use SystemV
RUN wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /usr/local/bin/systemctl
RUN chmod a+x /usr/local/bin/systemctl

#Create Databases
RUN service mysql start \ 
    && mysql -u root -e "CREATE DATABASE gitea CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" \
    && mysql -u root -e "CREATE USER 'giteauser'@'localhost' IDENTIFIED BY 'yourpassword';" \
    && mysql -u root -e "GRANT ALL PRIVILEGES ON gitea.* TO 'giteauser'@'localhost' IDENTIFIED BY 'yourpassword' WITH GRANT OPTION;" \
    && mysql -u root -e "FLUSH PRIVILEGES;"

#Make git users
RUN adduser \
   --system \
   --shell /bin/bash \
   --gecos 'Git Version Control' \
   --group \
   --disabled-password \
   --home /home/git \
   git

#Make git directories
RUN mkdir -p /var/lib/gitea/{custom,data,indexers,public,log} \
&& chown git:git /var/lib/gitea/{data,indexers,log} \
&& chmod 750 /var/lib/gitea/{data,indexers,log} \
&& mkdir /etc/gitea \
&& chown root:git /etc/gitea \
&& chmod 770 /etc/gitea

#Download gitea
RUN wget -O gitea https://dl.gitea.io/gitea/1.5.0/gitea-1.5.0-linux-amd64 \
    && chmod +x gitea \
    && cp gitea /usr/local/bin/gitea \
    && rm gitea* 

#Add gitea systemctl service
ADD gitea.service /etc/systemd/system/gitea.service

#Make reverse proxy
RUN rm /etc/nginx/sites-enabled/default
ADD git /etc/nginx/sites-available/git
RUN sudo ln -s /etc/nginx/sites-available/git /etc/nginx/sites-enabled
RUN echo '172.17.0.2    example.com' > /etc/hosts


#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN chmod 777 -R /usr/local
USER $NORMAL_USER

ENTRYPOINT echo $USER_PASSWORD | sudo -S service mysql start \
        && echo $USER_PASSWORD | sudo -S service nginx start \
        && echo $USER_PASSWORD | sudo -S systemctl start gitea \
        && tail -f /dev/null 