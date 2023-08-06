FROM ubuntu:22.04

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_INSTALL=$HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
ENV HADOOP_OPTS=-Djava.library.path=$HADOOP_HOME/lib/native

ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root

COPY ./xmleditor.py /usr/local/bin/xmleditor.py
RUN chmod a+x /usr/local/bin/xmleditor.py
COPY ./get-authorized.py /get-authorized.py

RUN apt-get update \
    && apt-get install -y git python3-lxml openjdk-8-jdk openssh-server wget iputils-ping dnsutils python3-pip curl sshpass \
    && pip3 install Flask \
    && wget "https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz" \
    && tar -xvzf hadoop-3.3.6.tar.gz \
    && mv hadoop-3.3.6 /opt/hadoop \
    && echo "export JAVA_HOME=$JAVA_HOME" >>/opt/hadoop/etc/hadoop/hadoop-env.sh \
    && rm hadoop-3.3.6.tar.gz

