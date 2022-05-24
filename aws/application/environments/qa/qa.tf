# S3 remote state 

terraform {
 backend "s3" {
    bucket         = "tf-state-file02"  
    key            = "project/qa/ecs-app"
    region         = "us-west-2"
    dynamodb_table = "eks_ecommerce_dynamodb"

 }
}

module "node_ecs" {

   source                    = "../../"
   vpc_cidr                  = "172.31.0.0/16"
   public_subnets_cidr       = [ "172.31.6.0/24" , "172.31.7.0/24" ]
   private_subnets_cidr      = [ "172.31.8.0/24" , "172.31.9.0/24" ]
   create                    = true
   name                      = "node"
   namespace                 = "lightfeather"
   docker_image              = "873079457075.dkr.ecr.us-east-2.amazonaws.com/node-react-app:1.0"
   environment               = "nodejs"
   stage                     = "dev"
   aws_region                = "us-west-2"
   azs                       = ["us-west-2a" , "us-west-2b"]
   cloudwatch_log_group_name = "ecs/lightfeather-nodejs-dev"
   cloudwatch_log_stream     = "ecs"
   bucket_name               = "lightfeather-lb-logs"
   node_container_port       = "80"
   name_prefix               = "light-app"
   health_check_path         = "/"
   ami_id                    = "ami-03d64741867e7bb94"
   #public_subnet_id         = "subnet-097c6f21a3fc9e20a"
   PATH_TO_PUBLIC_KEY        = "mykey.pub"
   PATH_TO_PRIVATE_KEY       = "mykey"
   tag                       = "app-dev"
 
}
