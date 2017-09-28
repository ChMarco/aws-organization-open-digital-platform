#Demo

TF prerequisites for provisioning X account
The below should be setup on X account;

##IAM Role
- ManagementAccountAccessRole

##S3 Buckets
- account_id-cloudtrail
- account_id-infrastructure-terraform
	- terraform-codebuild
	- terraform-efs-backup
	- terraform-scripts
		- jenkins
	- terraform-states
	- terraform-outputs
	
##Codebuild
- Jenkins Image
- Jenkins Slave Image

##Jenkins Setup
- Credentials
	- Update AWS Credentials
	- Update GitHub Credentials
- In-process Script Approval
- Amazon ECS
	- Update ELB
	- Update Jenkins Slave Image

##Vault
```
docker exec -i -t <vault_container> sh
vault status
vault init
vault unseal key1
vault unseal key2
vault unseal key3
vault auth token
alias vault='docker exec -it <vault_container> vault "$@"'
vault write -address=http://127.0.0.1:8200 secret/billion-dollars value=behind-super-secret-password
```

###S3
```	
./s3_create_bucket.py 633665859024
./s3_create_folders.py 633665859024
./s3_upload_files.py 633665859024 /Users/mohammedabubakar/contino/aws-terraform-open-digital-platform-template-account/codebuild terraform-codebuild
./s3_upload_files.py 633665859024 /Users/mohammedabubakar/contino/aws-terraform-open-digital-platform-template-account/terraform/modules/services/jenkins/dsl terraform-scripts/jenkins
```
###Account Infrastructure
```
./account.sh 633665859024 contino 633665859024-infrastructure-terraform eu-west-1 init
./account.sh 633665859024 contino 633665859024-infrastructure-terraform eu-west-1 get
./account.sh 633665859024 contino 633665859024-infrastructure-terraform eu-west-1 plan
./account.sh 633665859024 contino 633665859024-infrastructure-terraform eu-west-1 apply
```

- Zip files and upload to S3
- Build Jenkins & Jenkins Slave Images
- Get Image Tags
- Update Jenkins

###Management Infrastructure
```
./mgmt.sh 633665859024 contino Test 633665859024-infrastructure-terraform eu-west-1 init
./mgmt.sh 633665859024 contino Test 633665859024-infrastructure-terraform eu-west-1 get
./mgmt.sh 633665859024 contino Test 633665859024-infrastructure-terraform eu-west-1 plan
./mgmt.sh 633665859024 contino Test 633665859024-infrastructure-terraform eu-west-1 apply
```
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

`aws_access_key_id: AKIAJ2KLWQLUCN67V6OA`
`aws_secret_access_key: 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`

```
-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----
```

###Vault Installation
```
wget https://releases.hashicorp.com/vault/0.8.3/vault_0.8.3_linux_amd64.zip
unzip vault_0.8.3_linux_amd64.zip
sudo mv vault /usr/local/bin/vault
vault version
vi ~/.vault-token
vault read -address=http://<>:8200 secret/billion-dollars
```