terraform init
terraform plan -var "sandbox_id=stan-test" -var "owner=Stan" -var "key_name=comformation-eu-west-1"
terraform apply -var "sandbox_id=stan-test" -var "owner=Stan" -var "key_name=comformation-eu-west-1"
terraform destroy -var "sandbox_id=stan-test" -var "owner=Stan" -var "key_name=comformation-eu-west-1"
