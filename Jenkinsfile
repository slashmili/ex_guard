pipeline {
  agent {
    docker {
      image 'elixir'
    }
    
  }
  stages {
    stage('error') {
      steps {
        sh '''mix local.hex --force
mix deps.get
mix test'''
      }
    }
  }
}