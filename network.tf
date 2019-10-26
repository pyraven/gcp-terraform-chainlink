resource "google_compute_network" "vpc" {
  name                    = "chainlink-network"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet" {
  name             = "chainlink-subnetwork"
  ip_cidr_range    = "10.131.0.0/16"
  region           = "${var.region}"
  network          = "${google_compute_network.vpc.self_link}"
  enable_flow_logs = false
}
