#!/bin/bash

# https://github.com/HoangHaix86/setup-hadoop.git
# rm -rf setup-hadoop && git clone https://github.com/HoangHaix86/setup-hadoop.git && chmod +x ./setup-hadoop/script.sh && sudo ./setup-hadoop/script.sh

# 1
sudo apt install ssh -y

# 2
rm ~/.ssh/id_rsa
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >>~/.ssh/authorized_keys
sudo chmod 0600 ~/.ssh/authorized_keys

ssh localhost

sudo apt install openjdk-8-jdk

sudo chmod 777 /opt

# install hadoop
wget "https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz" &&
tar -xvzf hadoop-3.3.6.tar.gz &&
sudo mv -f hadoop-3.3.6 /opt/hadoop &&
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >>/opt/hadoop/etc/hadoop/hadoop-env.sh

echo "export HADOOP_HOME=/opt/hadoop" | sudo tee -a /etc/environment
echo "export HADOOP_INSTALL=\$HADOOP_HOME" | sudo tee -a /etc/environment
echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" | sudo tee -a /etc/environment
echo "export HADOOP_COMMON_HOME=\$HADOOP_HOME" | sudo tee -a /etc/environment
echo "export HADOOP_HDFS_HOME=\$HADOOP_HOME" | sudo tee -a /etc/environment
echo "export YARN_HOME=\$HADOOP_HOME" | sudo tee -a /etc/environment
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native" | sudo tee -a /etc/environment
echo "export PATH=$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin" | sudo tee -a /etc/environment
echo "export HADOOP_OPTS=-Djava.library.path=\$HADOOP_HOME/lib/native" | sudo tee -a /etc/environment
source /etc/environment

IP_MASTER="192.168.131.154"
IP_SLAVE_1="192.168.131.155"
# IP_SLAVE_2="192.168.131.140"
# IP_SLAVE_3="192.168.131.153"

echo "$IP_MASTER master" | sudo tee -a /etc/hosts
echo "$IP_SLAVE_1 slave-1" | sudo tee -a /etc/hosts
# echo "$IP_SLAVE_2 slave-2" | sudo tee -a /etc/hosts
# echo "$IP_SLAVE_3 slave-3" | sudo tee -a /etc/hosts

sudo hostnamectl set-hostname master && reboot
sudo hostnamectl set-hostname slave-1 && reboot

# ssh-copy-id -i ~/.ssh/id_rsa.pub datanode1
# ssh-copy-id -i ~/.ssh/id_rsa.pub datanode2
# ssh-copy-id -i ~/.ssh/id_rsa.pub datanode3


# # core-site.xml
xmleditor.py -a -p /opt/hadoop/etc/hadoop/core-site.xml -n fs.defaultFS -v hdfs://master:9000

# # hdfs-site.xml
xmleditor.py -a -p /opt/hadoop/etc/hadoop/hdfs-site.xml -n dfs.replication -v 2
xmleditor.py -a -p /opt/hadoop/etc/hadoop/hdfs-site.xml -n dfs.name.dir -v /opt/hadoop/data/namenode
xmleditor.py -a -p /opt/hadoop/etc/hadoop/hdfs-site.xml -n dfs.data.dir -v /opt/hadoop/data/datanode

# # yarn-site.xml
xmleditor.py -a -p /opt/hadoop/etc/hadoop/yarn-site.xml -n yarn.resourcemanager.hostname -v master
# xmleditor.py -a -p /opt/hadoop/etc/hadoop/yarn-site.xml -n yarn.nodemanager.aux-services -v mapreduce_shuffle
# xmleditor.py -a -p /opt/hadoop/etc/hadoop/yarn-site.xml -n yarn.nodemanager.aux-services.mapreduce.shuffle.class -v org.apache.hadoop.mapred.ShuffleHandler

# # mapred-site.xml
xmleditor.py -a -p /opt/hadoop/etc/hadoop/mapred-site.xml -n mapred.job.tracker -v master:9001

sudo mkdir -p /opt/hadoop/data/namenode
sudo mkdir -p /opt/hadoop/data/datanode

# master
echo "slave-1" >/opt/hadoop/etc/hadoop/workers
# echo "slave-2" >/opt/hadoop/etc/hadoop/workers
# echo "slave-3" >/opt/hadoop/etc/hadoop/workers

# slave






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



# # master
# # echo master >$HADOOP_HOME/etc/hadoop/masters

# # workers
# # echo slave_1 >$HADOOP_HOME/etc/hadoop/workers
