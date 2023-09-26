resource "aws_glue_catalog_database" "main" {
  count       = var.database_name != "None" ? 1 : 0
  name        = var.database_name
  description = "Database to use as sandbox"
}
