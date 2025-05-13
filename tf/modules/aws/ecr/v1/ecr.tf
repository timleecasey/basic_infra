
data "aws_caller_identity" "current" {
}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_ecr_repository" "repo" {
  name = "${var.env}-${var.shreg}-${var.tag}"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    env = "${var.env}"
    reg = "${var.shreg}"
    unit = "${var.tag}"
  }
}

resource "aws_ecr_repository_policy" "repo_policy" {
  repository = aws_ecr_repository.repo.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
    {
	Sid: "ecr_policy"
	Effect: "Allow"
	Principal: {
	  "AWS": "arn:aws:iam::${local.account_id}:root"
	}
	Action: [
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
      Sid: "ecr_policy_lamda",
      Effect: "Allow",
      Action: [
        "ecr:SetRepositoryPolicy",
        "ecr:GetRepositoryPolicy"
      ],
      Resource: "arn:aws:ecr:us-west-1:863670398045:repository/hello"
    },
    ],
  })
}

