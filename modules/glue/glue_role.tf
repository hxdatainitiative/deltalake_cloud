data "aws_iam_policy_document" "glue_role" {
  statement {
    sid     = "1"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "glue_policy" {
  # Upcoming version 
  statement {
    effect = "Allow"
    actions = [
      "glue:*",
      "s3:ListBucket",
      "s3:*",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeRouteTables",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcAttribute",
      "iam:ListRolePolicies",
      "iam:GetRole",
      "iam:GetRolePolicies",
      "cloudwatch:PutMetricData",
      "lambda:invoke",
      "logs:*"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "glue_policy" {
  name        = "${local.name}-glue-service-policy"
  description = "Policy to use in Glue"
  policy      = data.aws_iam_policy_document.glue_policy.json
}

resource "aws_iam_role" "glue_role" {
  name        = "${local.name}_role"
  description = "Glue Role for ${var.name}"

  assume_role_policy = data.aws_iam_policy_document.glue_role.json

  lifecycle {
    create_before_destroy = true
  }
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_policy.arn
}
