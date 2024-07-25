resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress"
  namespace = "nginx-ingress"
  repository = "oci://ghcr.io/nginxinc/charts/"
  chart      = "nginx-ingress"
  version    = "1.3.1"

#   set {
#     name  = "cluster.enabled"
#     value = "true"
#   }

#   set {
#     name  = "metrics.enabled"
#     value = "true"
#   }

#   set {
#     name  = "service.annotations.prometheus\\.io/port"
#     value = "9127"
#     type  = "string"
#   }
}
