provider "google" {
    project = "altair-330820"
    region  = "asia-south1"
    credentials = "${file("creds.json")}"
}

resource "google_container_cluster" "primary" {
  name               = "marcellus-wallace"
  location           = "asia-south1"
  initial_node_count = 1
  node_config {
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      foo = "bar"
    }
    tags = ["foo", "bar"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}