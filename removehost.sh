if [ "$EUID" -ne 0]
    then echo "Please, execute as sudo."
    exit
fi

if [ -z "$1" ]
    then echo "Please, specify the host name." 
    exit
fi

mkdir -p /var/www/com
host_path="/var/www/com/$1"
host_name="$1.com"

echo "Disabling host"
#a2ensite $1
a2dissite $1
service apache2 reload

echo "Removing host folder $host_name"
rm -rf $host_path

rm /etc/apache2/sites-available/$1.conf
echo "VirtualHost $1 removed"

#todo remove host in /etc/hosts
echo "done"
