#if [ "$EUID" -ne 0]
#  then echo "Please, execute as sudo."
#  exit
#fi

ws=/var/www/workspace_help
cd $ws
msg="`date` - auto_test - no error found"

# update
git pull

#echo $msg >> ./log.log
sed -i "1i$msg" ./log.log
git add log.log
echo "log.log criado e adicionado";

git commit -m "$msg"
echo "commited";

git push
echo "pushed/done";
