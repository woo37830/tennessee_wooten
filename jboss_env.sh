#!/bin/bash

SG_HOME=/Users/woo
SG_BIN=$SG_HOME/bin
SG_TOOLS=$SG_HOME/Tools

CDPATH=.:$HOME:$SG_HOME:$SG_TOOLS
ANT_HOME=$SG_TOOLS/apache-ant-1.7.0
JAVA_HOME=$SG_TOOLS/jdk1.5.0_16
JBOSS_HOME=$SG_TOOLS/jboss-server

if [ -e "$JBOSS_HOME/jbpm-jpdl.jar" ]; then
  JBOSS_HOME="$JBOSS_HOME/server"
  JBOSS_CFG="jbpm"
else
  JBOSS_CFG="default"
fi

JBH=$JBOSS_HOME
JBB=$JBOSS_HOME/bin
JBS=$JBOSS_HOME/server
JBC=$JBOSS_HOME/server/$JBOSS_CFG
JBL=$JBOSS_HOME/server/$JBOSS_CFG/log
JBOSS_SVR=$JBC
PATH=$HOME/bin:$JAVA_HOME/bin:$ANT_HOME/bin:/usr/sbin:/sbin:/usr/kerberos/bin:/usr/lib/ccache:/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin
export SG_HOME SG_TOOLS CDPATH ANT_HOME JAVA_HOME JBOSS_HOME JBOSS_SVR JBOSS_CFG JBH JBB JBS JBC PATH

