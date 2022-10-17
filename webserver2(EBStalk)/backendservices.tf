// create MYSQL, elasticache and AmazonMQ services
//create db subnet group
resource "aws_db_subnet_group" "dbsubnetgrp" {
  name       = "db_subnetgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  tags = {
    Name = "My DB subnet group"
  }
}

//create elastic cache subnet group
resource "aws_elasticache_subnet_group" "elasticachegrp" {
  name       = "elasticachegrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  tags = {
    Name = "My elastic cache subnet group"
  }
}

//create db and its parameters
resource "aws_db_instance" "mysqldb" {
  allocated_storage      = 10
  storage_type           = "gp2"
  db_name                = var.dbname
  engine                 = "mysql"
  engine_version         = "5.6.34"
  instance_class         = "db.t2.micro"
  username               = var.dbuser
  password               = var.dbpass
  parameter_group_name   = "default.mysql5.6"
  skip_final_snapshot    = true
  multi_az               = "false"
  publicly_accessible    = "false"
  db_subnet_group_name   = aws_db_subnet_group.dbsubnetgrp.name
  vpc_security_group_ids = [aws_security_group.backendsg.id]
}

//create elasticcache and its paramater
resource "aws_elasticache_cluster" "myelasticache" {
  cluster_id           = "myelasticache"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.5"
  port                 = 11211
  security_group_ids   = [aws_security_group.backendsg.id]
  subnet_group_name    = aws_elasticache_subnet_group.elasticachegrp.name
}

// create a Active MQ and its parameter
resource "aws_mq_broker" "mq" {
  broker_name        = "mq"
  engine_type        = "ActiveMQ"
  engine_version     = "5.15.0"
  host_instance_type = "mq.t2.micro"
  security_groups    = [aws_security_group.backendsg.id]
  subnet_ids         = [module.vpc.private_subnets[0]]
  user {
    username = var.rmquser
    password = var.rmqpass
  }
}