resource "aws_s3_bucket" "bucket" {
  bucket = "${var.user_name}.${var.bucket_name}.online"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}