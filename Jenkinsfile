pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Deploy Ubuntu containers') {
      steps {
        echo 'Desplegando contenedores Ubuntu desde docker-compose.yml de la raíz'
        sh "docker network inspect red-integracion >/dev/null 2>&1 || docker network create red-integracion"
        sh 'docker compose -f docker-compose.yml up -d --build'
      }
    }

    stage('Validate connectivity') {
      steps {
        echo 'Validando la comunicación entre contenedor1 y contenedor2'
        sh 'docker compose -f docker-compose.yml exec contenedor1 ping -c 4 contenedor2'
      }
    }

    stage('Show status') {
      steps {
        sh 'docker compose -f docker-compose.yml ps'
      }
    }
  }

  post {
    always {
      echo 'Pipeline completado. Si quieres detener los contenedores, usa docker compose down.'
    }
  }
}
