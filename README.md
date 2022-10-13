# Goal
Set of resources to help for creating Scaleway REDIS resources through terraform.
3 resources have been provided :
- Redis without VPC create a database that can be access through internet
- Redis with VPC create a database that can be access Scaleway Private Network
In that case , a scaleway instance have been deployed with the redis client but the Public Gateway NAT can also be used*

# Deployment
1. Choose your example
2. Rename terraform.tfvars.template -> terraform.tfvars
3. Fill the terraform.tfvars
4. terraform init 
5. terraform apply

Database can be access using redis-cli or nodejs-client used in 01-without-vpc