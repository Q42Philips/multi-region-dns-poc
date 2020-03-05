module "gcp" {
  # https://www.terraform.io/docs/providers/google/index.html

	# prepare: gcloud auth login
  source         = "./gcp"

	gcp_project = var.gcp_project # default: gcloud config get-value project / gcloud config set project [project]

	image_name  = var.image_name
}

# module "azure" {
#   # https://www.terraform.io/docs/providers/azurerm/index.html
#
# 	# prepare: az login
#   source         = "./azure"
#
#   # subscription_id = ... default: ARM_SUBSCRIPTION_ID
# 	# tenant_id = ... default: ARM_TENANT_ID
#
# 	image_name  = var.image_name
# }

# outputs

output "instance_ips" {
	value = module.gcp.instance_ips
}

output "instance_urls" {
	value = module.gcp.instance_urls
}
