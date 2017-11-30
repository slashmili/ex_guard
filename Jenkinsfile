pipeline {
  agent {
    docker {
      image 'elixir'
    }
    
  }
  stages {
    stage('test') {
      steps {
        sh '''mix local.hex --force
mix local.rebar --force
mix deps.get
mix test'''
      }
    }
  }
}