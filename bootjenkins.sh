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
echo "* install tomcat9                                                    *"
echo "*                                                                    *" 
echo "**********************************************************************" 
echo

apt-get update

apt-get install -y apt-get install openjdk-8-jdk
ln -s /usr/lib/jvm/
JAVA_HOME=/usr/lib/jvm/java8
EXPORT JAVA_HOME
echo "export JAVA_HOME=/usr/lib/jvm/java8" >> /etc/bashrc

wget https://apache.newfountain.nl/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp
tar zxf /tmp/apache-maven-3.6.3-bin.tar.gz --directory=/opt
ln -s /opt/apache-maven-3.6.3 /opt/maven
ln -s /opt/maven/bin/mvn /usr/bin/mvn
M2_HOME=/opt/maven
echo "export M2_HOME=/opt/maven" >> /etc/bashrc

apt-get install -y git

wget https://download.sonatype.com/nexus/3/nexus-3.30.0-01-unix.tar.gz
tar zxf nexus-3.30.0-01-unix.tar.gz --directory=/opt
rm nexus-3.30.0-01-unix.tar.gz
ln -s /opt/nexus-3.30.0-01 /opt/nexus
/opt/nexus/bin/nexus start

groupadd tomcat
useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
wget https://mirror.novg.net/apache/tomcat/tomcat-9/v9.0.44/bin/apache-tomcat-9.0.44.tar.gz -P /tmp
tar zxf /tmp/apache-tomcat-9.0.44.tar.gz --directory=/opt
ln -s /opt/apache-tomcat-9.0.44 /opt/tomcat/latest
chown -RH tomcat: /opt/tomcat/latest
sed -i 's/8080/8090/g' /opt/tomcat/latest/conf/server.xml
chmod +x /opt/tomcat/latest/bin/*.sh
/opt/tomcat/bin/startup.sh

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
add-apt-repository universe
apt-get update
apt-get install jenkins -y
cat /var/lib/jenkins/secrets/initialAdminPassword

echo
echo "**********************************************************************"
echo "*                                                                    *"
echo "* Open the Firewall to access the Jenkins GUI from the host          *"
echo "*                                                                    *"
echo "**********************************************************************"
echo

ufw enable
ufw default allow outgoing
ufw default allow incoming
ufw allow 80
ufw allow 8080
ufw allow 8090
ufw allow 8081

echo
echo "**********************************************************************"
echo "*                                                                    *"
echo "* Show the network settings of the VM                                *"
echo "*                                                                    *"
echo "**********************************************************************"
echo

ip addr show

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
echo "*                                                                    *"
echo "* start Tomcat  = /opt/tomcat/latest/bin/startup.sh                  *"
echo "* start Nexus   = /opt/nexus/bin/nexus start                         *"
echo "*                                                                    *"
echo "* Tomcat  port: 8090                                                 *"
echo "* Jenkins port: 8080                                                 *"
echo "* Nexus   port: 8081                                                 *"
echo "*                                                                    *"
echo "**********************************************************************"
echo

exit 0
