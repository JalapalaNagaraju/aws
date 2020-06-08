locals {
  project2_tags = {
    ApplicationName   = "xipra"
    Environment = "production"
    CostCenter = "329876"
  }
}

/*
resource "aws_autoscaling_group" "example" {
  # ...

  tag {
    key                 = "Name"
    value               = "example-asg-name"
    propagate_at_launch = false
  }

  dynamic "tag" {
    for_each = local.project2_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

*/