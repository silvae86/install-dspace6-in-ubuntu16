#!/bin/bash

#install dependencies
sudo apt-get -qq -y install openjdk-8-jdk tasksel ant maven htop lynx wget
sudo tasksel #select PostgreSQL server and Tomcat Server. Confirm.
sudo apt-get install mutt #optional, for mailing files as attachments.

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

exit

#create dspace user and dspace directory
sudo useradd -m dspace
sudo passwd dspace #enter password
sudo mkdir /dspace
sudo chown dspace /dspace

#create the database for dspace
sudo -u dspace createdb -U dspace -E UNICODE dspace

#install pgcrypto
sudo su postgres
psql dspace
CREATE EXTENSION pgcrypto;
#Type \q and then press ENTER to quit psql.

exit

#clone dspace
sudo su dspace
cd /home/dspace
git clone https://github.com/DSpace/DSpace
cd DSpace
git checkout dspace-6.0

#configure things for compiling dspace
cd /home/dspace/DSpace
#set build properties
cd /home/dspace/DSpace/dspace/config
cp local.cfg.EXAMPLE local.cfg

vim /home/dspace/DSpace/dspace/config/local.cfg
#paste the contents of attached file in this gist
#change the password for the database
#in the connection string!!!

#configure csv import
cp /home/dspace/DSpace/dspace/config/spring/api/bte.xml vim /home/dspace/DSpace/dspace/config/spring/api/bte.xml.bak
vim /home/dspace/DSpace/dspace/config/spring/api/bte.xml
#replace the <bean id="csvDataLoader" section with the contents of the bte.xml in this gist
exit

#upload any custom logos to
#/home/dspace/DSpace/dspace-jspui/src/main/webapp/image
#/home/dspace/DSpace/dspace/target/dspace-installer/webapps/xmlui/themes/Mirage/images

# you can also edit the header jsp file to change the path to the logo
#vim /dspace/webapps/jspui/layout/header-default.jsp

sudo su
su postgres
date=$(date "+%Y.%m.%d-%H.%M.%S")
pg_dump dspace > ~/dspace_bak_$date.sql
exit
#set the modification date to the current date on the server because of any time offset problems
touch -a /var/lib/tomcat8/webapps/jspui/image/*logo*
cd /home/dspace/DSpace  &&
mvn package &&
cd /home/dspace/DSpace/dspace/target/dspace-installer &&
#ant fresh_install &&
ant update &&
#copy app to installation directory
cp -R /home/dspace/DSpace/dspace /dspace &&
#install compiled apps in tomcat8
#sudo cp $(find /home/dspace/DSpace | grep \.war$ | xargs echo) /var/lib/tomcat8/webapps;
cd /var/lib/tomcat8/webapps &&
rm -rf jspui/   oai/     rdf/     rest/    solr/    sword/   swordv2/ xmlui/ &&
cp -R /dspace/dspace/webapps/jspui /dspace/dspace/webapps/solr /dspace/dspace/webapps/rest /var/lib/tomcat8/webapps &&
touch -a /home/dspace/DSpace/dspace-jspui/src/main/webapp/image/*logo* &&
#give ownership of installation to tomcat user
sudo chown -R tomcat8 /dspace &&
#restart tomcat;
service tomcat8 restart &&
echo "OK";

#create admin user
chmod +x /dspace/dspace/bin/dspace
su dspace
/dspace/dspace/bin/dspace create-administrator

exit
#check if dspace is running..

#installing proxy in front of Tomcat (for port 80 access)
sudo su
vim /etc/tomcat8/server.xml

#AJP connector should be enabled

# <!-- Define an AJP 1.3 Connector on port 8009 -->
#
# <Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />

#enable apache modules
a2enmod proxy proxy_ajp &&
service apache2 restart &&
echo "OK"

#replace default website with proxy'ed Tomcat+
ln -s /etc/apache2/sites-available/dspace-vhost-site.conf /etc/apache2/sites-enabled/dspace-vhost-site.conf
rm -rf /etc/apache2/sites-enabled/000-default.conf &&
#copy dspace-vhost-site.conf to /etc/apache2/sites-available/dspace-vhost-site.conf
service apache2 restart &&
service tomcat8 restart &&
#deploy dspace as root app in tomcat8
cd /var/lib/tomcat8/webapps &&
rm -rf jspui/   oai/     rdf/     rest/    solr/    sword/   swordv2/ xmlui/ ROOT/ &&
mv /home/dspace/DSpace/dspace/modules/jspui/target/jspui-6.0.war /home/dspace/DSpace/dspace/modules/jspui/target/ROOT.war
cp -R /dspace/dspace/webapps/jspui /dspace/dspace/webapps/solr /dspace/dspace/webapps/rest /home/dspace/DSpace/dspace/modules/jspui/target/ROOT.war /var/lib/tomcat8/webapps &&
touch -a /home/dspace/DSpace/dspace-jspui/src/main/webapp/image/*logo* &&
#give ownership of installation to tomcat user
sudo chown -R tomcat8 /dspace &&
#restart tomcat & apache;
service apache2 restart &&
service tomcat8 restart &&
echo "OK";
