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

############################################################################
## Install UrbanCode agent                                                ##
############################################################################

user=ucdagent

#create user
echo "creating user ${user}" >> $LOG
useradd ${user}

#add user to the sudoers wheel
echo "enabling the sudoers wheel (no password) - this will need to be changed(insecure)!!" >> $LOG
sed -i 's/^#\( %wheel.*NOPASSWD.*$\)/\1/' /etc/sudoers

#disable requiretty
sed -i 's/^\(Defaults\).*\(requiretty\)$/\1 \!\2/' /etc/sudoers

#add user to the wheel group
echo "adding user ${user} to the wheel group" >> $LOG
usermod -aG wheel ${user}

# changing mode of the install log
chmod 777 $LOG

agent_download_path="https://github.com/garethjevans/provision-scripts/blob/master/ibm-ucd-agent.zip?raw=true"
agent_download_name=`basename ${agent_download_path} | sed 's/\(^[a-z\]*-[a-z]*-[a-z]*.zip\).*$/\1/'`

installation_dir=/opt/ibm-ucd/agent
echo "Host Entries..." >> $LOG
partial_ip=$(ifconfig | tail -n +`ifconfig | grep -n eth1| awk -F':' '{print $1+1}'` | head -1 | awk '{print substr($2,6,10)}')
echo "${partial_ip}88 mcp-poc-uc.softlayer.com mcp-poc-uc" >> /etc/hosts
echo "Done" >> $LOG
host_name=$(grep `hostname` /etc/hosts | awk '{print $3}')

echo "downloading ucd agent" >> $LOG
wget ${agent_download_path} -O /tmp/${agent_download_name} >> $LOG
cd /tmp
echo "unzipping /tmp/${agent_download_name}" >> $LOG
unzip /tmp/${agent_download_name}
cd /tmp/${agent_download_name%%.*}-install

echo "running installing of ucd agent" >> $LOG
./install-agent.sh << EOF
${installation_dir}
Y
/opt/java8
N
mcp-poc-uc
7918
N
N
${host_name}
None
EOF

# configure access to ucd-agent installation
echo "Changing owner of ${installation_dir} to ${user}" >> $LOG
chown -R ${user} ${installation_dir}/..
chown -R :${user} ${installation_dir}/..

runuser -l ${user} -c '/opt/ibm-ucd/agent/bin/agent start >> /tmp/install.log'
