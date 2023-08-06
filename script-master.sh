# setup ssh
echo "PermitRootLogin yes" | tee -a /etc/ssh/sshd_config \
&& service ssh start

# setup hadoop
mkdir -p $HADOOP_HOME/hdfs/namenode \
&& xmleditor.py -a -p /opt/hadoop/etc/hadoop/core-site.xml -n fs.default.name -v hdfs://master:9000 \
&& xmleditor.py -a -p /opt/hadoop/etc/hadoop/hdfs-site.xml -n dfs.replication -v 1 \
&& xmleditor.py -a -p /opt/hadoop/etc/hadoop/hdfs-site.xml -n dfs.namenode.name.dir -v /opt/hadoop/hdfs/namenode \
&& xmleditor.py -a -p /opt/hadoop/etc/hadoop/hdfs-site.xml -n dfs.datanode.data.dir -v /opt/hadoop/hdfs/datanode \
&& xmleditor.py -a -p /opt/hadoop/etc/hadoop/mapred-site.xml -n mapreduce.framework.name -v yarn \
&& xmleditor.py -a -p /opt/hadoop/etc/hadoop/mapred-site.xml -n yarn.app.mapreduce.am.env -v HADOOP_MAPRED_HOME=\$HADOOP_HOME \
&& xmleditor.py -a -p /opt/hadoop/etc/hadoop/mapred-site.xml -n mapreduce.map.env -v HADOOP_MAPRED_HOME=\$HADOOP_HOME \
&& xmleditor.py -a -p /opt/hadoop/etc/hadoop/mapred-site.xml -n mapreduce.reduce.env -v HADOOP_MAPRED_HOME=\$HADOOP_HOME \
&& xmleditor.py -a -p /opt/hadoop/etc/hadoop/yarn-site.xml -n yarn.acl.enable -v 0 \
&& xmleditor.py -a -p /opt/hadoop/etc/hadoop/yarn-site.xml -n yarn.resourcemanager.hostname -v master \
&& xmleditor.py -a -p /opt/hadoop/etc/hadoop/yarn-site.xml -n yarn.nodemanager.aux-services -v mapreduce_shuffle

# genarate ssh key
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
&& cat ~/.ssh/id_rsa.pub >>~/.ssh/authorized_keys \
&& chmod 600 ~/.ssh/authorized_keys


# add workers
rm /opt/hadoop/etc/hadoop/workers \
&& echo "slave-1" >/opt/hadoop/etc/hadoop/workers \
&& echo "slave-2" >>/opt/hadoop/etc/hadoop/workers

# add hosts
echo "$(dig +short master) master" >> /etc/hosts \
&& echo "$(dig +short slave-1) slave-1" >> /etc/hosts \
&& echo "$(dig +short slave-2) slave-2" >> /etc/hosts

# change password
echo "root:root" | chpasswd

# copy ssh key
sshpass -p "root" ssh-copy-id -o StrictHostKeyChecking=no slave-1
sshpass -p "root" ssh-copy-id -o StrictHostKeyChecking=no slave-2

# format namenode
hdfs namenode -format

# start hadoop
start-dfs.sh