resource "helm_release" "observability" {
  name             = var.release_name
  chart            = var.chart_dir
  namespace        = var.namespace
  create_namespace = true
  wait             = true
  timeout          = 900

  set {
    name  = "grafanaTargetGroupBinding.enabled"
    value = "true"
  }

  set {
    name  = "grafanaTargetGroupBinding.targetGroupArn"
    value = var.grafana_target_group_arn
  }

  set {
    name  = "grafanaTargetGroupBinding.targetType"
    value = "ip"
  }
}
