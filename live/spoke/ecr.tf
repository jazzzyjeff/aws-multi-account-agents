module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 3.0"

  repository_name = var.service

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = local.default_tags
}

resource "docker_image" "ado" {
  name = "${module.ecr.repository_url}:latest"
  build {
    context    = "${path.module}/workloads/ado-agent/docker"
    dockerfile = "${path.module}/workloads/ado-agent/docker/Dockerfile"
  }
  platform = "linux/arm64"
}

resource "docker_registry_image" "ado" {
  name = docker_image.ado.name
}
