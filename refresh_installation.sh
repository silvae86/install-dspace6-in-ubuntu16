#!/usr/bin/env bash
sudo -i
su postgres
#date=$(date "+%Y.%m.%d-%H.%M.%S")
#pg_dump dspace > ~/dspace_bak_$date.sql
#exit
#set the modification date to the current date on the server because of any time offset problems
#sudo su
cd /home/dspace
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
sudo cp -R /dspace/dspace/webapps/jspui /dspace/dspace/webapps/solr /dspace/dspace/webapps/rest /var/lib/tomcat8/webapps &&
sudo mkdir -p  /var/lib/tomcat8/webapps/ROOT &&
sudo cp -R /dspace/dspace/webapps/jspui/* /var/lib/tomcat8/webapps/ROOT &&
touch -a /home/dspace/DSpace/dspace-jspui/src/main/webapp/image/*logo* &&
#give ownership of installation to tomcat user
sudo chown -R tomcat8 /dspace &&
#restart tomcat;
service tomcat8 restart &&
echo "OK";


