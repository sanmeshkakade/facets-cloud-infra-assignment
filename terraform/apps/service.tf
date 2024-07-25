resource "kubernetes_service" "service" {
  for_each = { for application in local.json_data.applications: application.name => application }

  metadata {
    name = each.value.name
    namespace = "services"
  }
  spec {
    selector = {
      app = each.value.name
    }
    port {
      port        = each.value.port
      target_port = each.value.port
    }
    type = "ClusterIP"
  }
}
