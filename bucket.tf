resource "aws_s3_bucket" "state_file_bucket" {
    bucket = "migration3-subha-lab"
    tags = {
        Name = "migration3-subha-lab"
        Environment = "Lab"
    }
    lifecycle {
        prevent_destroy = true
    }
}
resource "aws_s3_bucket_versioning" "version_my_bucket" {
    bucket = aws_s3_bucket.state_file_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 30
}


resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.state_file_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_kms_alias" "mykeyalias"{
  name = "alias/backendkms"
  target_key_id = aws_kms_key.mykey.key_id
  
}
resource "aws_dynamodb_table" "terraform_lock_tbl1" {
  name           = "terraform-lock1"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"
    attribute {
    name = "LockID"
    type = "S"
  }
  tags           = {
    Name = "terraform-lock2"
  }
}
