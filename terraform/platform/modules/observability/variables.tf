variable "chart_dir" {
  description = "Absolute path to the observability Helm chart directory."
  type        = string
}

variable "grafana_target_group_arn" {
  description = "NLB/ALB target group ARN for the Grafana TargetGroupBinding."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to deploy into."
  type        = string
  default     = "observability"
}

variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "observability"
}
