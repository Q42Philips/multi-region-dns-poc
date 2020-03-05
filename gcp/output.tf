# outputs

output "instance_ips" {
  value = ["${zipmap(google_compute_instance.vm.*.zone, google_compute_instance.vm.*.network_interface.0.access_config.0.nat_ip)}"]
}
