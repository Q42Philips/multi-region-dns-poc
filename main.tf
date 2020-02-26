variable "image_name" {
  type        = string
  description = "The image name to deploy"
  default = "hermanbanken/zone-printer:latest"
}

variable "cos_image_name" {
  type        = string
  default     = "cos-stable-69-10895-71-0"
}

variable "zones" {
	type = list
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

provider "google" {
  project = "cl-dev"
}

module "gce-container" {
  source = "git::https://github.com/terraform-google-modules/terraform-google-container-vm?ref=b452196e32e558234ac46a4078c66bf39fca2b14"
  cos_image_name = var.cos_image_name
  container = {
    image = var.image_name
    volumeMounts = [{ mountPath = "/data", name      = "tempfs-0", readOnly  = false }]
  }
  volumes = [{ name = "tempfs-0", emptyDir = { medium = "Memory" } }]
  restart_policy = "Always"
}

resource "google_compute_network" "default" {
  provider = google
  name                    = "multi-region-dns-poc"
  auto_create_subnetworks = true
  routing_mode            = "GLOBAL"
}

resource "google_compute_firewall" "http" {
  name    = "${google_compute_network.default.name}-firewall-http"
  network = google_compute_network.default.name
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  target_tags   = ["${google_compute_network.default.name}-firewall-http"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm" {
  provider = google

	count = "${length(var.zones)}"
	name = "multi-region-dns-poc-${var.zones[count.index]}"

  machine_type = "f1-micro"
  zone         = var.zones[count.index]
  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }
  network_interface {
    network    = google_compute_network.default.self_link
    access_config {}
  }
  tags = ["container-vm", "${google_compute_network.default.name}-firewall-http"]
  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
  }
  labels = {
    container-vm = module.gce-container.vm_container_label
  }
  service_account {
    scopes = [
      "cloud-platform", "logging-write", "storage-full"
    ]
  }
  allow_stopping_for_update = true
}

output "instance_ips" {
  value = ["${zipmap(google_compute_instance.vm.*.zone,google_compute_instance.vm.*.network_interface.0.access_config.0.nat_ip)}"]
}
