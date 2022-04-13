pipeline {
   environment
 {    
     AWS_CREDENTIALS= credentials('aws-credentials')
     AWS_ACCOUNT_ID="440883647063"             
     AWS_DEFAULT_REGION="us-east-1" 
     IMAGE_REPO_NAME="java-app"
     REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
	   DOCKERHUB_CREDENTIALS=credentials('docker')
     NEXUS_VERSION = "nexus3"
     NEXUS_PROTOCOL = "http"
     NEXUS_URL = "18.212.175.27:8081"
     NEXUS_REPOSITORY = "java-nexus"
     NEXUS_CREDENTIAL_ID = "nexus"
 } 
    agent any
	
	  tools
    {
       maven "maven"
    }
 stages {
      stage('checkout') {
           steps {
             
                git branch: 'master', url: 'https://github.com/poornima4824/Java-app-pipeline.git'
             
          }
        }
	   stage('Execute Maven') {
           steps {
             
                sh 'mvn package'             
          }
	 }
       
      //   stage('Execute Sonarqube Report') {
      //     steps {
      //        withSonarQubeEnv('Sonar')
      //        {
      //          sh "mvn sonar:sonar"
      //        }
      //       }
      //   }
      //   stage('Quality Gate Check') {
      //     steps {
      //        timeout(time: 1, unit: 'HOURS') 
      //        {    
      //           waitForQualityGate abortPipeline: true
      //   }
      // }
      //  }

       stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
        }
        //  stage('Docker Build and Tag') {
        //       steps {
        //           sh 'docker build -t sample_login_app:latest .'
        //           sh 'docker tag  sample_login_app nagapoornima/sample_login_app:latest'
        //             }
        //       }
        //  stage('Login') {
        //       steps {
        //     sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
        //         }
        //       }
        //   stage('Push') {
        //          steps {
        //           sh 'docker push  nagapoornima/sample_login_app:latest'

        //          }
        //    }
     
            stage('Login to AWS ECR') {
               steps
                 {
                  script
                  {  
                     sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 440883647063.dkr.ecr.us-east-1.amazonaws.com"
                     //sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                     sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 440883647063.dkr.ecr.us-east-1.amazonaws.com"
                   }   
                 }
            }
       stage('Building Docker Image')
       {
           steps
           {
               script
               {
                 sh "docker build -t java-app ."
                //sh "docker build . -t ${REPOSITORY_URI}:LoginApp"
               }
           }
       }
       stage('Pushing Docker image into ECR')
       {
           steps
           {
             script
              {
                sh "docker tag java-app:latest 440883647063.dkr.ecr.us-east-1.amazonaws.com/java-app:latest"
                sh "docker push 440883647063.dkr.ecr.us-east-1.amazonaws.com/java-app:latest"
                //  sh "docker push ${REPOSITORY_URI}:sample-login-app"
              }
           }

     }
    //  //stop the previous containers if we use the same container name
    //  stage('stop previous containers') {
    //      steps {
    //         sh 'docker ps -f name=myContainerLoginApp -q | xargs --no-run-if-empty docker container stop'
    //         sh 'docker container ls -a -fname=myContainerLoginApp -q | xargs -r docker container rm'
    //      }
    //    }
    //  stage('Run the Docker Image') {
    //  steps{
    //      script {
    //             sh "docker run -d -p 9090:8080 --rm --name myContainerLoginApp ${REPOSITORY_URI}:latest"
    //         }
    //   }
    // } 
  }
}
