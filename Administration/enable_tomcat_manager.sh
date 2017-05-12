#enable admin user for tomcat gui
sudo vim /etc/tomcat8/tomcat-users.xml


#The file must be like this

#<tomcat-users>
#<!--
#  <role rolename="tomcat"/>
#  <role rolename="role1"/>
#  <user username="tomcat" password="tomcat" roles="tomcat"/>
#  <user username="both" password="tomcat" roles="tomcat,role1"/>
#  <user username="role1" password="tomcat" roles="role1"/>
#-->

#	<role rolename="manager-gui"/>
#	<user username="admin" password="admin" roles="manager-gui"/>
#
#</tomcat-users>

#deploy dspace app (JSPUI)
