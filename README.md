# infrac-stak
A infrastructure as code stack, created with Docker.  Modular &amp; Agnostic by default.

The project is treated as an entry point for many junior DevOps or System Administrators looking to modernise there infrastructre stack, and is being used as a learning material for contributors and observers.

The project is planned as having seperate "modules" where each module is another essential point as part of a typical modern infrastructure.  Modules are broken into seperate containers and `Dockerfile`'s with a single `docker-compose` for the entire stack. The approach of this project is to approach the problem with a "no-cost" approach with only open-source or free-use software as each of our approach. The idea of the project as previously iterated is to be totally modular, where although some tools may be reused (i.e. Apache used to host another part of the infrastructure other than a typical Website), it is intended if you are interested in 1 section that pulling that `Dockerfile` and building it should be sufficent. 

In it's inital iteration, *it is not for production systems*.  All modules will not leverage pre-existing images except that of operating system images with everything installed within to ensure total modularity for each section and to not breach any other copyright or privacy rules.

The modules planned are as follows with inital technolgies used:

- LDAP ~ OpenLDAP
- DNS  ~ OpenDNS
- DHCP ~ DHCPD
- SQL Database ~ MySQL/MariaDB
- NoSQL Database ~ MongoDB/CouchDB
- Firewall ~ PfSense (or Linux alterative)
- Web Server ~ Apache
- Monitoring ~ Nagios Core/LibreNMS/Prometheus
- Logging ~ GrayLog/ELK Stack/Prometheus
- CI/CD ~ Jenkins/Travis
- Service Desk ~ oSTicket
- Wiki-Style Documentation ~ Docuwiki
- Board ~ WeKan
