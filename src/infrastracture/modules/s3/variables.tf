variable "bucket_name" {
  type = string

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


variable "version_status" {
  default = "Disabled"
  type    = string
}