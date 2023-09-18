resource "aws_iam_policy" "lambda_s3_access" {
  name   = "lambda_common_s3_access"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::hx-datainitiative*"
      ]
    }
  ]
}
EOF
}

module "insert_raw_data_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${local.project_prefix}_raw_intake"
  description   = "Tomar datos desde internet"
  handler       = "${local.project_prefix}_raw_intake.lambda_handler"
  runtime       = "python3.10"
  source_path   = "../code/lambdas/hx_deltalake_raw_intake.py"

  memory_size = 1024
  timeout     = 10

  attach_policy = true
  policy        = aws_iam_policy.lambda_s3_access.arn

  layers = [
    "arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python310:4",
    aws_lambda_layer_version.yfinance.arn
  ]
}

module "insert_raw_deltatable_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${local.project_prefix}_deltatable_intake"
  description   = "Insertar datos recibidos en la capa Bronce"
  handler       = "${local.project_prefix}_deltatable_intake.lambda_handler"
  runtime       = "python3.10"
  source_path   = "../code/lambdas/intake_deltatable.py"

  memory_size = 1024
  timeout     = 10

  attach_policy = true
  policy        = aws_iam_policy.lambda_s3_access.arn

  layers = [
    "arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python310:4",
    aws_lambda_layer_version.deltalake.arn
  ]

  environment_variables = {
    AWS_S3_LOCKING_PROVIDER         = "dynamodb"
    DYNAMO_LOCK_PARTITION_KEY_VALUE = "key"
    DYNAMO_LOCK_TABLE_NAME          = "delta_lock_table"
  }
}
