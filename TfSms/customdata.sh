#!/bin/bash
clish -c 'set user admin shell /bin/bash' -s
config_system -s 'install_security_gw=false&install_ppak=false&gateway_cluster_member=false&install_security_managment=true&install_mgmt_primary=true&install_mgmt_secondary=false&download_info=true&hostname=r80dot40mgmt&mgmt_gui_clients_radio=any&mgmt_admin_radio=gaia_admin'
/opt/CPvsec-R80.40/bin/vsec on
while true; do
    status=`api status |grep 'API readiness test SUCCESSFUL. The server is up and ready to receive connections' |wc -l`
    echo "Checking if the API is ready"
    if [[ ! $status == 0 ]]; then
         break
    fi
       sleep 15
    done
echo "API ready " `date`
sleep 5
echo "Set R80 API to accept all ip addresses"
mgmt_cli -r true set api-settings accepted-api-calls-from "All IP addresses" --domain 'System Data'
echo "Add user api_user with password vpn123"
mgmt_cli -r true add administrator name "api_user" password "VPN123vpn123!" must-change-password false authentication-method "INTERNAL_PASSWORD" permissions-profile "Super User" --domain 'System Data'
echo "Restarting API Server"
api restart
sleep 5
autoprov_cfg -f init Azure -mn r80dot40mgmt -tn Azure_VisualStudio_R80.40 -otp vpn12345 -ver R80.40 -po Standard -cn Azure -sb "9a484f3e-b9a6-44d6-908d-de2cd00e349e" -at 2188ddff-630a-4b97-8202-14916ae518af -aci "9efa893f-23ef-40af-b282-ec7e6208b05b" -acs "Xc2VyhZ/y1Cnm4TojPqkV8kb2L3Vpy34tqpZIHSds/8="
autoprov_cfg -f set template -tn Azure_VisualStudio_R80.40 -av -ab -ips