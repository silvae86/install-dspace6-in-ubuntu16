#!/bin/bash

sudo wget https://github.com/DSpace/DSpace/blob/dspace-5.5/dspace/config/spring/api/bte.xml#L321 /dspace/bte.xml
sudo wget https://github.com/DSpace/DSpace/blob/dspace-5.5/dspace/config/spring/api/bte.xml#L321 /dspace/bte.xml

sudo ./dspace import -b -e dspace_user_email@gmail.com -c 123456789/2 -s /home/dspace/dspace_import.ris -m /dspace/bte_ris.xml -i ris