data "aws_iam_policy_document" "glue_role" {
  statement {
    sid     = "RoleFor${var.name}"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazon.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "glue_policy" {
  statement {
    effect = "Allow"
    actions = [
        "glue:*",
        "s3:ListBucket",
        "s3:ListAllMyBuckets",
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
        "cloudwatch:PutMetricData"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    
  }
}

resource "aws_iam_policy" "glue_policy" {
  name = "${var.name}-glue-service-policy"
  description = "Policy to use in Glue"
  policy = data.aws_iam_policy_document.glue_policy.json
}

resource "aws_iam_role" "glue_role" {
  name = "${var.name}_role"
  description = "Glue Role for ${var.name}"

  assume_role_policy = data.aws_iam_policy_document.glue_role.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_policy.arn
}