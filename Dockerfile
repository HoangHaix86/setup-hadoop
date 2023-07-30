FROM ubuntu:jammy

RUN apt update && apt install -y wget ssh openjdk-8-jdk iputils-ping nano openssh-server

RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz && \
    tar -xvzf hadoop-3.3.6.tar.gz && \
    mv hadoop-3.3.6 /opt/hadoop && \
    rm hadoop-3.3.6.tar.gz  && \
    echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /opt/hadoop/etc/hadoop/hadoop-env.sh

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

ADD ./configs/*.xml /opt/hadoop/etc/hadoop/

ADD ./configs/ssh_config /root/.ssh/config

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /root/.bashrc && \
    echo "export HADOOP_HOME=/opt/hadoop" >> /root/.bashrc && \
    echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >> /root/.bashrc && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bashrc && \
    echo "export HADOOP_CLASSPATH=\$JAVA_HOME/lib/tools.jar" >> /root/.bashrc && \
    echo "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >> /root/.bashrc && \
    echo "export HDFS_NAMENODE_USER=root" >> /root/.bashrc && \
    echo "export HDFS_DATANODE_USER=root" >> /root/.bashrc && \
    echo "export HDFS_SECONDARYNAMENODE_USER=root" >> /root/.bashrc && \
    echo "export YARN_RESOURCEMANAGER_USER=root" >> /root/.bashrc && \
    echo "export YARN_HOME=\$HADOOP_HOME" >> /root/.bashrc && \
    echo "export YARN_NODEMANAGER_USER=root" >> /root/.bashrc 
