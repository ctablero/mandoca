resource aws_autoscaling_group "asg" {

  max_size = var.asg_max_size
  min_size = var.asg_min_size

  protect_from_scale_in = true

  launch_template {
    id = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  vpc_zone_identifier = var.subnets_ids

}

resource aws_launch_template "launch_template" {

  name_prefix = "instance-"
  image_id    = var.ami_id
  instance_type = var.instance_type

}
