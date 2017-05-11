#!/usr/bin/env bash

brew install maven ant

brew install postgresql
brew services start postgresql

createdb dspace
psql
#CREATE EXTENSION pgcrypto;
# \q to quit

brew install solr
brew services start solr

#copy apps
cd /usr/local/Cellar/tomcat/8.5.15/libexec/webapps/ &&
cp -R /Users/joaorocha/NetBeansProjects/DSpace/dspace/target/dspace-installer/webapps/* . &&
#start tomcat server
/usr/local/Cellar/tomcat/8.5.15/bin/catalina run

#add to dspace parent project's pom.xml file

# <dependency>
#     <groupId>xml-apis</groupId>
#     <artifactId>xml-apis</artifactId>
#     <version>1.4.01</version>
# </dependency>
