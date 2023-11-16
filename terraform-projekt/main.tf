locals {
  bucket_name = "my-s3-bucket-uo1331iou123"
  
}


module "ec2" {
  source = "./modules/ec2"
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, this is user data!" > /tmp/user_data.txt
              aws s3 cp /tmp/user_data.txt s3://${local.bucket_name}/
              EOF
}



module "s3" {
  source = "./modules/s3"

  bucket_name = local.bucket_name
  bucket_encryption_enabled = true
}

module "role" {
  source = "./modules/iam"

  role_name = "MyEC2InstanceRole"
  policy_actions = [ "s3:*" ]
  policy_effect = "Allow"
  policy_resources = [module.s3.bucket_arn, "${module.s3.bucket_arn}/*"]
}