#!/bin/bash

#ENVIRONMENT=$1

dnf install ansible -y

#ansible-playbook -i inventory mysql.yaml

#pull
ansible-pull -i localhost, -U https://github.com/Prudhvi-Raj2/expense-ansible-roles-tf.git main.yaml -e COMPONENT=backend -e ENVIRONMENT=$1