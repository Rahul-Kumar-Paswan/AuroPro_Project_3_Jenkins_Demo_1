// #!/usr/bin/env groovy

// library identifier : 'jenkins-shared-library@main',retriever:modernSCM([
//     $class:'GitSCMSource',
//     remote:'https://github.com/Rahul-Kumar-Paswan/flask-shared-lib.git',
//     credentialsId:'git-credentials'
// ])

// pipeline {
//   agent any
  
//   stages{

//     stage('Increment Version') {
//       steps {
//         script {
//           echo " hello dear"
//           def currentVersion = sh(
//             script: "python3 -c \"import re; match = re.search(r'version=\\\\'(.*?)\\\\'', open('setup.py').read()); print(match.group(1) if match else '143')\"",
//               returnStdout: true
//               ).trim()

//           echo "Previous Version: ${currentVersion}"
//           // Split the version into major, minor, and patch parts
//           def versionParts = currentVersion.split('\\.')

//           // Access the version parts using index
//           def major = versionParts[0]
//           def minor = versionParts[1]
//           def patch = versionParts[2]

//           echo "Current Version: ${currentVersion}"
//           echo "Major: ${major}"
//           echo "Minor: ${minor}"
//           echo "Patch: ${patch}"
//           echo "old versionParts : ${versionParts}"
                    
//           // Increment the patch part
//           versionParts[-1] = String.valueOf(versionParts[-1].toInteger() + 1)
//           echo "new versionParts : ${versionParts}"
                    
//           // Join the version parts back together
//           def newVersion = versionParts.join('.')
//           echo "newVersion : ${newVersion}"
                    
//           // Update the setup.py file with the new version
//           sh "sed -i \"s/version='${currentVersion}'/version='${newVersion}'/\" setup.py"

//           echo "New Version: ${newVersion}"
//           env.IMAGE_NAME = "$newVersion-$BUILD_NUMBER"
//           echo "New IMAGE_NAME: ${IMAGE_NAME}"
//         }
//       }
//     }

//     stage('Clean Build Artifacts') {
//       steps {
//         echo "Stage 1 Cleaning and Building Artifacts"
//         sh 'rm -rf build/ dist/ *.egg-info/'
//         sh 'git status'
//       }
//     }
    
//     stage('Build Image') {
//       steps {
//         echo "Stage 2 Building Image"
//         sh "ls -l /var/run/docker.sock"
//         buildImage "auropro_project_3:${IMAGE_NAME}"
//         dockerLogin()
//         dockerPush "auropro_project_3:${IMAGE_NAME}"
//       }
//     }

//     stage('Provision Server') {
//       environment {
//         AWS_ACCESS_KEY_ID = credentials('aws_access_key')
//         AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')
//         // TF_VAR_env_prefix = 'prod'
//         // TF_VAR_region = "ap-south-1"
//         RDS_ENDPOINT = ""
//         DB_USERNAME = ""
//         DB_PASSWORD = ""
//         DB_NAME = ""
//       }
//       steps {
//         script {
//           dir('AuroPro_Project_3'){
//             echo "Stage 3 Provision Server"

//             // Use Jenkins environment variable for RDS endpoint
//             RDS_ENDPOINT = env.RDS_ENDPOINT

//             withCredentials([file(credentialsId: 'terraform_tfvars_secret', variable: 'TFVARS_FILE')]) {
//               sh 'cp $TFVARS_FILE terraform.tfvars'
//             }
            
//             sh "chmod 644 terraform.tfvars"
//             sh "cat terraform.tfvars"

//             sh "terraform init"
//             sh "terraform plan"
//             sh "terraform validate"
//             sh "terraform apply -auto-approve"

//             EC2_PUBLIC_IP = sh(
//               script: "terraform output public_ip",
//               returnStdout:true
//             ).trim()

//             PEM_FILE = sh(
//             script: "terraform output private_key_pem",
//             returnStdout:true
//             ).trim()

//             // Use the provided RDS endpoint to set the corresponding environment variable in Terraform
//             sh "echo 'db_instance_endpoint = \"${RDS_ENDPOINT}\"' > terraform.tfvars"

//             // Inside the "Provision Server" stage
//             withCredentials([file(credentialsId: 'terraform_tfvars_secret', variable: 'TFVARS_FILE')]) {
//                 sh "cat \"$TFVARS_FILE\" >> terraform.tfvars"
//                 // Extract values from terraform.tfvars and set Jenkins environment variables
//                 DB_USERNAME = sh(script: 'grep -E "^db_username" terraform.tfvars | awk -F "=" \'{print $2}\' | tr -d "\'\""', returnStdout: true).trim()
//                 DB_PASSWORD = sh(script: 'grep -E "^db_password" terraform.tfvars | awk -F "=" \'{print $2}\' | tr -d "\'\""', returnStdout: true).trim()
//                 DB_NAME = sh(script: 'grep -E "^db_name" terraform.tfvars | awk -F "=" \'{print $2}\' | tr -d "\'\""', returnStdout: true).trim()
//             }


//             // Write private key content to a file
//             sh "echo '${PEM_FILE}' > private_key.pem"

//             // Set permissions on private key
//             sh "chmod 600 private_key.pem"

//             RDS_ENDPOINT = sh(
//               script: "terraform output db_instance_endpoint",
//               returnStdout:true
//             ).trim()

//           }
//           echo "Provisiong ##################################"
//           echo "${EC2_PUBLIC_IP}"
//           echo "${PEM_FILE}"
//           echo "${RDS_ENDPOINT}"
//           sh "pwd"
//           sh "ls"
//         }
//       }
//     }

//     stage('Deploy with Docker Compose and Groovy') {
//       environment {
//         IMAGE_NAME_1 = "rahulkumarpaswan/auropro_project_3:${IMAGE_NAME}"
//       }
//       steps {
//         script {
//           echo "Deploy to EC2 ........" 
//           echo "${IMAGE_NAME_1}"

//           def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"
//           def privateKeyPath = "${WORKSPACE}/AuroPro_Project_3/private_key.pem"

//           sh "chmod 600 ${privateKeyPath}"
//           sh "ls -l ${privateKeyPath}"

//           sh "pwd"
//           sh "ls"
//           echo "waiting for EC2 server to initialize"
//           sleep(time: 90, unit: "SECONDS")

//           def shellCmd = "bash ./server-cmds.sh RDS_ENDPOINT=${RDS_ENDPOINT} DB_USERNAME=${DB_USERNAME} DB_PASSWORD=${DB_PASSWORD} DB_NAME=${DB_NAME} '${IMAGE_NAME_1}'"
//           sh "scp -o StrictHostKeyChecking=no -i ${privateKeyPath} server-cmds.sh ${ec2Instance}:/home/ec2-user"
//           // sh "scp -o StrictHostKeyChecking=no -i ${privateKeyPath} docker-compose.yaml ${ec2Instance}:/home/ec2-user"

//           echo "Contents of the remote directory:"
//           // Print contents of the remote directory
//           sh "ssh -o StrictHostKeyChecking=no -i ${privateKeyPath} ${ec2Instance} 'ls -l /home/ec2-user'"

//           sh "ssh -o StrictHostKeyChecking=no -i ${privateKeyPath} ${ec2Instance} ${shellCmd}"

//           // deployApp "auropro_project_3:${IMAGE_NAME}"
//         }
//       }
//     }

//   }
// } 


// pipeline for Destroying Terraform Infrastructure

pipeline {
  agent any
  stages{

    stage('Destroying Terraform Infrastructure') {
      steps {
        echo " Testing stage 1 !!!!"
      }
    }

    stage('Destroying EveryThing') {
      environment {
        AWS_ACCESS_KEY_ID = credentials('aws_access_key')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')
      }
      steps {
        script {
          dir('AuroPro_Project_3'){
            sh "terraform init"
            sh "terraform plan"
            sh "terraform validate"
            sh " terraform destroy -auto-approve"
          }
        }
      }
    }
  }
} 