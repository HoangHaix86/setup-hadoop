#!/bin/sh

# https://github.com/HoangHaix86/setup-hadoop.git
# git clone https://github.com/HoangHaix86/setup-hadoop.git && cd setup-hadoop && chmod +x script.sh && ./script.sh

IP_MASTER=""
IP_SLAVE_1=""
IP_SLAVE_2=""
IP_SLAVE_3=""

# Update vs upgrade
sudo apt-get update && sudo apt-get upgrade -y

# for setup
sudo apt install -y open-vm-tools-desktop

# Install openssh-server
sudo apt-get install -y openssh-server python3-lxml openjdk-8-jdk git wget

# ssh
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa &&
cat ~/.ssh/id_rsa.pub >>~/.ssh/authorized_keys &&
sudo chmod 0600 ~/.ssh/authorized_keys

# add xmleditor
sudo cp ./xmleditor.py /usr/local/bin/xmleditor.py &&
sudo chmod +x /usr/local/bin/xmleditor.py

sudo chmod -R a+rwx /opt

export HADOOP_VERSION=3.3.6
export HADOOP_HOME=/opt/hadoop
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=\$PATH:\$JAVA_HOME/bin

export HADOOP_LOG_DIR=\$HADOOP_HOME/logs
export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop
export PATH=\$PATH:\$HADOOP_HOME/bin
export PATH=\$PATH:\$HADOOP_HOME/sbin
export HADOOP_MAPRED_HOME=\$HADOOP_HOME
export HADOOP_COMMON_HOME=\$HADOOP_HOME
export HADOOP_HDFS_HOME=\$HADOOP_HOME
export YARN_HOME=\$HADOOP_HOME

echo "export HADOOP_VERSION=3.3.6" >>~/.bashrc
echo "export HADOOP_HOME=/opt/hadoop" >>~/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >>~/.bashrc
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >>~/.bashrc

echo "export HADOOP_LOG_DIR=\$HADOOP_HOME/logs" >>~/.bashrc
echo "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >>~/.bashrc
echo "export PATH=\$PATH:\$HADOOP_HOME/bin" >>~/.bashrc
echo "export PATH=\$PATH:\$HADOOP_HOME/sbin" >>~/.bashrc
echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" >>~/.bashrc
echo "export HADOOP_COMMON_HOME=\$HADOOP_HOME" >>~/.bashrc
echo "export HADOOP_HDFS_HOME=\$HADOOP_HOME" >>~/.bashrc
echo "export YARN_HOME=\$HADOOP_HOME" >>~/.bashrc

# install hadoop
URL="https://dlcdn.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz"
wget $URL &&
tar -xvzf hadoop-$HADOOP_VERSION.tar.gz &&
mv -f hadoop-$HADOOP_VERSION $HADOOP_HOME &&
rm hadoop-$HADOOP_VERSION.tar.gz &&
# add environment variables
echo "export JAVA_HOME=\$JAVA_HOME" >>$HADOOP_HOME/etc/hadoop/hadoop-env.sh

# add host
# echo "$IP_MASTER master" >>/etc/hosts &&
# echo "$IP_SLAVE_1 master" >>/etc/hosts &&
# echo "$IP_SLAVE_2 master" >>/etc/hosts &&
# echo "$IP_SLAVE_3 master" >>/etc/hosts &&

# config hadoop
# core-site.xml
xmleditor.py -a -p $HADOOP_HOME/etc/hadoop/core-site.xml -n fs.defaultFS -v hdfs://master:9000

# hdfs-site.xml
xmleditor.py -a -p $HADOOP_HOME/etc/hadoop/hdfs-site.xml -n dfs.replication -v 3
xmleditor.py -a -p $HADOOP_HOME/etc/hadoop/hdfs-site.xml -n dfs.namenode.name.dir -v file:///opt/hadoop/data/namenode
xmleditor.py -a -p $HADOOP_HOME/etc/hadoop/hdfs-site.xml -n dfs.datanode.data.dir -v file:///opt/hadoop/data/datanode

# yarn-site.xml
xmleditor.py -a -p $HADOOP_HOME/etc/hadoop/yarn-site.xml -n yarn.nodemanager.aux-services -v mapreduce_shuffle
xmleditor.py -a -p $HADOOP_HOME/etc/hadoop/yarn-site.xml -n yarn.nodemanager.aux-services.mapreduce.shuffle.class -v org.apache.hadoop.mapred.ShuffleHandler
xmleditor.py -a -p $HADOOP_HOME/etc/hadoop/yarn-site.xml -n yarn.resourcemanager.hostname -v master

# mapred-site.xml
xmleditor.py -a -p $HADOOP_HOME/etc/hadoop/mapred-site.xml -n mapreduce.framework.name -v yarn
xmleditor.py -a -p $HADOOP_HOME/etc/hadoop/mapred-site.xml -n mapreduce.jobtracker.address -v master:54311

sudo mkdir -p /opt/hadoop/data/namenode &&
    sudo mkdir -p /opt/hadoop/data/datanode

# master
# echo master >$HADOOP_HOME/etc/hadoop/masters

# workers
# echo slave_1 >$HADOOP_HOME/etc/hadoop/workers &&
