#!/bin/bash

#install dependencies
sudo apt-get install openjdk-8-jdk tasksel ant maven htop lynx
sudo tasksel #select PostgreSQL server and Tomcat Server. Confirm.

#edit tomcat heap space
sudo vim /usr/share/tomcat8/bin/setenv.sh
#paste the contents of the setenv.sh file in this gist and save
sudo service tomcat8 restart

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

cd /home/dspace
git clone https://github.com/DSpace/DSpace 
cd DSpace
git checkout dspace-6.0

#compile
cd /home/dspace/DSpace
#set build properties
cd /home/dspace/DSpace/dspace/config
cp local.cfg.EXAMPLE local.cfg

vim local.cfg
#paste the contents of attached file in this gist

sudo su
cd /home/dspace/DSpace;
mvn package;
cd /home/dspace/DSpace/dspace/target/dspace-installer;
ant fresh_install;

#copy app to installation directory
cp -R /home/dspace/DSpace/dspace /dspace

#install compiled apps in tomcat8
#sudo cp $(find /home/dspace/DSpace | grep \.war$ | xargs echo) /var/lib/tomcat8/webapps

cp -R /dspace/dspace/webapps/* /var/lib/tomcat8/webapps

#give ownership of installation to tomcat user
sudo chown -R tomcat8 /dspace
#restart tomcat
service tomcat8 restart
