# VagrantFile that launches a Usergrid 1.0 Virtual Machine 

The VagrantFile in this directory starts a Virtual Machine (VM) running Ubuntu.

It installs and starts Cassandra, installs and starts Tomcat, installs and 
configures Usergrid 1.0 Stack and Portal to run on Tomcat. 

## How to launch the VM

1. Install [Vagrant](https://www.vagrantup.com/) on your computer
2. Clone the usergrid-vagrant repo
3. cd into the usergrid-vagrant directory
4. Run this command: vagrant up


## How to access the Usergrid Portal

Once the VM launches you should be able to:

1. Go to [http://10.1.1.161:8080/system/database/setup](http://10.1.1.161:8080/system/database/setup)
2. Login as superuser/test and the database will be setup
3. Go to [http://10.1.1.161:8080/system/superuser/setup](http://10.1.1.161:8080/system/superuser/setup) to setup the superuser 
4. Go to [http://10.1.1.161:8080/portal](http://10.1.1.161:8080/portal) and login as superuser/test
5. Enjoy Usergrid goodness!

If there are problems, please let me know.
