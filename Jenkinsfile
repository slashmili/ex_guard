pipeline {
  agent {
    docker {
      image 'elixir'
    }
    
  }
  stages {
    stage('error') {
      steps {
        sh '''mix deps.get
mix test'''
      }
    }
  }
}