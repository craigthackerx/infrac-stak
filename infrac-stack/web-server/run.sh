if [ $UID -ne 0 ]; then
  sudo /usr/local/apachegui/ApacheGUI/tomcat/bin/startup.sh
  exit
fi

exec /usr/local/apachegui/ApacheGUI/tomcat/bin/startup.sh 
