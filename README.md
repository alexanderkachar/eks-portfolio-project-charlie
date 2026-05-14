# eks-portfolio-project-charlie

An end-to-end Amazon EKS platform with private cluster networking, GitOps-driven deployments via ArgoCD, and a self-contained CI runner — provisioned entirely with Terraform.

## Architecture

The VPC spans two AZs with four subnet tiers — public (ALB, NAT), private (EKS nodes and pods), runner (self-hosted runner, bastion), and DB (reserved). A single NAT Gateway in the public-A subnet provides egress for the private and runner tiers. The EKS API endpoint is private-only; the control plane is unreachable from the internet.

## Repository Structure

`app/` — the Node.js/Express application, Dockerfile, and `docker-compose.yml` for local runs.

`charts/express-app/` — Helm chart for the application, including `TargetGroupBinding` for ALB registration. `values-override.yaml` is managed by ArgoCD Image Updater.

`charts/argocd/` — ArgoCD `Application` manifests and the git credentials secret.

`charts/observability/` — umbrella chart pulling in kube-prometheus-stack, Loki, and Promtail, plus a Grafana dashboard ConfigMap.

`terraform/infra/` — VPC, EKS, ECR, ALB, Route 53, IAM/OIDC, bastion, and self-hosted runner modules.

`terraform/platform/` — in-cluster platform layer: ArgoCD and the observability stack.

`.github/workflows/deploy-app.yml` — builds the app image on the self-hosted runner and pushes to ECR. The cluster is never contacted from CI; ArgoCD reconciles from git.

`scripts/connect-bastion.sh` — SSM Session Manager entry point to the bastion.

## GitOps Flow

1. Push to `main` triggers `deploy-app.yml` on the self-hosted runner.
2. Runner builds and pushes `…/project-charlie-dev-app:<sha>` to ECR.
3. ArgoCD Image Updater detects the new tag (`newest-build` strategy) and commits `image.tag` to `charts/express-app/values-override.yaml`.
4. ArgoCD detects the commit and reconciles the cluster — sync, prune, and self-heal are all enabled.

Git is the single source of truth for cluster state.
