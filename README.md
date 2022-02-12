# Manually Instrumenting legacy Tomcat application for AppDynamics business insights 
## Contents
        Use Case

        Pre-requisites

        Provision Database server

        Provision App Infrastructure

        Deploy AppDynamics Agent Installer

        Deploy App Services

        Run App Load


### Use Case

* As a DevOps and App developer, leverage scripts to enable existing Java/Tomcat Micro services for AppDynamics Insights

* As DevOps and App Developer, use AppDynamics to view app and infrastructure insights for Full Stack Observability


### Pre-requisites

1. The VM template that you provision in Step 5 below will have a ubuntu image and user "root/Cisco123" provisioned with sudo privileges. You will use this root account to provision the database and app server.

4. You will need access to a vSphere infrastructure with backend compute and storage provisioned. You have 2 VM's provisioned each with 4 vCPU and 8192 memory. Please note the IP address. We will refer to the two VM's as DBVM and APPVM.

5. You will also need an account in AppDynamics SAAS Controller and should have the API Client ID and Client Secret.

7. You have cloned the following git repository which hosts the scripts that will be used in implementing this use case. 

https://github.com/CiscoDevNet/AppDynamicsTomcatSA.git


### Provision Database server

SCP scripts/dbvm/* to DBVM /tmp dir

chmod +x /tmp/installmysql.sh

SSH to DBVM and Run: /tmp/installmysql.sh root teadb teauser teapassword DBVM_IP


### Provision App Infrastructure

SCP scripts/appvm/* to APPVM /tmp dir

SCP scripts/appwars/* to APPVM /tmp dir

SSH to APPVM and Run: 

    chmod +x /tmp/appd.sh

    chmod +x /tmp/tom.sh

    /tmp/appd.sh

    /tmp/tom.sh


SSH to DBVM and Run: 

    chmod +x /tmp/grant.sh

    /tmp/grant.sh APPVM_IP DBVM_IP teadb teauser teapassword


### Deploy AppDynamics Agent Installer

Get the AppDynamics Agent Installer artifacts from SAAS Controller:

Get Bearer token:

curl --location --request POST 'https://devnet.saas.appdynamics.com/auth/v1/oauth/token' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'grant_type=client_credentials' --data-urlencode 'client_id=YYYYYY' --data-urlencode 'client_secret=XXXXXX'

Get the download commnd:

curl -location --request GET 'https://devnet.saas.appdynamics.com/zero/v1beta/install/downloadCommand?javaVersion=21.5.0.32605&machineVersion=latest&infraVersion=latest&zeroVersion=latest&multiline=false' --header 'Authorization: Bearer <bearer-token>'

Get the install command:

curl -s --location --request GET "https://devnet.saas.appdynamics.com//zero/v1beta/install/installCommand?sudo=true&multiline=false&application=NewChaiStore&accessKey=fillmein&serviceUrl=https://devnet.saas.appdynamics.com" --header "Authorization: Bearer <bearer-token>"

### Deploy App Services

SSH to APPVM and Run: 

    chmod +x /tmp/tominstance.sh

    chmod +x /tmp/startsvc.sh

    /tmp/tominstance.sh RegistryService 8086 8011 tools.descartes.teastore.registry.war DBVM_IP

    /tmp/tominstance.sh AuthService 8083 8008 tools.descartes.teastore.auth.war DBVM_IP

    /tmp/tominstance.sh PersistenceService 8084 8009 tools.descartes.teastore.persistence.war DBVM_IP

    /tmp/tominstance.sh RecommenderService 8082 8007 tools.descartes.teastore.recommender.war DBVM_IP

    /tmp/tominstance.sh WebUIService 8085 8010 tools.descartes.teastore.webui.war DBVM_IP

    /tmp/tominstance.sh ImageService 8081 8006 tools.descartes.teastore.image.war DBVM_IP

    /tmp/startsvc.sh RegistryService 8086 8011 tools.descartes.teastore.registry.war DBVM_IP

    /tmp/startsvc.sh AuthService 8083 8008 tools.descartes.teastore.auth.war DBVM_IP

    /tmp/startsvc.sh PersistenceService 8084 8009 tools.descartes.teastore.persistence.war DBVM_IP

    /tmp/startsvc.sh RecommenderService 8082 8007 tools.descartes.teastore.recommender.war DBVM_IP

    /tmp/startsvc.sh WebUIService 8085 8010 tools.descartes.teastore.webui.war DBVM_IP
    
    /tmp/startsvc.sh ImageService 8081 8006 tools.descartes.teastore.image.war DBVM_IP





### Run App Load