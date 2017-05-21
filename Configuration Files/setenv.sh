#!/bin/sh

export JAVA_OPTS="$JAVA_OPTS -Xms512M -Xmx512M -Ddspace.dir=/dspace/dspace"

#for dev

#put setenv.sh in /usr/local/Cellar/tomcat/8.5.15/libexec/bin (mac)
export JAVA_OPTS="$JAVA_OPTS -Xms512M -Xmx512M -Ddspace.dir=/Users/joaorocha/NetBeansProjects/DSpaceBin"
