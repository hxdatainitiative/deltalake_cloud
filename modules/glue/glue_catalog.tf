resource "aws_glue_catalog_database" "main" {
  count       = var.create_database ? 1 : 0
  name        = var.name
  description = "Database to use as sandbox"
}
