provider "google" {}

module "gce_org_prod_workers" {
  source = "github.com/travis-infrastructure/tf_gce_travis_worker"
  instance_count = 10
  site = "org"
  environment = "prod"
  machine_type = "g1-small"
  zone = "us-central1-b"
  image = "${atlas_artifact.travis-worker-gce-image.id}"
}

module "gce_com_prod_workers" {
  source = "github.com/travis-infrastructure/tf_gce_travis_worker"
  instance_count = 10
  site = "com"
  environment = "prod"
  machine_type = "g1-small"
  zone = "us-central1-b"
  image = "${atlas_artifact.travis-worker-gce-image.id}"
}

module "gce_org_staging_workers" {
  source = "github.com/travis-infrastructure/tf_gce_travis_worker"
  instance_count = 1
  site = "org"
  environment = "staging"
  machine_type = "g1-small"
  zone = "us-central1-b"
  image = "${atlas_artifact.travis-worker-gce-image.id}"
}

module "gce_com_staging_workers" {
  source = "github.com/travis-infrastructure/tf_gce_travis_worker"
  instance_count = 1
  site = "com"
  environment = "staging"
  machine_type = "g1-small"
  zone = "us-central1-b"
  image = "${atlas_artifact.travis-worker-gce-image.id}"
}

resource "google_compute_instance" "tmate-edge" {
  count = "${var.instance_count}"
  name = "travis-tmate-edge-gce-${var.site}-${var.environment}-${count.index + 1}"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"
  tags = ["tmate-edge", "${var.environment}", "${var.site}"]

  can_ip_forward = false

  disk {
    auto_delete = true
    image = "${var.image}"
    type = "pd-ssd"
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral IP
    }
  }

  metadata_startup_script = "${file(format("cloud-init/travis-tmate-edge-gce-%s-%s", var.site, var.environment))}"
}

module "gce_org_prod_tmate_edge" {
  source = "github.com/travis-infrastructure/tf_gce_travis_worker"
  instance_count = 1
  site = "org"
  environment = "prod"
  machine_type = "g1-small"
  zone = "us-central1-b"
  image = "${atlas_artifact.travis-tmate-edge-gce-image.id}"
}

module "gce_com_prod_tmate_edge" {
  source = "github.com/travis-infrastructure/tf_gce_travis_worker"
  instance_count = 1
  site = "com"
  environment = "prod"
  machine_type = "g1-small"
  zone = "us-central1-b"
  image = "${atlas_artifact.travis-tmate-edge-gce-image.id}"
}

resource "google_compute_instance" "ubuntu_trusty_micro_playground" {
  count = 1
  name = "ubuntu-trusty-micro-playground"
  machine_type = "f1-micro"
  zone = "us-central1-f"
  tags = ["playground"]

  can_ip_forward = false

  disk {
    auto_delete = true
    image = "ubuntu-1404-trusty-v20150909a"
    type = "pd-standard"
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral IP
    }
  }
}
