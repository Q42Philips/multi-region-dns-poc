# outputs

output "instance_ips" {
  value = ["${zipmap(google_compute_instance.vm.*.zone, google_compute_instance.vm.*.network_interface.0.access_config.0.nat_ip)}"]
}

output "instance_urls" {
  value = ["${zipmap(google_compute_instance.vm.*.zone, formatlist("http://%s", google_compute_instance.vm.*.network_interface.0.access_config.0.nat_ip))}"]
}