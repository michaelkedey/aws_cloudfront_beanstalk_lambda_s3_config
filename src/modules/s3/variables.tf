variable "name" {
  
}

variable "tags_all" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  sensitive   = true
  default = {
    "Environment" = "production",
    "Owners"      = "bid_project"
  }
}

variable "file_path" {
  default = "./html"
}

variable "suffix" {
  default = "index.html"
  type = string
}

variable "version_status" {
  default = "Enabled"
  type = string
}

variable "acl" {
  default = "private"
  type = string
}