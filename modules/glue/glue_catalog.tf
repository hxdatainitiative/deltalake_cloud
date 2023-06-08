resource "aws_glue_catalog_database" "main" {
  name = "hx_main_db"
  description = "Database to use as sandbox"
}