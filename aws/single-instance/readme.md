let your <_key-name_>.pem file loacated in ~/.aws/ (or %USERPROFILE%\\.aws\\ on windows)

terraform init

terraform plan -var "sandbox_id=<_sandbox-id_>" -var "owner=<_owner_>" -var "key_name=<_key-name_>"

terraform apply -var "sandbox_id=<_sandbox-id_>" -var "owner=<_owner_>" -var "key_name=<_key-name_>"

terraform destroy -var "sandbox_id=<_sandbox-id_>" -var "owner=<_owner_>" -var "key_name=<_key-name_>"
