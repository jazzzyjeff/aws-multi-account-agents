module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 6.0"

  count = var.stack == "ecs" ? 1 : 0

  cluster_name = var.service

  tags = local.default_tags
}

module "ecs_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  count = var.stack == "ecs" ? 1 : 0

  name        = var.service
  description = "ecs security group"
  vpc_id      = var.vpc_id

  ingress_rules = []

  egress_rules       = ["https-443-tcp"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = local.default_tags
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "~> 6.0"

  count = var.stack == "ecs" ? 1 : 0

  name        = "ado"
  cluster_arn = module.ecs_cluster[0].cluster_arn

  cpu         = 512
  memory      = 1024
  launch_type = "EC2"

  vpc_id                = var.vpc_id
  subnet_ids            = var.subnets
  create_security_group = false
  security_group_ids    = [module.ecs_sg[0].security_group_id]

  container_definitions = {
    ado = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = docker_registry_image.ado.name
      host_path = "/var/run/docker.sock"
      mount_points = [
        {
          sourceVolume  = "docker-volume"
          containerPath = "/var/run/docker.sock"
          readOnly      = false
        }
      ]
      portMappings = [
        {
          name          = "ado"
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      restartPolicy = {
        enabled              = true
        ignoredExitCodes     = [1]
        restartAttemptPeriod = 60
      }
      readonlyRootFilesystem = false

      enable_cloudwatch_logging              = true
      create_cloudwatch_log_group            = true
      cloudwatch_log_group_name              = "/aws/ecs/ado/ado"
      cloudwatch_log_group_retention_in_days = 7

      logLonfiguration = {
        logDriver = "awslogs"
      }

      environment = [
        {
          name  = "AZP_URL"
          value = var.ado["AZP_URL"]
        },
        {
          name  = "AZP_POOL"
          value = var.ado["AZP_POOL"]
        },
        {
          name  = "AZP_TOKEN"
          value = var.ado["AZP_TOKEN"]
        },
        {
          name  = "AZP_AGENT_NAME"
          value = var.service
        },
        {
          name  = "AZP_STACK"
          value = var.stack
        }
      ]
    }
  }

  tags = local.default_tags
}
