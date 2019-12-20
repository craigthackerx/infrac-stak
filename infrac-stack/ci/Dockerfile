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

#Set Enviroment variables here...or don't, who cares.
RUN echo 'export NODE_OPTIONS=--max_old_space_size=4096' >> $HOME/.bashrc 
RUN echo 'export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"' >> $HOME/.bashrc 
RUN echo 'export ANDROID_HOME="/usr/local/android-sdk-linux"' >> $HOME/.bashrc
RUN echo 'export PATH=$PATH::$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$JAVA_HOME/bin' >> $HOME/.bashrc

#Install NVM because you aren't smart enough to install Node.JS manually
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.16.0
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use $NODE_VERSION
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

#Install SDKMAN! aswell, because you have no idea what gradle even is nevermind installing it
ENV GRADLE_VERSION gradle 4.8.1
RUN curl -s "https://get.sdkman.io" | bash
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install $GRADLE_VERSION
WORKDIR $HOME/${NORMAL_USER}