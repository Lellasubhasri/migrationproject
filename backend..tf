terraform {
    backend "s3" {
        bucket = "migration3-subha-lab"
        key = "talent-academy/backend/terraform.tfstates"
        region = "eu-central-1"
        dynamodb_table = "terraform-lock"
    }
}