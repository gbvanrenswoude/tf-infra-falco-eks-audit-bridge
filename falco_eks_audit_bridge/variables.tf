###### AWS variables

variable region {
  default = "eu-west-1"
}

####### Deployment variables

variable account_id {
  type    = "string"
  default = "111111111111"
}

variable deploy_role {
  default = "somerole"
}

variable env {
  description = "Unique environment identifier"
  default     = "dev"
}
