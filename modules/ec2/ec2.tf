data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${var.public_key}")
}


resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  tags                   = merge(map("Name", "${var.project_prefix}-web"), var.tags)
  vpc_security_group_ids = ["${var.internal_sg}", "${var.elb_sg}"]
  volume_tags            = merge(map("Name", "${var.project_prefix}-web"), var.tags)
  user_data              = file("${path.module}/userdata.sh")
  subnet_id              = var.subnet_ids[0]
}