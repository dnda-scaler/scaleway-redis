# Goal
Set of Terraform resources to help for creating Scaleway REDIS resources through terraform.
3 resources have been provided :
- Redis without VPC create a database that can be access through internet
- Redis with VPC create a database that can be access Scaleway Private Network
In that case , a scaleway instance have been deployed with the redis client but the Public Gateway NAT can also be used*

# Prerequisites
- node >=14
- Terraform

# Deployment
1. Choose your example (VPC|not)
2. Rename terraform.tfvars.template -> terraform.tfvars
3. Rename provider.tf.template -> provider.tf
4. Provide provider info
3. Fill the terraform.tfvars
4. terraform init 
5. terraform apply


# Access without VPC
1. Open the nodeJS CLient folder
2. npm i
3. npm run dev

CLuster can be used
Folliwng API can be used to intecact with the database
- User Creation
 ```
 curl --location --request POST 'http://localhost:5000/user' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name":"damien2",
    "email":"foo2@scaleway.com"
}'
```
- User Rertieve
```
curl --location --request GET 'http://localhost:5000/user/2ec8542f-55cc-4989-8ae3-3ed9c1e47582'
```

Data are cached wiothin th redis CLuster


Database can be access using redis-cli or nodejs-client used in 01-without-vpc


# For VPC Access
You will have to connect to your data using SSL Connection to the instance provisionned for that purpose
- You need for that to configure the ssh Bastion for the Public Gateway https://www.scaleway.com/en/docs/network/vpc/how-to/use-ssh-bastion/
- Connect to the instance
- The certificate and the remote location of the redis can be found in /etc/redis-cli/config
```
if TLS ENABLE see tls_enabled in /etc/redis-cli/config/redis_config.json
redis-cli -h XXX.XXX.XXX.XXX -p 6379 --user admin --askpass --tls --cacert  /etc/redis-cli/config/public_certificate.pem
else
redis-cli -h XXX.XXX.XXX.XXX -p 6379 --user admin --askpass 
```
NB: We will  wait for VPC integration stabilization to use  NAT to help access the REDIS Cluster but an instance associated within the 


