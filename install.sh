#!/bin/sh

LOG=/tmp/install.log

echo "Installing Java..." >> $LOG
cd /opt/
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jdk-8u40-linux-x64.tar.gz"
tar xzf jdk-8u40-linux-x64.tar.gz
ln -s /opt/jdk1.8.0_40 /opt/java8
cd /opt/jdk1.8.0_40/
alternatives --install /usr/bin/java java /opt/java8/bin/java 2
alternatives --install /usr/bin/jar jar /opt/java8/bin/jar 2
alternatives --install /usr/bin/javac javac /opt/java8/bin/javac 2
alternatives --set jar /opt/java8/bin/jar
alternatives --set javac /opt/java8/bin/javac

java -version >> $LOG

echo "Host Entries..." >> $LOG
echo "159.8.157.88 mcp-poc-uc.softlayer.com mcp-poc-uc" >> /etc/hosts
echo "Done" >> $LOG

. install_urbancode_agent.sh
