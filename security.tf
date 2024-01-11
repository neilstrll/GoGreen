module "bastion_security_group" {
    source = "../modules/bastion"
    vpc_id = "aws_vpc.vpc.id"
    security_groups = {
        "bastion" : {
            description     = "Load Balancer sg"
            ingress_rule = [
                {
                    from_port   = 22
                    to_port     = 22
                    protocol    = "tcp"
                    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from anywhere
                }
            ]
            egress_rule = [
                {
                    from_port   = 0
                    to_port     = 0
                    protocol    = "-1"
                    cidr_blocks = ["0.0.0.0/0"]
                }
            ]
        }
    }
}

module "aws_security_group" {
    source = ".//bastion"
    vpc_id = "aws_vpc.vpc.id"
    security_groups = {
        "app_sg" : {
            description = "App Tier SG"
            ingress_rules = [
                {
                    description      = "HTTPS"
                    from_port        = 8080
                    to_port          = 8080
                    protocol         = "tcp"
                    security_groups  = [module.aws_security_group_id["web_sg"]]             
                },
                {
                    description      = "FTP"
                    from_port        = 20
                    to_port          = 20
                    protocol         = "tcp"
                    security_groups  = [module.aws_security_group_id["bastion_sg"]]                  
                }
            ]

            egress_rules = [
                {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = ["0.0.0.0/0"]
                ipv6_cidr_blocks = ["::/0"]
                }
            ]

            tags = {
                Name = "app_sg"
            }
        }
    }
}

module "aws_security_group_1" {
    source = ".//bastion"
    vpc_id = "aws_vpc.vpc.id"
    security_groups = {
        "db_sg" : {
            description = "Data Tier SG"
            ingress_rules = [
                {
                    description      = "MySQL"
                    from_port        = 3306
                    to_port          = 3306
                    protocol         = "tcp"
                    security_groups  = [module.aws_security_group_id["app_sg"]]             
                }
            ]

            egress_rules = [
                {
                from_port        = 0
                to_port          = 0
                protocol         = "-1"
                cidr_blocks      = ["0.0.0.0/0"]
                ipv6_cidr_blocks = ["::/0"]
                }
            ]
        }
    }
}