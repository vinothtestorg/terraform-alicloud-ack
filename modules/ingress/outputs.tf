output "addon_name" {
  description = "Installed ingress addon name"
  value       = alicloud_cs_kubernetes_addon.this.name
}
