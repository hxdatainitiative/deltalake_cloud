output "files" {
  value = tomap({for key, value in aws_s3_object.file_uploads : key => value}) 
}