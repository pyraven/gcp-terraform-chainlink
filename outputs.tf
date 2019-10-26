variable "secure_port" {
  default = "6689"
}

locals {
  host = "https://${google_compute_instance.chainlink-node.network_interface.0.access_config.0.nat_ip}:${var.secure_port}"
}

output "chainlink-url" {
  value = "${local.host}"
}
