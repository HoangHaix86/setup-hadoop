# BASE
wget https://raw.githubusercontent.com/HoangHaix86/setup-hadoop/main/xmleditor.py
sudo cp ./xmleditor.py /usr/local/bin/xmleditor.py
sudo chmod a+x /usr/local/bin/xmleditor.py

sudo chmod -R a+rwx /opt

wget "https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz" &&
tar -xvzf hadoop-3.3.6.tar.gz &&
sudo mv -f hadoop-3.3.6 /opt/hadoop &&
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >>/opt/hadoop/etc/hadoop/hadoop-env.sh

sudo apt install -y openssh-server openssh-client python3-lxml openjdk-8-jdk git

# setup hostname

sudo hostnamectl set-hostname master && reboot
sudo hostnamectl set-hostname slave-1 && reboot
sudo hostnamectl set-hostname slave-2 && reboot
sudo hostnamectl set-hostname slave-3 && reboot

# ssh
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >>~/.ssh/authorized_keys
sudo chmod 0600 ~/.ssh/authorized_keys

# copy ssh key
ssh-copy-id -i ~/.ssh/id_rsa.pub hoanghai@master
ssh-copy-id -i ~/.ssh/id_rsa.pub hoanghai@slave-1
ssh-copy-id -i ~/.ssh/id_rsa.pub hoanghai@slave-2
ssh-copy-id -i ~/.ssh/id_rsa.pub hoanghai@slave-3