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

variable "tunnel_secret" {
  type = string
  description = "The secret for the Cloudflare Tunnel"
  sensitive = true #  Mark the variable as sensitive
}