terraform {
  backend "remote" {
    organization = "lkcultimate"

    workspaces {
      name = "ulti-photo-organiser"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

module "terraform" {
  source = "./terraform"
}