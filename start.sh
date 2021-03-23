#!/bin/bash

INVENT="inventories"
CORE_IP=`hostname -I`
PWD_DIR=`pwd`

echo -e "\033[33m Start Install \033[0m \n"
read -p $'\e[33mEnter Password:\e\033[30m ' password
echo -e "\n\033[33m Good !!! \033[0m"

echo $password | sudo -S apt -y update && 
echo $password | sudo -S apt -y upgrade &&
echo $password | sudo -S apt -y install software-properties-common &&
echo $password | sudo -S apt -y install ansible sshpass 

if [ ! -f ~/.ssh/id_rsa ]; then
        echo -e "\n \033[31m Create SSH-KEY \033[0m"
	cat /dev/zero | ssh-keygen -t rsa -b 4096 -q -N ""
fi

if grep "\[core\]" $INVENT/hosts; then
        echo -e "\n\033[33m Host CORE present in file hosts \033[0m \n";
else
	echo -e "[core]\ncore ansible_ssh_host=$CORE_IP\n\n$(cat $INVENT/hosts)" > $INVENT/hosts;
fi

echo -e ""
sed '/^$/d' $INVENT/hosts > tmp_ip
cat tmp_ip | sed '/^\[/d' > tmp_ipn ; cat tmp_ipn | sed 's|.*=||' > tmp_ip ; rm tmp_ipn
sed -i '1d' tmp_ip

cat tmp_ip

sshpass -p $password ssh-copy-id -o "StrictHostKeyChecking no" $USER@$CORE_IP

for LINE in $(cat tmp_ip)
do
        sshpass -p $password ssh-copy-id -o "StrictHostKeyChecking no" $USER@$LINE;
        sshpass -p $password ssh $USER@$LINE "echo $password | sudo -S apt -y update && echo $password | sudo -S apt -y install python python-pip curl wget git";
done

ansible -i $INVENT -m ping all


rm tmp_ip

echo -e "\nGood !!!"
