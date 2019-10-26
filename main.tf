provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}

resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_compute_instance" "chainlink-node" {
  name         = "chainlink-node"
  machine_type = "custom-2-9216"
  zone         = "${var.region}-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
      size  = 1500
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet.self_link}"
    access_config {
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
    ssh-keys       = "ubuntu:${tls_private_key.ssh-key.public_key_openssh} ubuntu"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh-key.private_key_pem
    host        = google_compute_instance.chainlink-node.network_interface.0.access_config.0.nat_ip
  }

  provisioner "file" {
    source      = "./scripts/docker-install.sh"
    destination = "/tmp/docker-install.sh"
  }

  provisioner "file" {
    source      = "./scripts/chainlink-install.sh"
    destination = "/tmp/chainlink-install.sh"
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/docker-install.sh", "sh /tmp/docker-install.sh", "rm /tmp/docker-install.sh"]
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/chainlink-install.sh", "sh /tmp/chainlink-install.sh", "rm /tmp/chainlink-install.sh"]
  }
}