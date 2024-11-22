#!/bin/bash

RedisIP=35.175.178.150

git clone https://github.com/MariaCutipa/ProyectoFinally.git
git clone https://github.com/MariaCutipa/Angular.git


# Obtener la IP pública
IP=$(curl -s ifconfig.me)

# Archivo Angular a modificar
ANGULAR_FILE="Angular/src/app/services/entregables.service.ts"

# Reemplazar la IP en el archivo `entregables.service.ts`
if [[ -f $ANGULAR_FILE ]]; then
    sed -i "s|http://[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:4000|http://$IP:4000|g" "$ANGULAR_FILE"
else
    echo "Archivo $ANGULAR_FILE no encontrado."
    exit 1
fi

# Archivo docker-compose.yml
DOCKER_COMPOSE_FILE="ProyectoFinally/docker-compose.yml"

# Reemplazar la IP en el archivo `docker-compose.yml` para REDIS_HOST y MONGODB_URI
if [[ -f $DOCKER_COMPOSE_FILE ]]; then
    sed -i "s|REDIS_HOST=.*|REDIS_HOST=$RedisIP|g" "$DOCKER_COMPOSE_FILE"
    echo "Actualizada la IP en $DOCKER_COMPOSE_FILE"

    sed -i "s|MONGODB_URI=mongodb://.*|MONGODB_URI=mongodb://root:admin@$RedisIP/tecsup?authSource=admin|g" "$DOCKER_COMPOSE_FILE"

else
    echo "Archivo $DOCKER_COMPOSE_FILE no encontrado."
    exit 1
fi

mv ./ProyectoFinally/docker-compose.yml . 

docker-compose up -d
