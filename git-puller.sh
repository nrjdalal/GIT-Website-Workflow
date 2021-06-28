read -p "SSH Username > " USERNAME
read -p "SSH Hostname > " HOSTNAME
read -p "SSH Port > " PORT
read -p "Work Directory > " WORKDIR
read -p "Master Repository > " MASTER

cat >server.sh <<GIT
#!/bin/sh
mkdir -p $WORKDIR
cd $WORKDIR
git init
git pull $MASTER
exit
GIT

ssh -p $PORT $USERNAME@$HOSTNAME "bash -s" <server.sh
rm server.sh
