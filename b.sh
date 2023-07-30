apt-get update
apt-get install -y wget ssh
apt-get install -y openjdk-8-jdk
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz && \
tar -xvzf hadoop-3.3.6.tar.gz && \
mv hadoop-3.3.6 /opt/hadoop


echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

echo "export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin" >> /etc/profile.d/env.sh
source /etc/profile

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
chmod 0600 ~/.ssh/authorized_keys && \
/etc/init.d/ssh start

echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/profile.d/env.sh
echo "export HADOOP_HOME=/opt/hadoop" >> /etc/profile.d/env.sh
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME" >> /etc/profile.d/env.sh
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME" >> /etc/profile.d/env.sh
echo "export HADOOP_HDFS_HOME=$HADOOP_HOME" >> /etc/profile.d/env.sh
echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> /etc/profile.d/env.sh
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME" >> /etc/profile.d/env.sh
echo "export HADOOP_YARN_HOME=$HADOOP_HOME" >> /etc/profile.d/env.sh

echo "export HDFS_NAMENODE_USER=root" >> /etc/profile.d/env.sh
echo "export HDFS_DATANODE_USER=root" >> /etc/profile.d/env.sh
echo "export HDFS_SECONDARYNAMENODE_USER=root" >> /etc/profile.d/env.sh
echo "export YARN_RESOURCEMANAGER_USER=root" >> /etc/profile.d/env.sh
echo "export YARN_NODEMANAGER_USER=root" >> /etc/profile.d/env.sh

source /etc/profile
bin/hdfs namenode -format
sbin/start-dfs.sh

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native 
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HADOOP_YARN_HOME=$HADOOP_HOME
export HADOOP_LOG_DIR=$HADOOP_HOME/logs
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"

export HDFS_NAMENODE_USER="root"
export HDFS_DATANODE_USER="root"
export HDFS_SECONDARYNAMENODE_USER="root"
export YARN_RESOURCEMANAGER_USER="root"
export YARN_NODEMANAGER_USER="root"  
