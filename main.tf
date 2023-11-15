provider "google" {
    project = "starlit-rite-400206"
    credentials = file("terformkey.json")
    region = "us-central1"
    zone = "us-central-a"
}
resource "google_compute_network" "custom_test" {
    name = "test-network"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
    name = "test-subnetwork"
    ip_cidr_range = "10.0.0.0/16"
    region = "us-central1"
    network = google_compute_network.custom-test.id
    secondary_ip_range {
        range_name = "tf-test-secondary-range-update1"
        ip_cidr_range = "10.0.0.0/16"
        network = google_compute_network.default.name
        next_hop_ip = "10.0.0.0/32"
        priority =100
    }
}
resource "google_compute_route" "default" {
    name = "network-route"
    dest_range = "10.0.0.0/24"

  
}
resource "google_compute_instance" "name" {
    name                           = "terraform-instance"
    machine_typ                    = "e2-medium"
    zone                           = "us-central-a"
    allow_stopping_for_update      = true

    boot_disk {
      initialize_params {
        image = "ubuntu-2004-focal-v20230918"
      }
    }
network_interface {
#   network = "default"
  network = google_compute_network.custom_test.name
  access_config {
        }
    }
}

resource "google_storage_bucket" "static" {
  name = "terraform_bkt"
  location = "US"
  storage_class = "STANDARD"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "default" {
    name = "file1"
    source="D:/DevOps/Resume"
    content_type="text/plain"
    bucket=google_storage_bucket.static.id  
}


