pipeline {
  agent {
    docker {
      image 'elixir'
      args 'mix do deps.get, test'
    }
    
  }
  stages {
    stage('') {
      steps {
        sh '''mix deps.get
mix test'''
      }
    }
  }
}