variable "name" {
  description = "Cluster name"
  type        = string
}
variable "cluster_spec" {
  description = "ACK cluster spec (platform-resolved from the t-shirt size)"
  type        = string
}
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.32.1-aliyun.1"
}
variable "vswitch_ids" {
  description = "VSwitch IDs (platform-injected)"
  type        = list(string)
}
variable "pod_cidr" {
  description = "Pod CIDR (platform-injected)"
  type        = string
}
variable "service_cidr" {
  description = "Service CIDR (platform-injected)"
  type        = string
}
variable "tags" {
  description = "Mandatory governance tags (platform-injected)"
  type        = map(string)
  default     = {}
}
