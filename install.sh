#!/bin/sh

LOG=/tmp/install.log

echo "Installing Stuff..." > $LOG
echo "Installing Java..." >> $LOG
echo "Host Entries..." >> $LOG
echo "159.8.157.88 mcp-poc-uc.softlayer.com mcp-poc-uc" >> /etc/hosts
echo "Done" >> $LOG

