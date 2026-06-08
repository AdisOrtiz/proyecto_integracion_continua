# Integración Continua con Docker

## Objetivo

Implementar una solución de integración continua utilizando Docker y Jenkins, desplegando contenedores conectados a través de una red compartida y automatizando su validación mediante un pipeline.

---

## Estructura del Proyecto

```text
proyecto_integracion_continua/
├── README.md
├── docker-compose.yml
├── Jenkinsfile
├── jenkins/
│   ├── docker-compose.yml
│   └── example.env
└── capturas/
    ├── entrega1/
    └── entrega2/
```

---

## Despliegue de la Entrega 1

### 1. Crear la red Docker compartida

```bash
docker network inspect red-integracion >/dev/null 2>&1 || docker network create red-integracion
```

### 2. Levantar los contenedores Ubuntu

```bash
docker compose up -d
```

### 3. Validar conectividad

```bash
docker compose exec contenedor1 ping -c 4 contenedor2
```

---

## Despliegue de Jenkins

La carpeta `jenkins/` contiene los archivos necesarios para desplegar un servidor Jenkins junto con un agente SSH.

### Contenido de la carpeta Jenkins

* `jenkins/docker-compose.yml`: definición de Jenkins y del agente SSH.
* `jenkins/example.env`: variables de entorno requeridas para el despliegue.

---

## Configuración de las Llaves SSH

Generar un par de llaves SSH en el host:

```bash
mkdir -p jenkins/keys
ssh-keygen -t rsa -b 4096 -f jenkins/keys/jenkins_key -N ""
```

Visualizar la llave pública generada:

```bash
cat jenkins/keys/jenkins_key.pub
```

Copiar el contenido completo de la llave pública para utilizarlo en la variable `JENKINS_AGENT_SSH_PUBLIC_KEY`.

---

## Configuración del Archivo .env

Copiar el archivo de ejemplo:

```bash
cp jenkins/example.env jenkins/.env
```

Editar el archivo `.env`:

```env
JENKINS_HOME_PATH=/ruta/jenkins_home
JENKINS_AGENT_SSH_PUBLIC_KEY=ssh-rsa AAAAB3Nza...
```

### Variables

| Variable                     | Descripción                                                              |
| ---------------------------- | ------------------------------------------------------------------------ |
| JENKINS_HOME_PATH            | Ruta donde Jenkins almacenará su configuración y datos persistentes.     |
| JENKINS_AGENT_SSH_PUBLIC_KEY | Llave pública SSH que utilizará Jenkins para autenticarse con el agente. |

---

## Levantar Jenkins

```bash
docker compose -f jenkins/docker-compose.yml up -d
```

Verificar los contenedores:

```bash
docker ps
```

Visualizar los logs:

```bash
docker compose -f jenkins/docker-compose.yml logs -f
```

---

## Acceso a Jenkins

Una vez iniciado el servicio:

```text
http://localhost:8080
```

Para obtener la contraseña inicial:

```bash
docker exec -it jenkins_container cat /var/jenkins_home/secrets/initialAdminPassword
```

---

## Pipeline de Jenkins

El pipeline está definido en el archivo:

```text
Jenkinsfile
```

### Funcionalidades del Pipeline

1. Clonar el repositorio.
2. Levantar los contenedores definidos en `docker-compose.yml`.
3. Validar la conectividad entre contenedores.
4. Mostrar el estado de los servicios Docker.

Comandos ejecutados:

```bash
docker compose up -d
docker compose exec contenedor1 ping -c 4 contenedor2
docker compose ps
```

---

## Configuración del Job

1. Crear un nuevo Job tipo **Pipeline**.
2. Seleccionar **Pipeline script from SCM**.
3. Configurar el repositorio Git.
4. Definir como Script Path:

```text
Jenkinsfile
```

5. Guardar y ejecutar.

---

## Evidencias

Las capturas de pantalla de la actividad realizada se encuentran en:

```text
capturas/
├── entrega1/
└── entrega2/
```

---

## Notas

* Jenkins utiliza un volumen persistente definido mediante `JENKINS_HOME_PATH`.
* Jenkins tiene acceso al socket Docker del host para ejecutar comandos Docker desde los pipelines.
* Todos los servicios comparten la red Docker `red-integracion`.
* La configuración de logs incluye rotación automática para evitar crecimiento excesivo de archivos.