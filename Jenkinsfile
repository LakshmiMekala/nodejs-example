pipeline {
    agent any
    environment {
        registry = "lmekala/nodejsexample"
        registryCredential = 'docker_creds'
        dockerImage = ''
    }
    stages  {
        // stage('nodejs app Tests') {
        //     steps {
        //         echo 'Building npm app'
        //         sh 'npm install'
        //         echo 'Run npm tests'
        //         sh 'npm run'
        //     }
        // }
        stage('Build docker image') {
            steps {
                script {
                    // commitId = sh(git diff --name-only HEAD~1)
                    // def appImage = docker.build imageName + ":" + commitId
                    // appImage = docker.build('helloworld')
                    appimage = docker.build registry + ":$BUILD_NUMBER"
                    // appimage.push("${commitId}")
                    // appImage.push("${env.BUILD_NUMBER}")
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
                        // appimage.push("${commitId}")
                        appImage.push("${env.BUILD_NUMBER}")
                    //     if (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'release') {
                    //         appimage.push('latest')
                    //         if (env.BRANCH_NAME == 'release') {
                    //             appimage.push('app-${commitId}')
                    //         }
                    //     }
                    }
                }
            }
        }
        // stage('Publish') {
        //     steps {
        //         script {
        //             commitId = sh(returnStdout: true, script: 'git rev-parse --short HEAD')
        //             def appimage = docker.build imageName + ":" + commitId.trim()
        //             docker.withRegistry( 'https://docker.tansanrao.com', registryCredential ) {
        //                 appimage.push()
        //                 if (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'release') {
        //                     appimage.push('latest')
        //                     if (env.BRANCH_NAME == 'release') {
        //                         appimage.push("release-" + "${COMMIT_SHA}")
        //                     }
        //                 }
        //             }
        //         }
        //     }
        // }
    }
}
