#Use Ubuntu
FROM ubuntu:latest

#Set Enviroment Timezone
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Use Bash
SHELL ["/bin/bash", "-c"]