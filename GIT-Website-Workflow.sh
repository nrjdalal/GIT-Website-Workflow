#!/bin/sh

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
#to read PORT
read -p "SSH Port is set to 18765 (usually it is 22), change port? " yesNo
while true
do
case $yesNo in
    [yY]* ) read -p "SSH Port > " PORT; break;;
    [nN]* ) PORT="18765"; echo "SSH Port > $PORT"; break;;
    * ) read -p "Please answer yes or no: " yesNo; continue;;
esac
done
#end read PORT

echo
read -p "Domain (without www) > " DOMAIN
#to read WORKDIR
read -p "Work Directory is set to home/$USERNAME/www/$DOMAIN/public_html, change work directory? " yesNo
while true
do
case $yesNo in
    [yY]* ) read -p "Work Directory > " WORKDIR; break;;
    [nN]* ) WORKDIR="home/$USERNAME/www/$DOMAIN/public_html"; echo "Work Directory > $WORKDIR"; break;;
    * ) read -p "Please answer yes or no: " yesNo; continue;;
esac
done
#end read WORKDIR

cat > server.sh << GITSERVER
#!/bin/sh
mkdir -p /$WORKDIR
cd /$WORKDIR
mkdir .bareGit
cd .bareGit
git init --bare
cd hooks
cat > post-receive << HOOK
#!/bin/sh
git --work-tree=/$WORKDIR --git-dir=/$WORKDIR/.bareGit checkout -f
HOOK
chmod +x post-receive
exit
GITSERVER

echo
ssh -p $PORT $USERNAME@$HOSTNAME "bash -s" < server.sh
rm server.sh

git init
echo
read -p "Git UserName > " GITNAME
git config user.name "$GITNAME"
read -p "Git UserEmail > " GITEMAIL
git config user.email "$GITEMAIL"
read -p "Git RemoteName > " REMOTENAME
git remote add $REMOTENAME ssh://$USERNAME@$HOSTNAME:$PORT/$WORKDIR/.bareGit

echo
git pull $REMOTENAME master

read -p "Process complete... Press enter to exit! " EXIT