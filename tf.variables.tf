variable "gcp_project" {
  type    = string
  default = "tbd"
}

variable "image_name" {
  type        = string
  description = "The image name to deploy"
  default     = "hermanbanken/zone-printer:latest"
}

variable "host_os_image_name" {
  type    = string
  default = "cos-stable-69-10895-71-0"
}

variable "zones" {
  type        = list
  description = "The zones to deploy in"
  default = [
    "asia-east1-a",
    "asia-east2-a",
    "asia-northeast2-a",
    "asia-south1-a",
    "europe-north1-a",
    "europe-west4-a",
    "southamerica-east1-a",
    "us-east1-b",
    "us-west2-a",
    "us-central1-a"
  ]
}
