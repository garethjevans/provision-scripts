#!/bin/sh

agent_download_path="https://github.com/garethjevans/provision-scripts/blob/master/ibm-ucd-agent.zip?raw=true"
agent_download_name=`basename ${agent_download_path} | sed 's/\(^[a-z\]*-[a-z]*-[a-z]*.zip\).*$/\1/'`

installation_dir=/opt/ibm-ucd/agent
mkdir -p ${installation_dir}

wget ${agent_download_path} -O /tmp/${agent_download_name}
unzip /tmp/${agent_download_name}
cd /tmp/${agent_download_name}

./install_agent.sh << EOF
${installation_dir}
EOF
