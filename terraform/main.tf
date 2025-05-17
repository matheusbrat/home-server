terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "cloudflare_account_id" {
  type        = string
  description = "Your Cloudflare Account ID"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Your Cloudflare API Token"
}

variable "domain_name" {
  type        = string
  description = "Your domain name"
  default     = "matbra.com"
}

variable "tunnel_name" {
  type        = string
  description = "The name of the Cloudflare Tunnel"
  default     = "matbra-home-tunnel"
}

variable "ip_range" {
  type        = string
  description = "The IP range of your home network"
  default     = "192.168.68.0/24"
}

# Create a Cloudflare Tunnel. This sets up the connection point
# between your home network and Cloudflare's network.
resource "cloudflare_zero_trust_tunnel_cloudflared" "home_tunnel" {
  account_id = var.cloudflare_account_id
  name       = var.tunnel_name
  secret     = var.tunnel_secret
}

# Create a Cloudflare Tunnel route. This tells Cloudflare to route
# traffic for your home network's IP range through the tunnel.
resource "cloudflare_zero_trust_tunnel_route" "home_network_route" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.home_tunnel.id
  network    = var.ip_range # Add the network argument here, use the ip_range variable
}

# Create a Cloudflare Access application for the general home network access.
resource "cloudflare_zero_trust_access_application" "home_network_app" {
  account_id = var.cloudflare_account_id
  name       = "Matbra Home Network Access Application"
  #domain     = "home.${var.domain_name}" #  home.matbra.com
  session_duration = "24h"
}

# Create a Cloudflare Zero Trust policy to control access to the resources
# behind the tunnel.
resource "cloudflare_zero_trust_access_policy" "home_network_policy" {
  application_id = cloudflare_zero_trust_access_application.home_network_app.id
  account_id = var.cloudflare_account_id
  name       = "Matbra Home Network Access Policy"
  precedence = 1
  decision   = "allow"

  include {
    email = ["matheusbrat@gmail.com"]
  }
}

output "tunnel_token" {
  description = "Cloudflare Tunnel Token"
  value = cloudflare_zero_trust_tunnel_cloudflared.home_tunnel.tunnel_token
  sensitive   = true
}

variable "tunnel_secret" {
  type = string
  description = "The secret for the Cloudflare Tunnel"
  sensitive = true #  Mark the variable as sensitive
}

