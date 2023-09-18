### Intake log DynamoDB Table ###

module "dynamodb_intake_log" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name                        = "${local.project_name}-intake-log"
  hash_key                    = "id"
  range_key                   = "intake_process"
  table_class                 = "STANDARD"
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = false

  attributes = [
    {
      name = "id"
      type = "N"
    },
    {
      name = "intake_process"
      type = "S"
    },
    {
      name = "status"
      type = "S"
    },
    {
      name = "timestamp"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "ProcessIndex"
      hash_key        = "intake_process"
      range_key       = "timestamp"
      projection_type = "KEYS_ONLY"
    },
    {
      name            = "StatusIndex"
      hash_key        = "status"
      range_key       = "timestamp"
      projection_type = "KEYS_ONLY"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

### Quality log DynamoDB Table ###

module "dynamodb_data_quality_log" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name                        = "${local.project_name}-quality-log"
  hash_key                    = "id"
  range_key                   = "quality_process"
  table_class                 = "STANDARD"
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = false

  attributes = [
    {
      name = "id"
      type = "N"
    },
    {
      name = "quality_process"
      type = "S"
    },
    {
      name = "status"
      type = "S"
    },
    {
      name = "timestamp"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "ProcessIndex"
      hash_key        = "quality_process"
      range_key       = "timestamp"
      projection_type = "KEYS_ONLY"
    },
    {
      name            = "StatusIndex"
      hash_key        = "status"
      range_key       = "timestamp"
      projection_type = "KEYS_ONLY"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

### Delta Lake lock table for concurrent writing ###

module "dynamodb_deltalake_lock_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name                        = "${local.project_prefix}_lock_table"
  hash_key                    = "key"
  table_class                 = "STANDARD"
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = false

  attributes = [
    {
      name = "key"
      type = "S"
    }
  ]
### To be set when billing mode is PROVISIONED ###
  # read_capacity  = 10
  # write_capacity = 10

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
