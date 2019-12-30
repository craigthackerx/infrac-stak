#Use Ubuntu
FROM ubuntu:latest

#Set enviroment variables here
ENV TIME_ZONE=Europe/London

#Set System Locale 
ENV LOCALE_CODE en_GB.UTF-8

#Set user for personal preference and password. These are used later on.
ENV NORMAL_USER cthacker
ENV USER_PASSWORD Sp00kyP4SS!

#Set home enviroment
ENV HOME /home/$NORMAL_USER

#Use Bash
SHELL ["/bin/bash", "-c"]

#Set timezone
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone

#Update and install hings
RUN apt-get update -y && apt-get -y install sudo \
    apt-utils \
    bash \
    locales \
    nano \
    vim \ 
    openjdk-8-jdk \ 
    curl \
    wget \
    xmlstarlet \
    git \
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

#Add a standard user for later and open permissions to the needed directories, you're not important enough to use root 
RUN useradd -m -s /bin/bash $NORMAL_USER 
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN chmod 777 /usr/local
RUN chmod 777 -R $HOME
RUN chmod 777 /opt
USER $NORMAL_USER 

#Begin Tomcat Installation
RUN cd /opt && wget http://mirror.ox.ac.uk/sites/rsync.apache.org/tomcat/tomcat-8/v8.5.50/bin/apache-tomcat-8.5.50.tar.gz
WORKDIR /opt
RUN tar -zxvf apache* && rm apache-tomcat-8.5*.tar.gz
RUN chmod 777 -R /opt/apache-tomcat-8.5*
RUN mv /opt/apache-tomcat-8.5* /opt/tomcat
RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64' >> $HOME/.bashrc
RUN echo 'export CATALINA_HOME=/opt/tomcat' >> $HOME/.bashrc
ADD tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml
ADD manager.xml /opt/tomcat/conf/Catalina/localhost/manager.xml
EXPOSE 8080

#Start Tomcat
ENTRYPOINT echo $USER_PASSWORD | sudo -S sh /opt/tomcat/bin/catalina.sh start \
        && echo $USER_PASSWORD | sudo -S service ssh start \
        && tail -f /dev/null