# infrac-stak

![Gif](infra-stak.gif)

A infrastructure as code stack, created with Docker.  Modular &amp; Agnostic by default.

The project is treated as an entrypoint for Junior DevOps or System Administrators looking to modernise their infrastructre stack, and should be used as a learning material for contributors and observers. It is named as it is - with C at the end of "infra" - as to represent the project's creators first inital with the letter being taken from the "stack" word to ensure the same line character length of the entire name. Also, it sounds funny.

The project is planned as having seperate "modules" where each module is another essential part of a typical modern infrastructure.  Modules are broken into seperate containers and `Dockerfile`'s with a single `docker-compose` for the entire "stak". The approach of this project is to approach the problem with a "no-cost" point of view, thus only open-source or free-use software should be used for each module. The idea of the project as previously iterated is to be totally modular, where although some tools may be reused (i.e. Apache used to host another part of the infrastructure other than a typical Website), it is intended if you are interested in 1 section - pulling that `Dockerfile` and building it should be sufficent. 

In it's inital iteration, *it is not for production systems*.  All modules will not attempt not to leverage pre-existing images except that of operating system images, with each module functionality to be installed within to ensure total modularity for each section and to not breach any other copyright or privacy rules.

The modules planned are as follows with inital technolgies used:

- Alerting - Prometheus
- Board ~ KanBoard
- CI/CD ~ Jenkins
- DHCP ~ DHCPD
- DNS  ~ DNSMASQ & WebProc GUI 
- Firewall ~ PfSense (or Linux alterative)
- Git ~ Gitea
- Java-Server - Apache Tomcat
- LDAP ~ OpenLDAP
- Logging ~ GrayLog
- Monitoring ~ Nagios Core
- NoSQL Database ~ MongoDB & MongoExpress
- SQL Database ~ MariaDB
- Service Desk ~ oSTicket
- Web Server ~ Apache HTTPD
- Wiki-Style Documentation ~ Docuwiki

While these modules may change with time, in this iteration, this is the technlogies which are being explored.
