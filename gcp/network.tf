# network

resource "google_compute_network" "default" {
  name                    = "multi-region-dns-poc"
  auto_create_subnetworks = true
  routing_mode            = "GLOBAL"
}

# firewall

resource "google_compute_firewall" "http" {
  name    = "${google_compute_network.default.name}-firewall-http"
  network = google_compute_network.default.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags   = ["${google_compute_network.default.name}-firewall-http"]
  source_ranges = ["0.0.0.0/0"]
}
