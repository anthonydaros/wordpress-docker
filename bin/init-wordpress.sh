#!/bin/bash

# Script de inicialização automática do WordPress
# Executa na inicialização do container LiteSpeed

echo "=== Iniciando configuração automática do WordPress ==="

# Aguardar MySQL estar pronto
echo "Aguardando MySQL ficar disponível..."
until mysql -h mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1" > /dev/null 2>&1; do
    echo "MySQL ainda não está pronto, aguardando..."
    sleep 5
done

echo "MySQL está pronto!"

# Verificar se o domínio já existe
if [ ! -d "/var/www/vhosts/${DOMAIN}" ]; then
    echo "Criando domínio: ${DOMAIN}"
    domainctl.sh --add ${DOMAIN}
    
    echo "Configurando database para: ${DOMAIN}"
    database.sh --domain ${DOMAIN} --user ${MYSQL_USER} --password ${MYSQL_PASSWORD} --database ${MYSQL_DATABASE}
    
    echo "Instalando WordPress para: ${DOMAIN}"
    appinstallctl.sh --app wordpress --domain ${DOMAIN}
    
    echo "WordPress instalado com sucesso!"
else
    echo "Domínio ${DOMAIN} já existe, pulando configuração inicial"
fi

echo "=== Configuração concluída ==="