
# variable "public_subnets" {
#   description = "A list of public subnets inside the VPC"
#   type        = list(string)
#   default     = []
# }

# variable "private_subnets" {
#   description = "A list of private subnets inside the VPC"
#   type        = list(string)
#   default     = []
# }

# # variable "outpost_subnets" {
# #   description = "A list of outpost subnets inside the VPC"
# #   type        = list(string)
# #   default     = []
# # }

# variable "database_subnets" {
#   description = "A list of database subnets"
#   type        = list(string)
#   default     = []
# }

# variable "pub" {
#   type = number
#   default = 0
#   }
# variable "priva" {
#   type = number
#   default = 0
  
# }

# variable "ami" {
#   type = string
# }

# variable  "instance_type" {
#   type = string
# }

variable "project_source1" {
  default = "../modules/ec2/one"
}
variable "project_source2" {
  default = "../modules/ec2/two"
}

variable "project_source3" {
  default = "../modules/ec2/three"
}