resource "alicloud_cs_managed_kubernetes" "this" {
  name                 = var.name
  cluster_spec         = var.cluster_spec
  version              = var.kubernetes_version
  vswitch_ids          = var.vswitch_ids
  pod_cidr             = var.pod_cidr
  service_cidr         = var.service_cidr
  new_nat_gateway      = false
  slb_internet_enabled = false
  tags                 = var.tags
}
