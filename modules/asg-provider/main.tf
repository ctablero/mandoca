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

data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource aws_launch_template "launch_template" {

  name_prefix             = "instance-"
  image_id                = data.aws_ssm_parameter.ecs_optimized_ami.value
  instance_type           = var.instance_type
  vpc_security_group_ids = [var.security_group_id_for_asg_instances]

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  user_data = filebase64("${path.module}/ecs.sh")

}
