#Use Ubuntu or u dum dum
FROM ubuntu:latest

#Set Enviroment Variables for personal preference below

EXPOSE 80 27017 8080 8081

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

#Use bash from now on
SHELL ["/bin/bash", "-c"]

#Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone

#Install & update hings
RUN apt-get update -y && apt-get -y install \ 
    apt-utils \
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

#Add Locale
RUN locale-gen $LOCALE_CODE
RUN update-locale LANG=$LOCALE_CODE

#Fix Systemctl because you forgot how to use SystemV
RUN wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /usr/local/bin/systemctl
RUN chmod a+x /usr/local/bin/systemctl

#Add MongoDB key & Install
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 4B7C549A058F8B6B
RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb.list
RUN apt-get update && apt-get install -y \
    mongodb-org=4.2.1 \
    mongodb-org-server=4.2.1 \
    mongodb-org-shell=4.2.1 \
    mongodb-org-mongos=4.2.1 \
    mongodb-org-tools=4.2.1

#Add a standard user for later and open permissions to the needed directories
RUN useradd -m -s /bin/bash $NORMAL_USER
RUN usermod -aG sudo $NORMAL_USER
RUN echo $NORMAL_USER:$USER_PASSWORD | chpasswd
RUN chmod 777 -R /usr/local
USER $NORMAL_USER
WORKDIR $HOME

#Set Bash profile here
RUN echo 'export NODE_OPTIONS=--max_old_space_size=4096' >> $HOME/.bashrc 
RUN echo 'export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"' >> $HOME/.bashrc 
RUN echo 'export ANDROID_HOME="/usr/local/android-sdk-linux"' >> $HOME/.bashrc
RUN echo 'export PATH=$PATH::$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$JAVA_HOME/bin' >> $HOME/.bashrc

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && npm install -g mongo-express

#Install SDKMAN! aswell
RUN curl -s "https://get.sdkman.io" | bash
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install $GRADLE_VERSION
