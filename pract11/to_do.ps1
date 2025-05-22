#Создайте волт /home/user/task/nginx.vault и паролем vaultSecret@!

cd /home/user/task

pass="vaultSecret@!"
echo $pass > /home/user/task/.vault_pass.txt


cat << EOF > /home/user/task/nginx.vault
---
nginx_user : user
nginx_pass : secretPassword123!
EOF


#Шифруем файл vars/exmple_text.yml:

ansible-vault encrypt /home/user/task/nginx.vault --vault-password-file .vault_pass.txt

#запускаем плейбук:
ansible-playbook -i inventory.yaml site.yaml --vault-password-file .vault_pass.txt


#ansible-playbook -i inventory.yaml site.yaml -e "@/home/user/task/nginx.vault"  --vault-password-file .vault_pass.txt


