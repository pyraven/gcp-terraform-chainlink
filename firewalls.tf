resource "google_compute_firewall" "allow-chainlink-ssh" {
  name    = "allow-chainlink-ssh"
  network = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction     = "INGRESS"
  source_ranges = ["${var.ipaddress}"]
}

resource "google_compute_firewall" "allow-chainlink-gui" {
  name    = "allow-chainlink-gui"
  network = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["6689"]
  }

  direction     = "INGRESS"
  source_ranges = ["${var.ipaddress}"]
}

resource "google_compute_firewall" "allow-internal-eth-traffic" {
  name    = "allow-internal-eth-traffic"
  network = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "all"
  }

  direction     = "INGRESS"
  source_ranges = ["172.16.0.0/12"]
}
