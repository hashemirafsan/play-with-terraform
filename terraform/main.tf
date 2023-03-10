variable "token" {
  description = "Set digitalocean token"
}

variable "ssh_key_id" {
  description = "Set digitalocean ssh key"
}

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = "${var.token}"
}

resource "digitalocean_droplet" "terraform_droplet" {
  name      = "terraform-test"
  image     = "ubuntu-20-04-x64"
  region    = "nyc3"
  size      = "s-1vcpu-1gb"
  ssh_keys  = [ 
    "${var.ssh_key_id}"
  ]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y software-properties-common",
      "sudo add-apt-repository -y ppa:ondrej/php",
      "sudo apt-get update",
      "sudo apt-get install -y php8.1",
      "sudo apt-get install -y php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath php8.1-intl php8.1-fpm",
      "sudo apt-get install -y supervisor"
    ]
  }
}

output "droplet_output" {
  value = digitalocean_droplet.terraform_droplet.ipv4_address
}