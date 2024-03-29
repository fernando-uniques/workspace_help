# use example: sudo ./host.sh <<domain name>> <<folder name>>

if [ "$EUID" -ne 0]
    then echo "Please, execute as sudo."
    exit
fi

if [ -z "$1" ]
    then echo "Please, specify the host name." 
    exit
fi

test_host_path="/var/www/test_host"
host_name="$1.test"
admin_email="fernandorochaworld@gmail.com"

#subfolder
if [ -z "$2" ]; then
  host_path="$test_host_path/$1"
else
  host_path="$test_host_path/$2/$1"
fi

mkdir -p $test_host_path

echo "Creating host $host_name"

mkdir -p $host_path
chown -R $USER:$USER $host_path
chmod -R 777 $host_path

if [ ! -f "$host_path/index.php"]; then
  echo "<html>
    <head>
      <title>Welcome to $host_name!</title>
    </head>
    <body>
      <h1>Success! On <?=date('Y-m-d H:i:s');?></h1>
      <h2>www.$host_name VirtualHost is working!</h2>
      <?php phpinfo(); ?>
    </body>
  </html>" > $host_path/index.php
fi

echo "<VirtualHost *:80>
    ServerAdmin $admin_email
    ServerName $host_name
    ServerAlias www.$host_name *.$host_name
    DocumentRoot $host_path
        <Directory "$host_path">
#           AllowOverride All
                Options Indexes FollowSymLinks MultiViews
                AllowOverride all
                Order allow,deny
                allow from all
        </Directory>
</VirtualHost>" > /etc/apache2/sites-available/$1.conf

chown www-data /etc/apache2/sites-available/$1.conf

echo "Enabling host"
a2ensite $1
service apache2 reload

echo "VirtualHost $1 created"

echo "Creating routes"
echo "
127.0.0.1       $host_name
127.0.0.1       www.$host_name
" >> /etc/hosts

echo "done"
