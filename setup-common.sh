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

# export HADOOP_VERSION=3.3.6
# export HADOOP_HOME=/opt/hadoop
# export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
# export PATH=$PATH:$JAVA_HOME/bin

# export HADOOP_LOG_DIR=$HADOOP_HOME/logs
# export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
# export PATH=$PATH:$HADOOP_HOME/bin
# export PATH=$PATH:$HADOOP_HOME/sbin
# export HADOOP_MAPRED_HOME=$HADOOP_HOME
# export HADOOP_HDFS_HOME=$HADOOP_HOME
# export YARN_HOME=$HADOOP_HOME

echo "export HADOOP_VERSION=3.3.6" >>/etc/environment
echo "export HADOOP_HOME=/opt/hadoop" >>/etc/environment
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >>/etc/environment
echo "export PATH=$PATH:$JAVA_HOME/bin" >>/etc/environment

echo "export HADOOP_LOG_DIR=$HADOOP_HOME/logs" >>/etc/environment
echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop" >>/etc/environment
echo "export PATH=$PATH:$HADOOP_HOME/bin" >>/etc/environment
echo "export PATH=$PATH:$HADOOP_HOME/sbin" >>/etc/environment
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME" >>/etc/environment
echo "export HADOOP_HDFS_HOME=$HADOOP_HOME" >>/etc/environment
echo "export YARN_HOME=$HADOOP_HOME" >>/etc/environment
echo "export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar" >>/etc/environment
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native" >> /etc/environment
echo "export HADOOP_OPTS=-Djava.library.path=$HADOOP_HOME/lib/native" >> etc/environment
echo "export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true" >> etc/environment
source /etc/environment

# install hadoop
wget "https://dlcdn.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" &&
tar -xvzf hadoop-$HADOOP_VERSION.tar.gz &&
sudo mv -f hadoop-$HADOOP_VERSION $HADOOP_HOME &&
rm hadoop-$HADOOP_VERSION.tar.gz &&
echo "export JAVA_HOME=$JAVA_HOME" >>$HADOOP_HOME/etc/hadoop/hadoop-env.sh

# config hadoop
# core-site.xml
xmleditor.py -a -p $HADOOP_CONF_DIR/core-site.xml -n fs.defaultFS -v hdfs://namenode:9000
xmleditor.py -a -p $HADOOP_CONF_DIR/core-site.xml -n dfs.permissions -v false

# # hdfs-site.xml
xmleditor.py -a -p $HADOOP_CONF_DIR/hdfs-site.xml -n dfs.replication -v 3
xmleditor.py -a -p $HADOOP_CONF_DIR/hdfs-site.xml -n dfs.namenode.name.dir -v file:///opt/hadoop/data/namenode
xmleditor.py -a -p $HADOOP_CONF_DIR/hdfs-site.xml -n dfs.datanode.data.dir -v file:///opt/hadoop/data/datanode

# # yarn-site.xml
xmleditor.py -a -p $HADOOP_CONF_DIR/yarn-site.xml -n yarn.nodemanager.aux-services -v mapreduce_shuffle
xmleditor.py -a -p $HADOOP_CONF_DIR/yarn-site.xml -n yarn.nodemanager.aux-services.mapreduce.shuffle.class -v org.apache.hadoop.mapred.ShuffleHandler
xmleditor.py -a -p $HADOOP_CONF_DIR/yarn-site.xml -n yarn.resourcemanager.hostname -v namenode

# # mapred-site.xml
xmleditor.py -a -p $HADOOP_CONF_DIR/mapred-site.xml -n mapreduce.framework.name -v yarn
xmleditor.py -a -p $HADOOP_CONF_DIR/mapred-site.xml -n mapreduce.jobtracker.address -v namenode:54311

sudo mkdir -p /opt/hadoop/data/temp
sudo mkdir -p /opt/hadoop/data/datanode
sudo mkdir -p /opt/hadoop/data/datanode

# master
echo $NAMENODE >$HADOOP_HOME/etc/hadoop/masters

# workers
echo $DATANODE1 >$HADOOP_HOME/etc/hadoop/workers
echo $DATANODE2 >>$HADOOP_HOME/etc/hadoop/workers
echo $DATANODE3 >>$HADOOP_HOME/etc/hadoop/workers

# /opt/hadoop/bin/hadoop namenode –format

# ssh-copy-id -i ~/.ssh/id_rsa.pub hoanghai@DATANODE1:/home/hoanghai/.ssh
# ssh-copy-id -i ~/.ssh/id_rsa.pub hoanghai@DATANODE2:/home/hoanghai/.ssh
# ssh-copy-id -i ~/.ssh/id_rsa.pub hoanghai@DATANODE3:/home/hoanghai/.ssh