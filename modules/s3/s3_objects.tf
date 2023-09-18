resource "aws_s3_object" "file_uploads" {
  for_each = fileset("${var.file_path}","${var.file_pattern}")

  bucket       = var.bucket
  key          = each.key
  source       = "${var.file_path}/${each.key}"
  etag         = filemd5("${var.file_path}/${each.key}")
}