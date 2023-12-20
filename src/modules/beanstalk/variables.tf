variable "name" {
  default = ".net_app"
  type    = string
}


variable "env" {
  default     = ["dev", "prod"]
  type        = list(string)
  description = "environment names"
}

variable "stack" {
  default = {
    linux   = "64bit Amazon Linux 2015.03 v2.0.3 running ASP.NET Core 6.0",
    windows = "64bit Windows Server 2022 v2.14.0 running ASP.NET Core 6.0"
  }
  type = map(string)
}

variable "tier" {
  type        = string
  description = "(optional) describe your variable"
  default     = ["Webserver"]
}

variable "app_desc" {
  type    = string
  default = "bid app"
}



#place holders
variable "bucket" { type = string }
variable "key" { type = string }
