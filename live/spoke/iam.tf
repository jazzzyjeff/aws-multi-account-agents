module "ado_custom_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name = "ado"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets"
        ]
        Resource = ["*"]
      }
    ]
  })
}
