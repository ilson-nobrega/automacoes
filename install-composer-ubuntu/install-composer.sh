#!/bin/bash

echo "Instalando e configurando o composer..."
echo `curl -sS http://getcomposer.org/installer | php -- --filename=composer`
echo `chmod a+x composer`
echo `sudo mv composer /usr/local/bin/composer`
echo "Concluído!"