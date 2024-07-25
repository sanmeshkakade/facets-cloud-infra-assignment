resource "kubernetes_namespace" "services" {
  metadata {
    name = "services"
  }
}
