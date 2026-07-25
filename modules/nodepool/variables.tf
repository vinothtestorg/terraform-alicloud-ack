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
