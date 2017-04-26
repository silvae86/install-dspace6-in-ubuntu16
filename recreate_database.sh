#misc stuff

#re-create database
sudo -u dspace dropdb dspace
sudo -u dspace createdb -U dspace -E UNICODE dspace
sudo -u dspace psql dspace

#alter the password for the dspace user
ALTER USER "dspace" WITH PASSWORD 'dspace';