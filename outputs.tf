output "cluster_id" {
  description = "ACK cluster ID — consumed by node pool and addon components"
  value       = alicloud_cs_managed_kubernetes.this.id
}
output "cluster_name" {
  description = "ACK cluster name"
  value       = alicloud_cs_managed_kubernetes.this.name
}
