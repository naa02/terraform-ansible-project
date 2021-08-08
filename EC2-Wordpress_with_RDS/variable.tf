variable "instance_type" {
  description = "EC2 instanace type"
  type        = string
  default     = "t3.micro"
}

variable "project_name" {
  description = " Name of the project"
  type        = string
  default     = "wordpress_project"
}

variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "nayoung"
}

variable "wp_port" {
  description = "Wordpress service port"
  type        = number
  default     = 8080
}
