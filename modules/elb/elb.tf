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
  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_launch_configuration" "lc" {
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  security_groups = ["${var.internal_sg}"]
  key_name        = aws_key_pair.deployer.key_name
  user_data       = file("${path.module}/userdata.sh")
  lifecycle {
    create_before_destroy = true
  }
}

## Creating AutoScaling Group
resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.lc.id
  vpc_zone_identifier  = ["${var.subnet_ids[0]}","${var.subnet_ids[1]}","${var.subnet_ids[2]}","${var.subnet_ids[3]}","${var.subnet_ids[4]}","${var.subnet_ids[5]}","${var.subnet_ids[6]}","${var.subnet_ids[7]}","${var.subnet_ids[8]}","${var.subnet_ids[9]}","${var.subnet_ids[10]}"]
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  load_balancers      = ["${aws_elb.elb.name}"]
  health_check_type   = "ELB"
  #tags = [merge(map("Name", "${var.project_prefix}-asg"), var.tags)]
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

### Creating ELB
resource "aws_elb" "elb" {
  #count = 2
  subnets         = ["${var.subnet_ids[0]}","${var.subnet_ids[1]}","${var.subnet_ids[2]}","${var.subnet_ids[3]}","${var.subnet_ids[4]}","${var.subnet_ids[5]}"]
  security_groups = ["${var.elb_sg}"]
  tags = merge(map("Name", "${var.project_prefix}-asg"), var.tags)
 health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 10
    target              = "TCP:80"
  }
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }
}
