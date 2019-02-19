#if [ "$EUID" -ne 0]
#  then echo "Please, execute as sudo."
#  exit
#fi

ws="/var/www/workspace_help"

cd $ws
msg="run ok - `date`"

./gitup.sh
echo "$msg" >> ./log_timer.log
echo "done";
