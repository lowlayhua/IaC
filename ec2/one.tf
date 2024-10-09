module "ec2_instance_1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "tableau-vm1"

  ami = "ami-0be42c5e8462af116"
  instance_type          = "t2.micro"
  monitoring             = true
  subnet_id              = element(module.vpc.intra_subnets, 0)
  vpc_security_group_ids = [module.security_group_instance.security_group_id]
#  vpc_security_group_ids = var.vpc_security_group_ids
#  subnet_id              = var.subnet_id

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
  
 ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 5
      throughput  = 200
      encrypted   = true
      tags = {
        MountPoint = "/data"
      }
    }
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
    Name = "tableau-vm1"
  }
}
