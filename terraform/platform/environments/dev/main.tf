data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "alexanderkachar-terraform-state"
    key    = "eks-portfolio-project-charlie/infra/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

module "observability" {
  source = "../../modules/observability"

  chart_dir                = "${path.module}/../../../../charts/observability"
  grafana_target_group_arn = local.infra.grafana_target_group_arn
}
