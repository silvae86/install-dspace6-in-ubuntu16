#!/bin/bash
#sudo su
mkdir -p /dspace/dspace/imports
chmod -R ugo+w /dspace/dspace/imports
chown -R tomcat8 /dspace

cd /dspace/dspace/bin
chmod +x ./dspace
./dspace import -b -s "/home/dspace/registos_lyman_sargent_20180207.csv" -m /home/dspace/map -e utopia@letras.up.pt -c "123456789/93757" -i csv
./dspace index-discovery
