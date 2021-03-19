#!/usr/bin/env bash
#
# Author:      Taco Bakker
#
# Purpose:	   Provision a VM with Jenkins running on it.
#              
# Description: The standard out-of-the box Debian package installation is done
#

echo   
echo "**********************************************************************"
echo "*                                                                    *"
echo "* Starting the bootscript....                                        *"  
echo "* install maven                                                      *"
echo "* install git                                                        *"
echo "* install jenkins                                                    *"
echo "* install java-1.8.0-openjdk-devel                                   *"  
echo "* start the jenkins service                                          *"
echo "*                                                                    *" 
echo "**********************************************************************" 
echo

wget https://apache.newfountain.nl/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar zxf apache-maven-3.6.3-bin.tar.gz --directory=/opt
ln -s /opt/apache-maven-3.6.3 /opt/maven
ln -s /opt/maven/bin/mvn /usr/bin/mvn
M2_HOME=/opt/maven
echo "export M2_HOME=/opt/maven" >> /etc/bashrc
rm apache-maven-3.6.3-bin.tar.gz

yum -y install git
yum -y install java-1.8.0-openjdk-devel
JAVA_HOME=/usr/lib/jvm/java
echo "export JAVA_HOME=/usr/lib/jvm/java" >> /etc/bashrc

wget https://download.sonatype.com/nexus/3/nexus-3.30.0-01-unix.tar.gz
tar zxf nexus-3.30.0-01-unix.tar.gz --directory=/opt
rm nexus-3.30.0-01-unix.tar.gz
ln -s /opt/nexus-3.30.0-01 /opt/nexus
/opt/nexus/bin/nexus start

wget https://mirror.novg.net/apache/tomcat/tomcat-9/v9.0.44/src/apache-tomcat-9.0.44-src.tar.gz
tar zxf apache-tomcat-9.0.44-src.tar.gz --directory=/opt
rm apache-tomcat-9.0.44-src.tar.gz
ln -s /opt/apache-tomcat-9.0.44-src /opt/tomcat
sed -i 's/8080/8090/g' /opt/tomcat/conf/server.xml
chmod +x /opt/tomcat/bin/*.sh
/opt/tomcat/bin/startup.sh

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum upgrade -y
yum install -y jenkins 
systemctl daemon-reload
systemctl start jenkins

echo
echo "**********************************************************************"
echo "*                                                                    *"
echo "* Open the Firewall to access the Jenkins GUI from the host          *"
echo "*                                                                    *"
echo "**********************************************************************"
echo

firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=8081/tcp --permanent
firewall-cmd --zone=public --add-port=8090/tcp --permanent
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --reload

echo
echo "**********************************************************************"
echo "*                                                                    *"
echo "* Show the network settings of the VM                                *"
echo "*                                                                    *"
echo "**********************************************************************"
echo

wget http://192.168.33.60:8080/jnlpJars/jenkins-cli.jar
 

ifconfig



echo
echo "**********************************************************************"
echo "*                                                                    *"
echo "* To access the VM via SSH just type:                                *"
echo "* vagrant ssh                                                        *"
echo "* become root in the VM by typing: sudo su                           *"
echo "* get the initial admin password:                                    *"
echo "* cat /var/lib/jenkins/secrets/initialAdminPassword                  *"
echo "*                                                                    *"
echo "* JENKINS_HOME = /var/lib/jenkins                                    *"
echo "* MAVEN_HOME = /opt/maven                                            *"
echo "* JAVA_HOME = /usr/lib/jvm/java                                      *"
echo "**********************************************************************"
echo

exit 0
