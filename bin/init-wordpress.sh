#!/bin/bash

# Script de inicialização automática do WordPress
# Executa na inicialização do container LiteSpeed

echo "=== Iniciando configuração automática do WordPress ==="

# Aguardar MySQL estar pronto
echo "Aguardando MySQL ficar disponível..."
COUNTER=0
MAX_ATTEMPTS=20
until mysql -h mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1" > /dev/null 2>&1; do
    echo "MySQL ainda não está pronto, aguardando... (tentativa $COUNTER/$MAX_ATTEMPTS)"
    COUNTER=$((COUNTER+1))
    if [ $COUNTER -eq $MAX_ATTEMPTS ]; then
        echo "MySQL timeout - continuando sem setup automático"
        exit 1
    fi
    sleep 5
done

echo "MySQL está pronto!"

# Verificar se o domínio já existe
if [ ! -d "/var/www/vhosts/${DOMAIN}" ]; then
    echo "Criando domínio: ${DOMAIN}"
    domainctl.sh --add ${DOMAIN}
    
    echo "Configurando database para: ${DOMAIN}"
    bash /usr/local/bin/appinstallctl.sh --app wordpress --domain ${DOMAIN}
    
    echo "WordPress instalado com sucesso!"
else
    echo "Domínio ${DOMAIN} já existe, pulando configuração inicial"
fi

echo "=== Configuração concluída ==="