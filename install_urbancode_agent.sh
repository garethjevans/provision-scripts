#!/bin/sh

installation_dir=/opt/ibm-ucd/agent
mkdir -p ${installation_dir}
mv ibm-ucd-agent.zip /tmp
unzip /tmp/ibm-ucd-agent.zip
cd /tmp/ibm-ucd-agent-install

./install_agent.sh << EOF
${installation_dir}
EOF
