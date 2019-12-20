#Use Ubuntu or u dum dum
FROM ubuntu:latest

#Set timezone
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Use bash from now on
SHELL ["/bin/bash", "-c"]

#Install & update hings
RUN apt-get update -y && apt-get -y install \ 
    sudo \
    bash \
    nano \
    openjdk-8-jdk \ 
    curl \
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

#Set System Locale 
ENV LOCALE_CODE en_GB.UTF-8
RUN locale-gen $LOCALE_CODE
RUN update-locale LANG=$LOCALE_CODE

#Fix Systemctl because you forgot how to use SystemV
RUN wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /usr/local/bin/systemctl
RUN chmod a+x /usr/local/bin/systemctl

#Add a standard user for later and open permissions to the needed directories, you're not important enough to use root 
ENV NORMAL_USER cthacker
ENV USER_PASSWORD Sp00kyP4SS!
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN chmod 777 -R /usr/local
USER $NORMAL_USER