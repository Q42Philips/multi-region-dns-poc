# see also variables.tf network.tf output.tf

provider "google" {
  project = var.gcp_project
}

# GCE VM image

module "gce-container" {
  source         = "https://github.com/terraform-google-modules/terraform-google-container-vm/tarball/b452196e32e558234ac46a4078c66bf39fca2b14//terraform-google-modules-terraform-google-container-vm-b452196?archive=tgz"

  cos_image_name = var.host_os_image_name
  container = {
    image        = var.image_name
    volumeMounts = [{ mountPath = "/data", name = "tempfs-0", readOnly = false }]
  }
  volumes        = [{ name = "tempfs-0", emptyDir = { medium = "Memory" } }]
  restart_policy = "Always"
}

# GCE VM instances

resource "google_compute_instance" "vm" {
  count = length(var.zones)

  name  = "multi-region-dns-poc-${var.zones[count.index]}"
  machine_type = "f1-micro"
  zone         = var.zones[count.index]
  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }
  network_interface {
    network = google_compute_network.default.self_link
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
