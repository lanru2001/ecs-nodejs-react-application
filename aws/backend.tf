# S3 remote state 
terraform {
 backend "s3" {
    bucket         = "lightfeather-project"  
    key            = "project/eks"
    region         = "us-east-2"
    dynamodb_table = "lightfeather_dynamodb"

 }
} 
