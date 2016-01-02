# VagrantFile that launches a Usergrid 2 VM

The VagrantFile in this directory starts a Virtual Machine (VM) that runs the 
Usergrid Stack and Portal at [http://10.1.1.161:8080/portal](http://10.1.1.161:8080/portal) on your machine.

It installs and starts Cassandra + ElasticSearch, installs and starts Tomcat, installs and 
configures Usergrid 2 Stack and Portal to run on Tomcat. 

## How to launch the VM

1. Install [Vagrant](https://www.vagrantup.com/) on your computer
2. Clone the GitHub [usergrid-vagrant](https://github.com/snoopdave/usergrid-vagrant) repo
3. cd into the usergrid-vagrant directory
4. Run this command to launch the Vagrant VM with Usergrid: *vagrant up*
5. Wait 5-10 minutes for the installation to complete.

## How to access the Usergrid Portal

Once the VM launches and completes initialization, you should be able to:

* Go to [http://10.1.1.161:8080/status](http://10.1.1.161:8080/status) to view the Usergrid status page.
* Go to [http://10.1.1.161:8080/portal](http://10.1.1.161:8080/portal) to login to the Usergrid administration portal. You can login as *superuser* with password *test*. From there you can setup admin users and applications. 
* Use the Usergrid API to interact with your Usergrid BaaS, the base URL for API calls is http://10.1.1.160:8080. 

You can also use *vagrant ssh* to login to the VM and see the Usergrid installation. You'll find Java 1.8, Apache Cassandra, Tomcat and Usegrid installed. Three key parts of the Usergrid installation are:

1. Usergrid properties file: /usr/share/tomcat7/lib/usergrid-custom.properties
2. Usergrid WAR file: /var/lib/tomcat7/webapps/ROOT.war
3. Usergrid Portal: /var/lib/tomcat7/webapps/portal

For more about the Usergrid BaaS and its API, see the official [Apache Usergrid Documentation](http://usergrid.apache.org/docs/) site.


