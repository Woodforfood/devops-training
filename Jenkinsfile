node ('master') {
   stage ('update metadata'){
      env.WORKSPACE = pwd()
      def props = readProperties  file:"${env.WORKSPACE}/metadata.rb"
      vrs = props['version']
      def file = new File("${env.WORKSPACE}/metadata.rb")
      def newConfig = file.text.replaceAll(vrs, "'$version'")
      file.text = newConfig
    }
    stage ('update attributes'){
      def props = readProperties  file:"${env.WORKSPACE}/attributes/default.rb"
      vrs = props["node.default['dockapp']['version']"]
      def file = new File("${env.WORKSPACE}/attributes/default.rb")
      def newConfig = file.text.replaceAll("$vrs", "'$version'")
      file.text = newConfig
    }
    stage ('update environment'){
      def props = readProperties  file:"${env.WORKSPACE}/environments/dev.json"
      vrs = props['"dockapp"']
      def file = new File("${env.WORKSPACE}/environments/dev.json")
      def newConfig = file.text.replaceAll(vrs, /"= $version"/)
      file.text = newConfig
    }
    stage ('upload cookbook'){
       sh "cd ${env.WORKSPACE}"
       sh "sudo berks install && sudo berks upload"
    }
    stage ('upload environment'){
       sh "sudo knife environment from file ${env.WORKSPACE}/environments/dev.json"
    }
    stage ('push') {
        withCredentials([usernamePassword(credentialsId: 'Git', passwordVariable: 'GIT_PASS', usernameVariable: 'GIT_USER')]) {
          sh 'git status'
          sh 'git add .'
          sh 'git commit -m "updated"'
          sh 'git push https://${GIT_USER}:${GIT_PASS}@github.com/woodforfood/devops-training.git task10'
        }
    }
    stage ('start chef-client'){
        sh 'sudo chef-client'
    }
}