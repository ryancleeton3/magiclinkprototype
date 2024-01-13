# main.tf

provider "aws" {
  region = "us-west-2" # Example region, change as needed
}

resource "aws_db_instance" "creditors_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "12.4"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "yourpassword" # Replace with secure password
  parameter_group_name = "default.postgres12"
  skip_final_snapshot  = true
}

# Add additional configurations as needed
