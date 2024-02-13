#!/bin/bash
ver=$(cat /var/lib/jenkins/workspace/dhcp/README | grep "Versió:" | cut -d " " -f 2)
echo $ver
ver_ant=$(cat /var/lib/jenkins/workspace/dhcp/README | grep "Versió anterior:" | cut -d " " -f 3)
echo $ver_ant
ssh vagrant@produccio mkdir -p projectes/dhcp/$ver
scp -r /var/lib/jenkins/workspace/dhcp vagrant@produccio:~/projectes/dhcp/$ver
if [[ ! -z $ver_ant ]]
then
        comprova=$(ssh vagrant@produccio ls /home/vagrant/projectes/dhcp | grep $ver_ant)
        if [[ $comprova != "" ]]
        then
           ssh vagrant@produccio docker-compose -f /home/vagrant/projectes/dhcp/$ver_ant/dhcp/docker-compose.yml down
        fi
fi
ssh vagrant@produccio docker-compose -f /home/vagrant/projectes/dhcp/$ver/dhcp/docker-compose.yml up -d
exit 0

