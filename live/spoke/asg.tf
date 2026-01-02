module "autoscaling" {
  source = "terraform-aws-modules/autoscaling/aws"

  for_each = {
    ex_1 = {
      instance_type              = "t3.small"
      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 0
          spot_allocation_strategy                 = "price-capacity-optimized"
        }

        launch_template = {}
      }
      user_data = <<-EOT
        #!/bin/bash

        cat <<'EOF' >> /etc/ecs/ecs.config
        ECS_CLUSTER=${var.service}
        ECS_LOGLEVEL=debug
        ECS_CONTAINER_INSTANCE_TAGS=${jsonencode(local.default_tags)}
        ECS_ENABLE_TASK_IAM_ROLE=true
        ECS_ENABLE_SPOT_INSTANCE_DRAINING=true
        EOF

        cd /tmp
        sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
        sudo systemctl enable amazon-ssm-agent
        sudo systemctl start amazon-ssm-agent
      EOT
    }
  }

  name = "${var.service}-${each.key}"

  image_id      = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
  instance_type = each.value.instance_type

  security_groups                 = [split("/", var.security_group)[1]]
  user_data                       = base64encode(each.value.user_data)
  ignore_desired_capacity_changes = true

  create_iam_instance_profile = true
  iam_role_name               = var.service
  iam_role_description        = "ECS role for ${var.service}"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    AdoCustomRole                       = module.ado_custom_policy.arn
  }

  vpc_zone_identifier = local.private_subnet_ids

  health_check_type = "EC2"
  min_size          = 1
  max_size          = 1
  desired_capacity  = 1

  autoscaling_group_tags = {
    AmazonECSManaged = true
  }

  protect_from_scale_in = true

  use_mixed_instances_policy = each.value.use_mixed_instances_policy
  mixed_instances_policy     = each.value.mixed_instances_policy

  tags = local.default_tags
}
