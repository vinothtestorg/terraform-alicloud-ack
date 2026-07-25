resource "alicloud_cs_kubernetes_node_pool" "this" {
  cluster_id       = var.cluster_id
  node_pool_name   = var.name
  instance_types   = var.instance_types
  system_disk_size = var.system_disk_size
  desired_size     = var.desired_size
  vswitch_ids      = var.vswitch_ids
  tags             = var.tags
}
