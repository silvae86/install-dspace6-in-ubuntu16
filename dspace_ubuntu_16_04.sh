#!/bin/bash

#install dependencies
sudo apt-get install openjdk-8-jdk tasksel ant maven htop
sudo tasksel #select PostgreSQL server and Tomcat Server. Confirm.

#editing database properties
sudo su postgres 
createuser -U postgres -d -A -P dspace

vim /etc/postgresql/9.5/main/pg_hba.conf 

#add at the end:
#local all dspace md5 

#create dspace user and dspace directory
sudo useradd -m dspace
sudo passwd dspace #enter password
sudo mkdir /dspace
sudo chown dspace /dspace

#authenticate as dspace
sudo su dspace

#create the database for dspace
sudo -u dspace createdb -U dspace -E UNICODE dspace

exit

#install pgcrypto
sudo su postgres
psql dspace
CREATE EXTENSION pgcrypto;

#clone dspace

cd ~/
git clone https://github.com/DSpace/DSpace 
cd DSpace
git checkout dspace-6.0

#fix settings in dspace.cfg

## DSpace installation directory
## Windows note: Please remember to use forward slashes for all paths (e.g. C:/dspace)
#dspace.dir = /dspace/dspace

#compile
cd /home/dspace/DSpace
mvn package
cd /home/dspace/DSpace/dspace/target/dspace-installer
ant fresh_install

#copy app to installation directory
sudo cp -R /home/dspace/DSpace/* /dspace

#install compiled apps in tomcat8
#sudo cp $(find /home/dspace/DSpace | grep \.war$ | xargs echo) /var/lib/tomcat8/webapps

sudo cp -r /home/dspace/DSpace/dspace/target/dspace-installer/webapps/* /var/lib/tomcat8/webapps

#restart tomcat
sudo service tomcat8 restart
