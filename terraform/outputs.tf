output "tunnel_token" {
  description = "Cloudflare Tunnel Token"
  value = cloudflare_zero_trust_tunnel_cloudflared.home_tunnel.tunnel_token
  sensitive   = true
}