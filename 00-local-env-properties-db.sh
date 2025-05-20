#!/bin/bash

echo "===ORACLE.FIAP.COM.BR:1521/ORCL==="

echo "Digite seu username Oracle: "
read username

echo "Digite sua senha Oracle: "
read pass


cat > env.properties <<EOF
DB_DATABASE=oracle.fiap.com.br:1521:ORCL
DB_USER=$username
DB_PASSWORD=$pass
EOF

