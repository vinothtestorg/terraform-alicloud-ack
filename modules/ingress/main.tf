resource "alicloud_cs_kubernetes_addon" "this" {
  cluster_id = var.cluster_id
  name       = var.addon_name
  version    = var.addon_version
}
