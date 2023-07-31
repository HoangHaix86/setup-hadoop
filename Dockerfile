FROM hadoop-base:v1

# RUN apt update && apt install -y wget python3-lxml ssh

# COPY ./hadoop-3.3.6.tar.gz ~/
# COPY ./jdk-8u202-linux-x64.tar.gz ~/

# RUN apt install  openjdk-8-jdk
# RUN wget https://raw.githubusercontent.com/HoangHaix86/setup-hadoop/main/xmleditor.py && \
#     cp ./xmleditor.py /usr/local/bin/xmleditor.py && \
#     chmod a+x /usr/local/bin/xmleditor.py

# RUN chmod -R a+rwx /opt

# RUN wget "https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz" && \
#     tar -xvzf hadoop-3.3.6.tar.gz && \
#     sudo mv -f hadoop-3.3.6 /opt/hadoop && \
#     echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >>/opt/hadoop/etc/hadoop/hadoop-env.sh
