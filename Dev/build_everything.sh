#!/bin/bash

src_folder="/Users/joaorocha/NetBeansProjects/DSpace"
build_folder="/Users/joaorocha/NetBeansProjects/DSpaceBin"
dest_folder="/usr/local/Cellar/tomcat/8.5.15/libexec/webapps"
catalina_path="/usr/local/Cellar/tomcat/8.5.15/bin/catalina"

cd "$src_folder"

mvn package
cd dspace/target/dspace-installer
ant update

cp -R "$build_folder/webapps/*" "$dest_folder"
"$catalina_path" stop
"$catalina_path" run

"$dest_folder/bin/dspace" index-init
