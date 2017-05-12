#!/bin/bash

src_folder="/Users/joaorocha/NetBeansProjects/DSpace/"
build_folder="/Users/joaorocha/NetBeansProjects/DSpaceBin"
dest_folder="/usr/local/Cellar/tomcat/8.5.15/libexec/webapps"
catalina_path="/usr/local/Cellar/tomcat/8.5.15/bin/catalina"

cd "$src_folder/dspace-jspui"
mvn package

cd "$src_folder/dspace/target/dspace-installer"
ant update

cp -R "$build_folder/webapps/jspui" "$dest_folder"
"$catalina_path" run

cd "$dest_folder/bin"
./dspace index-discovery

#create sysadmin
#chmod +x "$build_folder/bin/dspace"

# thinkpad:bin joaorocha$ ./dspace create-administrator --email admin@admin.com --password admin
# Creating an initial administrator account
# E-mail address: admin@admin.com
# First name: admin
# Last name: admin
# Password will not display on screen.
# Password:
# Again to confirm:
# Is the above data correct? (y or n): y
# Administrator account created
# thinkpad:bin joaorocha$
