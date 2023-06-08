resource "aws_s3_bucket_object" "file_uploads" {
  for_each = fileset("${path.module}${var.file_path}","${var.file_pattern}")

  bucket       = var.bucket
  key          = each.key
  source       = "${path.module}${var.file_path}/${each.key}"
  etag         = filemd5("${path.module}${var.file_path}/${each.key}")
}