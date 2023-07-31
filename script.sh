#!/bin/bash

# https://github.com/HoangHaix86/setup-hadoop.git
# rm -rf setup-hadoop && git clone https://github.com/HoangHaix86/setup-hadoop.git && chmod +x ./setup-hadoop/script.sh && sudo ./setup-hadoop/script.sh

NAMENODE="192.168.131.132"
DATANODE1="192.168.131.141"
DATANODE2="192.168.131.140"
DATANODE3="192.168.131.153"

sudo echo "$NAMENODE namenode" >>/etc/hosts
sudo echo "$DATANODE1 datanode1" >>/etc/hosts
sudo echo "$DATANODE2 datanode2" >>/etc/hosts
sudo echo "$DATANODE3 datanode3" >>/etc/hosts

# Update vs upgrade
sudo apt update
sudo apt upgrade -y

# for setup
# sudo apt install -y open-vm-tools-desktop

# Install openssh-server
sudo apt install -y openssh-server python3-lxml openjdk-8-jdk git

# ssh
rm ~/.ssh/id_rsa
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >>~/.ssh/authorized_keys
sudo chmod 0600 ~/.ssh/authorized_keys

# add xmleditor
sudo cp ./**/xmleditor.py /usr/local/bin/xmleditor.py
sudo chmod a+x /usr/local/bin/xmleditor.py

sudo chmod -R a+rwx /opt

export HADOOP_VERSION=3.3.6
export HADOOP_HOME=/opt/hadoop
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

export HADOOP_LOG_DIR=\$HADOOP_HOME/logs
export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
export HADOOP_MAPRED_HOME=\$HADOOP_HOME
export HADOOP_COMMON_HOME=\$HADOOP_HOME
export HADOOP_HDFS_HOME=\$HADOOP_HOME
export YARN_HOME=\$HADOOP_HOME

echo "export HADOOP_VERSION=3.3.6" >>/etc/environment
echo "export HADOOP_HOME=/opt/hadoop" >>/etc/environment
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >>/etc/environment
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >>/etc/environment

echo "export HADOOP_LOG_DIR=\$HADOOP_HOME/logs" >>/etc/environment
echo "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >>/etc/environment
echo "export PATH=\$PATH:\$HADOOP_HOME/bin" >>/etc/environment
echo "export PATH=\$PATH:\$HADOOP_HOME/sbin" >>/etc/environment
echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" >>/etc/environment
echo "export HADOOP_COMMON_HOME=\$HADOOP_HOME" >>/etc/environment
echo "export HADOOP_HDFS_HOME=\$HADOOP_HOME" >>/etc/environment
echo "export YARN_HOME=\$HADOOP_HOME" >>/etc/environment
echo "export HADOOP_CLASSPATH=\$JAVA_HOME/lib/tools.jar" >>/etc/environment
source /etc/environment

# install hadoop
wget "https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz" &&
tar -xvzf hadoop-3.3.6.tar.gz &&
sudo mv -f hadoop-3.3.6 /opt/hadoop &&
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >>/opt/hadoop/etc/hadoop/hadoop-env.sh

# add host
# echo "$IP_MASTER master" >>/etc/hosts
# echo "$IP_SLAVE_1 master" >>/etc/hosts
# echo "$IP_SLAVE_2 master" >>/etc/hosts
# echo "$IP_SLAVE_3 master" >>/etc/hosts

# # config hadoop
# # core-site.xml
xmleditor.py -a -p $HADOOP_CONF_DIR/core-site.xml -n fs.defaultFS -v hdfs://master:9000

# # hdfs-site.xml
xmleditor.py -a -p $HADOOP_CONF_DIR/hdfs-site.xml -n dfs.replication -v 3
xmleditor.py -a -p $HADOOP_CONF_DIR/hdfs-site.xml -n dfs.namenode.name.dir -v file:///opt/hadoop/data/namenode
xmleditor.py -a -p $HADOOP_CONF_DIR/hdfs-site.xml -n dfs.datanode.data.dir -v file:///opt/hadoop/data/datanode

# # yarn-site.xml
xmleditor.py -a -p $HADOOP_CONF_DIR/yarn-site.xml -n yarn.nodemanager.aux-services -v mapreduce_shuffle
xmleditor.py -a -p $HADOOP_CONF_DIR/yarn-site.xml -n yarn.nodemanager.aux-services.mapreduce.shuffle.class -v org.apache.hadoop.mapred.ShuffleHandler
xmleditor.py -a -p $HADOOP_CONF_DIR/yarn-site.xml -n yarn.resourcemanager.hostname -v master

# # mapred-site.xml
xmleditor.py -a -p $HADOOP_CONF_DIR/mapred-site.xml -n mapreduce.framework.name -v yarn
xmleditor.py -a -p $HADOOP_CONF_DIR/mapred-site.xml -n mapreduce.jobtracker.address -v master:54311

sudo mkdir -p /opt/hadoop/data/namenode
sudo mkdir -p /opt/hadoop/data/datanode

# # master
# # echo master >$HADOOP_HOME/etc/hadoop/masters

# # workers
# # echo slave_1 >$HADOOP_HOME/etc/hadoop/workers
