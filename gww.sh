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
read -p "SSH Port is set to 22, change port? " yesNo
while true; do
  case $yesNo in
  [yY]*)
    read -p "SSH Port > " PORT
    break
    ;;
  [nN]*)
    PORT="22"
    echo "SSH Port > $PORT"
    break
    ;;
  *)
    read -p "Please answer yes or no: " yesNo
    continue
    ;;
  esac
done
#end read PORT

echo
read -p "Work Directory > " WORKDIR

cat >server.sh <<GITSERVER
#!/bin/sh
mkdir -p $WORKDIR
cd $WORKDIR
mkdir .bareGit
cd .bareGit
git init --bare
cd hooks
cat > post-receive << HOOK
#!/bin/sh
git --work-tree=$WORKDIR --git-dir=$WORKDIR/.bareGit checkout -f
HOOK
chmod +x post-receive
exit
GITSERVER

echo
ssh -p $PORT $USERNAME@$HOSTNAME "bash -s" <server.sh
rm server.sh

echo
echo "To add remote, please specify remote name as -"
echo "$(tput setaf 3)REMOTENAME=$(tput sgr0)"
echo
echo "After that run -"
echo "$(tput setaf 6)git remote add \$REMOTENAME ssh://$USERNAME@$HOSTNAME:$PORT/$WORKDIR/.bareGit$(tput sgr0)"
echo
