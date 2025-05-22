#!/bin/bash

IP=$(ip route get 8.8.8.8 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1)}')
if [ -z "$IP" ]; then
  echo "Erro: não consegui detectar o IP da máquina."
  exit 1
fi

PORT=8080
BASE_URL="http://${IP}:${PORT}/api"

echo "Gerando lista de URLs com IP da VM ($IP) e porta $PORT..."
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

