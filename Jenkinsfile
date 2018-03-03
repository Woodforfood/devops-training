def version
node ('master') {
    stage ('clone') {
        git branch: 'task6', url: 'https://github.com/Woodforfood/devops-training.git'
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
              sh "curl -XPUT -u $password -T gradleSample.war http://192.168.0.10:8081/nexus/content/repositories/snapshots/task6/'$version'/gradleSample.war"
           }
        }
   }
}

node ('Tomcat1') {
    stage ('download&deploy') {
        sh "curl --insecure http://192.168.0.10:8081/nexus/service/local/repositories/snapshots/content/task6/'$version'/gradleSample.war > /var/lib/tomcat/webapps/gradleSample.war"
    }
    stage ('stop lb') {
        sh 'curl "http://192.168.0.10/jkmanager?cmd=update&from=list&w=lb&sw=tomcat1&vwa=1"'
    }
    sleep 8
    stage('check version tomcat1') {
        sh "cd /var/lib/tomcat/webapps/gradleSample/WEB-INF/classes/"
        def file = readFile("/var/lib/tomcat/webapps/gradleSample/WEB-INF/classes/greeting.txt")
        if (file.contains("version=${version}")) {
            echo "Version is correct"
        } else {
            error ("Version is not correct")
        }   
    }
    sleep 8
    stage ('start lb') {
        sh 'curl "http://192.168.0.10/jkmanager?cmd=update&from=list&w=lb&sw=tomcat1&vwa=0"'
    }
}
node ('Tomcat2') {
    stage ('download&deploy') {
        sh "curl --insecure http://192.168.0.10:8081/nexus/service/local/repositories/snapshots/content/task6/'$version'/gradleSample.war > /var/lib/tomcat/webapps/gradleSample.war"
    }
    stage ('stop lb') {
        sh 'curl "http://192.168.0.10/jkmanager?cmd=update&from=list&w=lb&sw=tomcat2&vwa=1"'
    }
    sleep 8
    stage('check version tomcat2') {
        sh "cd /var/lib/tomcat/webapps/gradleSample/WEB-INF/classes/"
        def file = readFile("/var/lib/tomcat/webapps/gradleSample/WEB-INF/classes/greeting.txt")
        if (file.contains("version=${version}")) {
            echo "Version is correct"
        } else {
            error ("Version is not correct")
        }   
    }
    sleep 8
    stage ('start lb') {
        sh 'curl "http://192.168.0.10/jkmanager?cmd=update&from=list&w=lb&sw=tomcat2&vwa=0"'
    }
}
node ('master') {
    stage ('push&merge') {
        withCredentials([usernamePassword(credentialsId: 'Git', passwordVariable: 'GIT_PASS', usernameVariable: 'GIT_USER')]) {
          sh 'git checkout task6'    
          sh 'git status'    
          sh 'git add gradle.properties'
          sh 'git commit -m "updated"'
          sh 'git pull https://${GIT_USER}:${GIT_PASS}@github.com/woodforfood/devops-training.git task6'
          sh 'git push https://${GIT_USER}:${GIT_PASS}@github.com/woodforfood/devops-training.git task6'
          sh 'git checkout master'
          sh 'git pull https://${GIT_USER}:${GIT_PASS}@github.com/woodforfood/devops-training.git master'
          sh 'git merge --no-ff task6'
          sh 'git push https://${GIT_USER}:${GIT_PASS}@github.com/woodforfood/devops-training.git master'
          def props = readProperties  file:"${env.WORKSPACE}/gradle.properties"
          version = props['version']
          sh "git tag -a v'${version}'"
          sh "git push https://${GIT_USER}:${GIT_PASS}@github.com/woodforfood/devops-training.git v'${version}'"
        }
    }
}