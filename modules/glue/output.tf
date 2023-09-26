output "glue_job" {
  value = aws_glue_job.glue_job
}

output "glue_crawler" {
  value = aws_glue_crawler.this 
}

output "glue_catalog_database" {
  value = aws_glue_catalog_database.main
}