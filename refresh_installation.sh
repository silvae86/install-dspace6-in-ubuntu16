#!/usr/bin/env bash
sudo su
su postgres
date=$(date "+%Y.%m.%d-%H.%M.%S")
pg_dump dspace > ~/dspace_bak_$date.sql
exit
#set the modification date to the current date on the server because of any time offset problems
sudo su
cd /home/dspace/DSpace
git pull

rm -rf /dspace
touch -a /home/dspace/DSpace/dspace-jspui/src/main/webapp/image/*logo* &&
cd /home/dspace/DSpace  &&
mvn clean package  &&
cd /home/dspace/DSpace/dspace/target/dspace-installer &&
rm -rf /dspace/dspace/solr/statistics/data
#ant fresh_install &&
ant update &&
#copy app to installation directory
mkdir -p /dspace
cp -R /home/dspace/DSpace/* /dspace &&
#install compiled apps in tomcat8
#sudo cp $(find /home/dspace/DSpace | grep \.war$ | xargs echo) /var/lib/tomcat8/webapps;
cd /var/lib/tomcat8/webapps &&
rm -rf jspui/   oai/     rdf/     rest/    solr/    sword/   swordv2/ xmlui/ ROOT/ &&
#cp -R /dspace/target/webapps/jspui /dspace/target/webapps/solr /dspace/target/webapps/rest /var/lib/tomcat8/webapps &&
cp -R /home/dspace/DSpace/dspace/target/dspace-installer/webapps/solr /home/dspace/DSpace/dspace/target/dspace-installer/webapps/jspui /home/dspace/DSpace/dspace/target/dspace-installer/webapps/rest /var/lib/tomcat8/webapps &&
mkdir -p /var/lib/tomcat8/webapps/ROOT &&
cp -R /home/dspace/DSpace/dspace/target/dspace-installer/webapps/jspui/* /var/lib/tomcat8/webapps/ROOT &&

touch -a /var/lib/tomcat8/webapps/jspui/image/*logo*\
#give ownership of installation to tomcat user
sudo chown -R tomcat8 /dspace &&
#restart tomcat;
service tomcat8 restart &&
service apache2 restart &&
echo "OK";



cd /dspace/dspace/bin  &&
sudo ./dspace index-discovery
echo "rebuilt index";


