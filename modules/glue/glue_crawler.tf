resource "aws_glue_crawler" "this" {
  count = var.crawler_name != "None" ? 1 : 0
  name  = var.crawler_name

  database_name = var.database_name != "None" ? var.database_name : aws_glue_catalog_database.main[count.index].name
  role          = aws_iam_role.glue_role.arn

  delta_target {
    create_native_delta_table = var.create_native_delta_table
    delta_tables              = var.delta_tables_locations
    write_manifest            = var.write_manifest
  }
}
