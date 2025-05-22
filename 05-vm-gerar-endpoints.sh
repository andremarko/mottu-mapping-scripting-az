#!/bin/bash

IP_PUBLIC=$(curl -s https://checkip.amazonaws.com)

if [ -z "$IP_PUBLIC" ]; then
  echo "Erro: não consegui detectar o IP público da máquina."
  exit 1
fi

PORT=8080
BASE_URL="http://${IP_PUBLIC}:${PORT}/api"

echo "Gerando lista de URLs com IP público da VM ($IP_PUBLIC) e porta $PORT..."
echo ""

cat <<EOF > endpoints_completo.txt
# Endpoints MotoYard
GET    $BASE_URL/motoyards
POST   $BASE_URL/motoyards
GET    $BASE_URL/motoyards/{id}
PUT    $BASE_URL/motoyards/{id}
DELETE $BASE_URL/motoyards/{id}

# Endpoints Sector
GET    $BASE_URL/sectors
POST   $BASE_URL/sectors
GET    $BASE_URL/sectors/{id}
PUT    $BASE_URL/sectors/{id}
DELETE $BASE_URL/sectors/{id}

# Endpoints Model
GET    $BASE_URL/models
POST   $BASE_URL/models
GET    $BASE_URL/models/{id}
PUT    $BASE_URL/models/{id}
DELETE $BASE_URL/models/{id}

# Endpoints Moto
GET    $BASE_URL/motos
POST   $BASE_URL/motos
GET    $BASE_URL/motos/{id}
PUT    $BASE_URL/motos/{id}
DELETE $BASE_URL/motos/{id}
EOF

echo "Arquivo 'endpoints_completo.txt' gerado com sucesso. Confira o conteúdo:"
cat endpoints_completo.txt
