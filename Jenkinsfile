#!groovy
pipeline {
  agent { label 'TERRAFORM12' }
  stages {
    stage('Deploy Dev') {
      steps {
        script {
          echo "Deploying Dev Environment..."
          echo "-----> Git Commit  ${GIT_COMMIT}"
          deployAws("dev", "data-nonprod")
        }
      }
    }

    stage('Deploy Staging input') {
        agent none
        steps {
            timeout(time: 60, unit: 'SECONDS') {
                input message: 'Deploy to Staging?'
            }
        }
    }

    stage('Deploy Stage') {
      steps {
        script {
          echo "Deploying Prod Environment..."
          echo "-----> Git Commit  ${GIT_COMMIT}"
          deployAws("stage", "data-nonprod")
        }
      }
    }

    stage('Deploy Prod input') {
        agent none
        steps {
            timeout(time: 60, unit: 'SECONDS') {
                input message: 'Are you sure you want to deploy to Prod?'
            }
        }
    }

    stage('Deploy Prod') {
      steps {
        script {
          echo "Deploying Prod Environment..."
          echo "-----> Git Commit  ${GIT_COMMIT}"
          deployAws("prod", "data-prod")
        }
      }
    }

  }

  post {
      failure {
        mail to: 'kvajja@cars.com,spurathanamannil-contractor@cars.com',
        body: "Build failed. See >> ${env.BUILD_URL}",
        subject: "Build failed. Job: '${env.JOB_NAME}' Build: (${env.BUILD_NUMBER})"
      }
    }

}



def commonSteps() {
        COMMIT = sh(
            script: 'git rev-parse HEAD',
            returnStdout: true
        ).trim()
        BUILD_NAME = "${COMMIT}"
}

def deployAws(env, infraEnv) {

  withCredentials([[
                   $class: 'AmazonWebServicesCredentialsBinding',
                   credentialsId: 'aws-' + infraEnv,
                   accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                   secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                   ]]) {
    sh """
              cd ${env}
              rm -rf .terraform
              terraform12 init -input=false
              terraform12 plan -out=tfplan-${GIT_COMMIT} -input=false
              terraform12 apply tfplan-${GIT_COMMIT}
          """
  }
}
