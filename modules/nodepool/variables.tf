variable "cluster_id" {
  description = "ACK cluster ID this node pool attaches to (wired from the cluster component)"
  type        = string
}
variable "name" {
  description = "Node pool name"
  type        = string
}
variable "instance_types" {
  description = "ECS instance types (platform-resolved from the t-shirt size)"
  type        = list(string)
}
variable "system_disk_size" {
  description = "System disk size in GB (platform-resolved)"
  type        = number
  default     = 60
}
variable "desired_size" {
  description = "Node count"
  type        = number
  default     = 2
}
variable "vswitch_ids" {
  description = "VSwitch IDs (platform-injected)"
  type        = list(string)
}
variable "tags" {
  description = "Mandatory governance tags (platform-injected)"
  type        = map(string)
  default     = {}
}

variable "image_type" {
  description = "Node OS image family (catalog-pinned; rotated fleet-wide during upgrades)"
  type        = string
}

variable "runtime_name" {
  description = "Container runtime (catalog-pinned)"
  type        = string
}

variable "runtime_version" {
  description = "Container runtime version (catalog-pinned; must track the control plane)"
  type        = string
}
