variable "cluster_id" {
  description = "ACK cluster ID this addon installs into (wired from the cluster component)"
  type        = string
}
variable "addon_name" {
  description = "Ingress addon name"
  type        = string
  default     = "nginx-ingress-controller"
}
variable "addon_version" {
  description = "Ingress addon version"
  type        = string
  default     = ""
}
