# Lab install Hadoop

## Install Hadoop Local (Standalone) Mode

[Setup Standalone Mode](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Standalone_Operation)

1. Install Java

    ```bash
    apt-get update && \
        apt-get install -y wget ssh pdsh git openjdk-18-jdk && \
        export JAVA_HOME=/usr/lib/jvm/java-18-openjdk-amd64
    ```

2. Install Hadoop

    ```bash
    wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.5/hadoop-3.3.5.tar.gz && \
        tar -xvzf hadoop-3.3.5.tar.gz && \
        mv hadoop-3.3.5 /opt/hadoop -f && \
        export HADOOP_HOME=/opt/hadoop && \
        echo 'export JAVA_HOME=$JAVA_HOME' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
        echo PATH=$PATH:$HADOOP_HOME/bin
    ```

3. View info

    ```bash
    $HADOOP_HOME/bin/hadoop verison
    ```

    Result

    ```bash
    root@b6290ca603e4:~# $HADOOP_HOME/bin/hadoop version 
    Hadoop 3.3.5
    Source code repository https://github.com/apache/hadoop.git -r 706d88266abcee09ed78fbaa0ad5f74d818ab0e9
    Compiled by stevel on 2023-03-15T15:56Z
    Compiled with protoc 3.7.1
    From source with checksum 6bbd9afcf4838a0eb12a5f189e9bd7
    This command was run using /opt/hadoop/share/hadoop/common/hadoop-common-3.3.5.jar
    ```

## Install Hadoop Pseudo-Distributed Mode

[Pseudo-Distributed Mode](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Pseudo-Distributed_Operation)

1. Install package

    ```bash
    apt update && apt install -y wget ssh openjdk-8-jdk
    ```

2. Install Hadoop

    ```bash
    wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz && \
        tar -xvzf hadoop-3.3.6.tar.gz && \
        mv hadoop-3.3.6 /opt/hadoop && \
        rm hadoop-3.3.6.tar.gz  && \
        echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /opt/hadoop/etc/hadoop/hadoop-env.sh

    ```

3. Setup SSH

    ```bash
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
        cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
        chmod 0600 ~/.ssh/authorized_keys
    ```

4. Export enviroment variable

    ```bash
    echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /root/.bashrc && \
    echo "export HADOOP_HOME=/opt/hadoop" >> /root/.bashrc && \
    echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >> /root/.bashrc && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bashrc && \
    echo "export HADOOP_CLASSPATH=\$JAVA_HOME/lib/tools.jar" >> /root/.bashrc && \
    echo "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >> /root/.bashrc && \
    echo "export HDFS_NAMENODE_USER=root" >> /root/.bashrc && \
    echo "export HDFS_DATANODE_USER=root" >> /root/.bashrc && \
    echo "export HDFS_SECONDARYNAMENODE_USER=root" >> /root/.bashrc && \
    echo "export YARN_RESOURCEMANAGER_USER=root" >> /root/.bashrc && \
    echo "export YARN_NODEMANAGER_USER=root" >> /root/.bashrc && \\
    source ~/.bashrc
    ```

5. Setting config Hadoop - core-site.xml

    ```xml
    <configuration>
        <property>
            <name>fs.defaultFS</name>
            <value>hdfs://localhost:9000</value>
        </property>
    </configuration>
    ```

6. Setting config Hadoop - hdfs-site.xml

    ```xml
    <configuration>
        <property>
            <name>dfs.replication</name>
            <value>1</value>
        </property>
    </configuration>
    ```

7. Setting config Hadoop - mapred-site.xml

    ```xml
    <configuration>
        <property>
            <name>mapreduce.framework.name</name>
            <value>yarn</value>
        </property>
        <property>
            <name>mapreduce.application.classpath</name>
            <value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
        </property>
        <property>
            <name>yarn.app.mapreduce.am.env</name>
            <value>HADOOP_MAPRED_HOME=${HADOOP_HOME}</value>
        </property>
        <property>
            <name>mapreduce.map.env</name>
            <value>HADOOP_MAPRED_HOME=${HADOOP_HOME}</value>
        </property>
        <property>
            <name>mapreduce.reduce.env</name>
            <value>HADOOP_MAPRED_HOME=${HADOOP_HOME}</value>
        </property>
    </configuration>
    ```

8. Setting config Hadoop - yarn-site.xml

    ```xml
    <configuration>
        <property>
            <name>yarn.nodemanager.aux-services</name>
            <value>mapreduce_shuffle</value>
        </property>
    </configuration>
    ```

9. Add JAVA_HOME into hadoop-env.sh

    ```bash
    ...
    export JAVA_HOME=
    ```

### Example

```bash
# start ssh
service ssh start

# format
hdfs namenode -format

# start hdfs, yarn
start-all.sh

# Make the HDFS directories required to execute MapReduce jobs
hdfs dfs -mkdir -p /user/<username>

# Copy the input files into the distributed filesystem
bin/hdfs dfs -mkdir input
bin/hdfs dfs -put etc/hadoop/*.xml input

# Run example WordCount
hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount input output

# Examine the output files: Copy the output files from the distributed filesystem to the local filesystem and examine them
hdfs dfs -get output output
cat output/*
```
