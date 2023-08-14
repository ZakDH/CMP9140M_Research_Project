terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

# Configure the Google Cloud Provider
provider "google" {
  credentials = file("key.json")
  project     = "cmp9792m-19694345"
  region      = "europe-west2" # Update with your desired region
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}