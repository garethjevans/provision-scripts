#!/bin/sh

URBANCODE=10.112.165.75
INSTALL_DIR=/opt/ibm-ucd/agent
SOFTWARE_DIR=/opt/ibm-install/
LOG=/tmp/install.log
echo "Validating Java Install" >> $LOG
java -version >> $LOG

echo "Validating ucdagent pre-reqs" >> $LOG
id ucdagent >> $LOG

echo "Host Entries..." >> $LOG
echo "${URBANCODE} mcp-poc-uc.softlayer.com mcp-poc-uc" >> /etc/hosts
echo "Done" >> $LOG
HOST_NAME=$(grep `hostname` /etc/hosts | awk '{print $3}')

cd ${SOFTWARE_DIR}
echo "unzipping ${SOFTWARE_DIR}/ibm-ucd-agent.zip" >> $LOG
unzip ${SOFTWARE_DIR}/ibm-ucd-agent.zip
cd ${SOFTWARE_DIR}/ibm-ucd-agent-install

echo "Running installing of ucd agent" >> $LOG
./install-agent.sh << EOF
${INSTALL_DIR}
Y
/opt/java8
N
mcp-poc-uc
7918
N
N
${HOST_NAME}
None
EOF

echo "Configuring Startup Script" >> $LOG
cp -f ${SOFTWARE_DIR}/ucdagent /etc/init.d/
chmod 775 /etc/init.d/ucdagent
chkconfig --add ucdagent
chkconfig --list | grep ucdagent >> $LOG

# configure access to ucd-agent installation
echo "Changing owner of ${INSTALL_DIR} to ucdagent" >> $LOG
chown -R ucdagent:ucdagent ${INSTALL_DIR}/..

service ucdagent start

echo "Done" >> $LOG
