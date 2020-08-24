#! /bin/sh
echo "`date -u`\e[1;33m [SECUREME SCRIPT] Building Check Point Mgmt server in Azure...\e[0m"
cd TfSms
# terraform init -input=false
# terraform apply -auto-approve
#echo "<tf apply>"
my_ip=`cat terraform.tfstate | grep value | grep -o ': ".*"' | tr -d ' :"'`
echo "`date -u`\e[1;33m [SECUREME SCRIPT] Waiting for build to finish, this should take around 20mins...\e[0m"
echo "`date -u`\e[1;33m [SECUREME SCRIPT] If you want to see progress, SSH to $my_ip (admin/VPN123vpn123!) and tail -f /var/log/ftw_install.log\e[0m"
# sleep 1200
sleep 1
echo "`date -u`\e[1;33m [SECUREME SCRIPT] Mgmt build should be finished, sync-ing latest public IP to Ansiblie config files...\e[0m"
file1=../ansible/vars.yml
file2=../ansible/play.yml
file3=../ansible/hosts
sed -i 's/mgmt_server: .*/mgmt_server: '$my_ip'/' $file1
sed -i 's/hosts: .*/hosts: '$my_ip'/' $file2
sed -i '$d' $file3
echo $my_ip >> $file3
# sed -i '45s/.*/'$my_ip'/' $file3
echo "`date -u`\e[1;33m [SECUREME SCRIPT] New Public IP synched into ansible config files\e[0m"
echo "`date -u`\e[1;33m [SECUREME SCRIPT] Running Ansible Playbook to configure Mgmt Server policy\e[0m"
cd ../ansible
ansible-playbook -i ./hosts play.yml
#echo "<ansible play>"
echo "`date -u`\e[1;33m [SECUREME SCRIPT] Ansible configuration complete.\e[0m"
echo ""
echo "`date -u`\e[1;33m [SECUREME SCRIPT] *** Manual Task required ***\e[0m"
echo "`date -u`\e[1;33m [SECUREME SCRIPT] Login to $my_ip via R80.40 SmartConsole (api_user/VPN123vpn123!) and update the SMS IP to $my_ip - don't forget to Publish the session.\e[0m"
printf 'Once Manual task is complete, press [ENTER] to continue with SECUREME SCRIPT...'
read _
echo ""
echo "`date -u`\e[1;33m [SECUREME SCRIPT] *** Manual Task required ***\e[0m"
echo "`date -u`\e[1;33m [SECUREME SCRIPT] Login to $my_ip via SSH (admin/VPN123vpn123!) and run the following commands to configure CME\e[0m"
echo ""
echo "autoprov_cfg -f init Azure -mn r80dot40mgmt -tn Azure_VisualStudio_R80.40 -otp vpn12345 -ver R80.40 -po Standard -cn Azure -sb <Azure-Subscription> -at <Tenant-ID> -aci <Client-ID> -acs <Client-Secret>"
echo ""
echo "autoprov_cfg -f set template -tn Azure_VisualStudio_R80.40 -av -ab -ips"
echo ""
printf 'Once Manual task is complete, press [ENTER] to continue with SECUREME SCRIPT...'
read _
echo "`date -u`\e[1;33m [SECUREME SCRIPT] Building Check Point Gateway Scale-Set and web server infrastructure in Azure...\e[0m"
cd ../TfGwWeb
terraform init -input=false
terraform apply -auto-approve
#echo "<tf apply>"
echo "`date -u`\e[1;33m [SECUREME SCRIPT] Waiting for build to finish, this should take around 5mins...\e[0m"
echo "`date -u`\e[1;33m [SECUREME SCRIPT] If you want to see progress, SSH to $my_ip (admin/VPN123vpn123!) and tail -f /var/log/CPcme/cme.log\e[0m"
sleep 300
my_ip2=`cat terraform.tfstate | grep value | grep -o ': ".*"' | tr -d ' :"\n'`
echo "`date -u`\e[1;33m [SECUREME SCRIPT] Gateway / Web build should be finished, please test by browsing to http://$my_ip2...\e[0m"
