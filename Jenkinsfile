def version
node ('master') {
    stage ('clone') {
        git branch: 'task7', url: 'https://github.com/Woodforfood/devops-training.git'
    }
    stage ('increment Version') {
        sh './gradlew task changeVersion'
    }
    stage ('build') {
        sh './gradlew build'
    }
    stage ('checkVersion') {
        env.WORKSPACE = pwd()
        def file = new File("${env.WORKSPACE}/gradle.properties").eachLine { line ->
            if (line.contains('version')) {
                println line
            }    
        }
    }
    def props = readProperties  file:"${env.WORKSPACE}/gradle.properties"
    version = props['version']
    stage ('upload') {
        dir ('build/libs') {
            withCredentials([usernameColonPassword(credentialsId: 'NEXUS_ADMIN', variable: 'password')]) {
              sh "curl -XPUT -u $password -T gradleSample.war http://192.168.0.10:8081/nexus/content/repositories/snapshots/task7/'$version'/gradleSample.war"
           }
        }
    }
    stage ('docker') {
        sh "docker build -t greeting:'$version' ."
        sh "docker tag greeting:'$version' 192.168.0.10:5000/task7:'$version'"
        sh "docker push 192.168.0.10:5000/task7:'$version'"
    }           
    stage ('deploy') {
        try {
            sh "docker service create --name greeting -p 8083:8080 --replicas 2 192.168.0.10:5000/task7:'$version'"
        }
        catch(all) {
            sh "docker service update greeting"
        }
    }
    sleep 7
    stage ('check') {
        def result = sh returnStdout: true, script: 'curl "http://192.168.0.10:8083/gradleSample/"'
        if (result.contains("version=${version}")) {
            echo "Version is correct"
        } else {
            error ("Version is not correct")
        }
    }
}
    stage ('push&merge') {
        withCredentials([usernamePassword(credentialsId: 'Git', passwordVariable: 'GIT_PASS', usernameVariable: 'GIT_USER')]) {
          sh 'git checkout task7'    
          sh 'git status'    
          sh 'git add gradle.properties'
          sh 'git commit -m "updated"'
          sh 'git pull https://${GIT_USER}:${GIT_PASS}@github.com/woodforfood/devops-training.git task7'
          sh 'git push https://${GIT_USER}:${GIT_PASS}@github.com/woodforfood/devops-training.git task7'
          sh 'git checkout master'
          sh 'git pull https://${GIT_USER}:${GIT_PASS}@github.com/woodforfood/devops-training.git master'
          sh 'git merge --no-ff task7'
          sh 'git push https://${GIT_USER}:${GIT_PASS}@github.com/woodforfood/devops-training.git master'
          sh "git tag -a v'${version}'"
          sh "git push https://${GIT_USER}:${GIT_PASS}@github.com/woodforfood/devops-training.git v'${version}'"
        }
    }
}