if [ "$EUID" -ne 0]
  then echo "Favor, execute este script com sudo"
  exit
fi

if [ -z "$1" ]
        then echo "Use o nome do host como parametro" 
        exit
fi

echo "Criando host $1.com"

mkdir -p /var/www/$1.com
chown -R $USER:$USER /var/www/$1.com
chmod -R 777 /var/www/$1.com

echo "<html>
  <head>
    <title>Welcome to $1.com!</title>
  </head>
  <body>
    <h1>Success!  The $1.com virtual host is working!</h1>
  </body>
</html>" > /var/www/$1.com/index.html


echo "<VirtualHost *:80>
    ServerAdmin fernandorochaworld@gmail.com
    ServerName $1.com
    ServerAlias www.$1.com
    DocumentRoot /var/www/$1.com
        <Directory "/var/www/$1.com">
#           AllowOverride All
                Options Indexes FollowSymLinks MultiViews
                AllowOverride all
                Order allow,deny
                allow from all
        </Directory>
</VirtualHost>" > /etc/apache2/sites-available/$1.conf

chown www-data /etc/apache2/sites-available/$1.conf

echo "Ativando host"
a2ensite $1
service apache2 reload

echo "Vhost $1 criado"

echo "Criando Rotas"
echo "
127.0.0.1       $1.com
127.0.0.1       www.$1.com
" >> /etc/hosts

echo "pronto"
