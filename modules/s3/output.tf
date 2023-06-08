output "files" {
  value = tomap({for key, value in aws_s3_bucket_object.file_uploads : key => value}) 
}