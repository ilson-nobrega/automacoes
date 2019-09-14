#!/bin/bash

if [ "$(whoami)" != "root" ]; then
	echo "Privilégios de administrador são obrigatórios. Usar sudo."
	exit 2
fi

current_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
hosts_path="/etc/hosts"
vhosts_path="/etc/apache2/sites-available/"
vhost_skeleton_path="$current_directory/vhost.skeleton.conf"
web_root="/var/www/"


site_url=0
relative_doc_root=0

while getopts ":u:d:" o; do
	case "${o}" in
		u)
			site_url=${OPTARG}
			;;
		d)
			relative_doc_root=${OPTARG}
			;;
	esac
done

if [ $site_url == 0 ]; then
	read -p "Adicione a URL desejada: " site_url
fi

if [ $relative_doc_root == 0 ]; then
	read -p "Path da aplicação: $web_root_path" relative_doc_root
fi

absolute_doc_root=$web_root$relative_doc_root

if [ ! -d "$absolute_doc_root" ]; then

	`mkdir "$absolute_doc_root/"`
	`chown -R $SUDO_USER:staff "$absolute_doc_root/"`

	indexfile="$absolute_doc_root/index.html"
	`touch "$indexfile"`
	echo "<html><head></head><body>Olá Mundo!</body></html>" >> "$indexfile"

	echo "Created directory $absolute_doc_root/"
fi

vhost=`cat "$vhost_skeleton_path"`
vhost=${vhost//@site_url@/$site_url}
vhost=${vhost//@site_docroot@/$absolute_doc_root}

`touch $vhosts_path$site_url.conf`
echo "$vhost" > "$vhosts_path$site_url.conf"
echo "Vhosts Atualizados"

echo 127.0.0.1    $site_url >> $hosts_path
echo "Arquivo hosts alterado"

echo "Ativando site no Apache..."
echo `a2ensite $site_url`

echo "Criando diretórios de logs do apache..."
echo `mkdir /etc/apache2/logs`

echo "Reiniciando Apache..."
echo `/etc/init.d/apache2 restart`

echo "Processo concluído, acessar: http://$site_url"

exit 0