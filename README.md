# SFproject

Terraform code is located in Terraform config file named "main.tf"
Firstly, AWS as a provider is defined, as well as public and private subnets, GW so the VM can have exit outside, security groups.
Afterwards creation of Ubuntu VM itself continues.

To be able to run the Terraform code, we need to initialize Terraform with "taraform init" command, followed by "terraform apply", which applies written commands from the configuration file.

Regarding VLAN tagging, we need to install VLAN package:

$sudo apt update
$sudo apt install vlan
$sudo ip link add link enp2 name enp2.150 type vlan id 150
$sudo ip addr add 10.0.2.10/24 dev enp2.150
$sudo ip link set dev enp2.150 up


Ansible code is located in "web-ssh-server.yaml" file. Besides it we need to create inventory.ini file where IP address of the server(s) which we want to perform our code against. 
To perform Ansible code we need to issue a command: "ansible-playbook -i inventory.ini web-ssh-server.yaml" 
