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

#Prometheus Version
ENV RELEASE 2.2.1

EXPOSE 80 443 9090 

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

#Add Locale
RUN locale-gen $LOCALE_CODE
RUN update-locale LANG=$LOCALE_CODE

#Fix Systemctl because you forgot how to use SystemV
RUN wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /usr/local/bin/systemctl
RUN chmod a+x /usr/local/bin/systemctl

#Make prometheus group and user
RUN groupadd --system prometheus \
 && useradd -s /sbin/nologin -r -g prometheus prometheus

RUN wget https://github.com/prometheus/prometheus/releases/download/v${RELEASE}/prometheus-${RELEASE}.linux-amd64.tar.gz \
        && tar xvf prometheus-${RELEASE}.linux-amd64.tar.gz \
        && cd prometheus-${RELEASE}.linux-amd64/ \
        && mkdir -p /etc/prometheus/{rules,rules.d,files_sd}  /var/lib/prometheus \
        && cp prometheus promtool /usr/local/bin/ \
        && chown -R prometheus:prometheus /etc/prometheus/  /var/lib/prometheus/ \
        && chmod -R 775 /etc/prometheus/ /var/lib/prometheus/
ADD prometheus.yml /etc/prometheus/prometheus.yml
ADD prometheus.service /etc/systemd/system/prometheus.service

#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN chmod 777 -R /usr/local
USER $NORMAL_USER

#Set entrypoint scripts
ENTRYPOINT echo $USER_PASSWORD | sudo -S service ssh start \
        && echo $USER_PASSWORD | sudo -S prometheus --config.file=/etc/prometheus/prometheus.yml \
        && tail -f /dev/null 