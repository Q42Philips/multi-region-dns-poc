variable "gcp_project" {
  type    = string
  default = "tbd"
}

variable "image_name" {
  type        = string
  description = "The image name to deploy"
  default     = "hermanbanken/zone-printer:latest"
}
