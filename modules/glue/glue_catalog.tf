resource "aws_glue_catalog_database" "main" {
  count = var.create_database ? 1 : 0
  name = "hx_main_db"
  description = "Database to use as sandbox"
}