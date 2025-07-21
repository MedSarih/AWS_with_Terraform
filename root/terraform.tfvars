region       = "us-east-1"
project_name = "cloudproject"

vpc_cidr = "10.0.0.0/16"
#public subnet for NAT gateway
pub_sub_1a_cidr = "10.0.1.0/24"
pub_sub_2b_cidr = "10.0.2.0/24"
#public subnet for webserver
pri_sub_3a_cidr = "10.0.3.0/24"
pri_sub_4b_cidr = "10.0.4.0/24"
#public subnet for DataBase 
pri_sub_5a_cidr = "10.0.5.0/24"
pri_sub_6b_cidr = "10.0.6.0/24"

db_username             = "admin"
db_password             = "Mohammeds2003."

certificate_domain_name = "medsinfo.xyz"
additional_domain_name  = "www.medsinfo.xyz"