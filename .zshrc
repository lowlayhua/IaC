iconn() {

ID=$1
IP=$2
USER=$3
AZ=$4

aws ec2-instance-connect send-ssh-public-key \
    --instance-id ${ID} \
    --availability-zone ${AZ} \
    --instance-os-user ${USER} \
    --ssh-public-key file://~/.ssh/layhua.pub

ssh ${USER}@${IP}
}
alias my-ec2-cluster="iconn i-05c504f703d07013e  10.0.101.36 ec2-user ap-southeast-1a"
alias layhua-instance="iconn i-0f65fc4dc0753521e  10.0.2.36 ec2-user ap-southeast-1c"

alias layhua-vm1="aws ssm start-session --target i-06389a65b8314adb7 --region ap-southeast-1"
alias tableau-vm1="aws ssm start-session --target i-045079755163eb2b6 --region ap-southeast-1"
