pipeline {
	agent any
	environment {
		registryUrl = "hidpdeveastusbotacr.azurecr.io"
		}
	stages {
		stage( 'Gitcheckout') {
			steps {
		    	    git branch: 'helloworld', credentialsId: 'test', url: 'https://github.com/Shivakumar9141/helloworld.git'
			}
		}
		stage( 'Build') {		
			steps {
			  script {
				// Define Variable
				def USER_INPUT = input(
				message: 'User input required - select build type?',
				parameters: [
				[$class: 'ChoiceParameterDefinition',
				choices: ['maven','gradle'],
				name: 'input',
				description: 'Menu - select box option']
				]
				)
				  
				echo "build type is: ${USER_INPUT}"


				  

				  if( "${USER_INPUT}" == "maven")
				  sh 'mvn clean install'
				  else( "${USER_INPUT}" == "gradle")
				  sh 'gradle build'
						}
					}
				}
		stage( 'Build docker image') {		
			steps {
			     sh 'docker build -t myimage .'
				
			}
		}
		stage('Upload Image to ACR') {
			steps{   
				sh 'docker login http://$registryUrl -u hidpdeveastusbotacr -p +EaOLpFAd9ks5vrkfWBilFcJPoBQnKgT'
				sh 'docker tag myimage hidpdeveastusbotacr.azurecr.io/myimage:latest'
				sh 'docker push hidpdeveastusbotacr.azurecr.io/myimage:latest'
			}
        }
		stage( 'Login to AKS repo') {
			steps {
		    	    git branch: 'dev', credentialsId: 'test', url: 'https://github.com/Shivakumar9141/dev.git'
			}
		}
		stage( 'Update to AKS repo') {
			steps {
		    	    sh 'cat deployment.yml'
			    sh "sed -i 's/myimage:latest/myimage:1.0/g' deployment.yml"
			    sh 'git config --global user.name "Shivakumar9141"'
                            sh 'git config --global user.email "shivakumaras444@gmail.com"'
			    sh 'git add deployment.yml'
		            sh "git commit -m 'Updated the deployment file'"
			    withCredentials([usernamePassword(credentialsId: 'dev', passwordVariable: 'pass', usernameVariable: 'user')]) {
			    sh 'git push https://$user:$pass@github.com/Shivakumar9141/dev.git'	
			    }
			}
		}
		
	}
}
