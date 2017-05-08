#!/bin/bash
sudo su
chmod -R ugo+w /dspace/dspace/imports

cd /dspace/dspace/bin
chmod +x ./dspace
./dspace import -s /home/dspace/template.csv -i csv -m /home/dspace/map -b -e lolada@gmail.com -c "123456789/4"
