module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

#  ami = "ami-0f4929ce4bdd9c9d1"
  ami = "ami-0be42c5e8462af116"
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = var.vpc_security_group_ids
#  vpc_security_group_ids = ["sg-039d090bde38ff3e8"]
#  subnet_id              = "subnet-0171baaadf0141cd8"
  subnet_id              = var.subnet_id

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 15
      tags = {
        Name = "my-root-block"
      }
    },
  ]
 

#--

 create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name = "layhua-vm1"
  }
}
