echo
echo "----------------------------"
echo " Creator - Neeraj Dalal     "
echo " Email - admin@nrjdalal.com "
echo "----------------------------"

echo
echo "A simple script to set up an efficient development workflow using Git to manage a live website"
echo "For more information visit - https://nrjdalal.com/GIT-Website-Workflow"

echo
echo "Prerequisite - Git must be installed on both local and remote machine/ web server"
echo "To download Git visit - https://git-scm.com/downloads"

echo
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

echo
ssh -p $PORT $USERNAME@$HOSTNAME "bash -s" <server.sh
rm server.sh
