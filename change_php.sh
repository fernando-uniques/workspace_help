# Exemplo: sudo ./change_php.sh 5.6 7.2
if [ "$EUID" -ne 0]
    then echo "Favor, execute este script com sudo"
    exit
fi

if [ -z "$1" ]
    then echo "Informe a versão atual do PHP." 
    exit
fi

if [ -z "$2" ]
    then echo "Informe a versão desejada do PHP." 
    exit
fi

a2dismod php$1 ; a2enmod php$2
update-alternatives --set php /usr/bin/php$2
service apache2 restart

echo "pronto"
