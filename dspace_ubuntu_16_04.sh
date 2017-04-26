#!/bin/bash

#install dependencies
sudo apt-get install openjdk-8-jdk tasksel ant maven
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

#create the database for dspace
sudo -u dspace createdb -U dspace -E UNICODE dspace

#clone dspace
sudo su dspace
cd ~/
git clone https://github.com/DSpace/DSpace 
cd DSpace
git checkout dspace-6.0
mvn -U package
cd dspace/target/dspace-6.0
sudo ant fresh_install
cp dspace/target/dspace-installer/webapps 

#install compiled apps in tomcat8
sudo cp -R /home/dspace/DSpace/dspace/target/dspace-installer/webapps/* /usr/share/tomcat8-root/

#restart tomcat
sudo service tomcat8 restart