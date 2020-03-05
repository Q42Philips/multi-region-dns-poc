module "gcp" {

	# prepare: gcloud auth login
  source         = "./gcp"

	gcp_project = var.gcp_project # default: gcloud config get-value project / gcloud config set project [project]

	image_name  = var.image_name
}

# module "azure" {
#
# 	# prepare: az login
#   source         = "./azure"
#
#   # subscription_id = ... default: ARM_SUBSCRIPTION_ID
# 	# tenant_id = ... default: ARM_TENANT_ID
#
# 	image_name  = var.image_name
# }
