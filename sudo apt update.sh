sudo apt update
sudo apt install openjdk-8-jdk -y
sudo apt install openssh-server openssh-client -y
sudo apt install -y git python3-lxml
sudo chmod -R a+rwx /opt

echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' | tee -a ~/.bashrc &&
echo 'export HADOOP_HOME=/opt/hadoop' | tee -a ~/.bashrc &&
echo 'export HADOOP_INSTALL=$HADOOP_HOME' | tee -a ~/.bashrc &&
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' | tee -a ~/.bashrc &&
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' | tee -a ~/.bashrc &&
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' | tee -a ~/.bashrc &&
echo 'export HADOOP_YARN_HOME=$HADOOP_HOME' | tee -a ~/.bashrc &&
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' | tee -a ~/.bashrc &&
echo 'export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin' | tee -a ~/.bashrc &&
echo 'export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"' | tee -a ~/.bashrc &&
source ~/.bashrc

wget https://raw.githubusercontent.com/HoangHaix86/setup-hadoop/main/xmleditor.py
sudo mv ./xmleditor.py /usr/local/bin/xmleditor.py
sudo chmod 777 /usr/local/bin/xmleditor.py

wget "https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz" &&
tar -xvzf hadoop-3.3.6.tar.gz &&
sudo mv -f hadoop-3.3.6 /opt/hadoop &&
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" | tee -a /opt/hadoop/etc/hadoop/hadoop-env.sh

# ________________________________________
sudo hostnamectl set-hostname master && reboot
sudo hostnamectl set-hostname slave-1 && reboot
sudo hostnamectl set-hostname slave-2 && reboot
sudo hostnamectl set-hostname slave-3 && reboot


echo "192.168.131.154 master" | sudo tee -a /etc/hosts &&
echo "192.168.131.155 slave-1" | sudo tee -a /etc/hosts &&
echo "192.168.131.156 slave-2" | sudo tee -a /etc/hosts

# ssh
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa &&
cat ~/.ssh/id_rsa.pub >>~/.ssh/authorized_keys

# copy ssh key
ssh-copy-id hoanghai@slave-1


sudo mkdir -p /opt/hadoop/data/hdfs/{namenode,datanode} &&
sudo chmod -R 777 /opt

# core-site.xml
xmleditor.py -a -p /opt/hadoop/etc/hadoop/core-site.xml -n fs.defaultFS -v hdfs://master:9000

# hdfs-site.xml
xmleditor.py -a -p /opt/hadoop/etc/hadoop/hdfs-site.xml -n dfs.replication -v 2
xmleditor.py -a -p /opt/hadoop/etc/hadoop/hdfs-site.xml -n dfs.name.dir -v file:///opt/hadoop/data/hdfs/namenode
xmleditor.py -a -p /opt/hadoop/etc/hadoop/hdfs-site.xml -n dfs.data.dir -v file:///opt/hadoop/data/hdfs/datanode

# yarn-site.xml
xmleditor.py -a -p /opt/hadoop/etc/hadoop/yarn-site.xml -n yarn.nodemanager.aux-services -v mapreduce_shuffle
xmleditor.py -a -p /opt/hadoop/etc/hadoop/yarn-site.xml -n yarn.nodemanager.aux-services.mapreduce.shuffle.class -v org.apache.hadoop.mapred.ShuffleHandler
xmleditor.py -a -p /opt/hadoop/etc/hadoop/yarn-site.xml -n yarn.resourcemanager.hostname -v master

# mapred-site.xml
# xmleditor.py -a -p /opt/hadoop/etc/hadoop/mapred-site.xml -n mapreduce.framework.name -v yarn
# xmleditor.py -a -p /opt/hadoop/etc/hadoop/mapred-site.xml -n mapreduce.jobtracker.address -v master:54311

rm /opt/hadoop/etc/hadoop/workers &&
echo -e "slave-1\nslave-2" >/opt/hadoop/etc/hadoop/workers  
    
scp /opt/hadoop/etc/hadoop/* hoanghai@slave-1:/opt/hadoop/etc/hadoop/
scp /opt/hadoop/etc/hadoop/* hoanghai@slave-2:/opt/hadoop/etc/hadoop/

hdfs namenode -format
