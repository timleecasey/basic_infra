data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

resource "aws_ecr_repository" "repo" {
  name         = local.name
  force_delete = var.force
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = local.tags
}

resource "aws_ecr_lifecycle_policy" "untagged" {
  count      = var.expire_untagged ? 1 : 0
  repository = aws_ecr_repository.repo.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Expire untagged images older than ${var.untagged_expire_days} days"
      selection = {
        tagStatus   = "untagged"
        countType   = "sinceImagePushed"
        countUnit   = "days"
        countNumber = var.untagged_expire_days
      }
      action = {
        type = "expire"
      }
    }]
  })
}

resource "aws_ecr_repository_policy" "repo_policy" {
  repository = aws_ecr_repository.repo.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ecr_policy"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy",
          "ecr:ReplicateImage",
        ]
      },
      {
        Sid    = "ecr_policy_lambda"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
        ]
        Condition = {
          StringLike = {
            "aws:sourceArn" = "arn:aws:lambda:${data.aws_region.current.name}:${local.account_id}:function:*"
          }
        }
      },
    ]
  })
}
