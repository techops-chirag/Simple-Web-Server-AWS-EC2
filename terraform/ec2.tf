# Creating EC2 Instaces
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name  = "${var.project_name}-instance"

  ami                         = var.ami
  instance_type               = "t2.micro"
  key_name                    = var.KeyPair
  monitoring                  = true
  vpc_security_group_ids      = [module.security_group.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = "true"

  user_data = file("${path.module}/makeserver.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}