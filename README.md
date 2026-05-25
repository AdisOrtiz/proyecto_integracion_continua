# Integración Continua con Docker

## Objetivo
Crear dos contenedores Docker conectados entre sí.

## Comandos utilizados

docker pull ubuntu

docker network create red-integracion

docker run -dit --name contenedor1 --network red-integracion ubuntu

docker run -dit --name contenedor2 --network red-integracion ubuntu

docker ps

## Validación

Se verificó la comunicación mediante:

ping contenedor2