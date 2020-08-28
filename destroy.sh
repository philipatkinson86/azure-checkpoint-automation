#! /bin/sh
echo "`date -u`\e[1;33m [Destroy SECUREME SCRIPT] Destroy the SMS in Azure...\e[0m"
cd TfSms
terraform destroy
echo "`date -u`\e[1;33m [Destroy SECUREME SCRIPT] Destroy the main lab in Azure...\e[0m"
cd ../TfGwWeb
terraform destroy
