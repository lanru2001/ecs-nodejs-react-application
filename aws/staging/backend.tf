# S3 remote state 

terraform {
 backend "s3" {
    bucket         = "tf-remote-bkt"  
    key            = "project/ecs"
    region         = "us-east-2"
    dynamodb_table = "eks_ecommerce_dynamodb"

 }
}
