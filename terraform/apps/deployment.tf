resource "kubernetes_deployment" "deployment" {

  for_each = { for application in local.json_data.applications: application.name => application }

  metadata {
    name = each.value.name
    namespace = "services"
  }

  spec {
    replicas = each.value.replicas
    selector {
      match_labels = {
        app = each.value.name
      }
    }
    template {
      metadata {
        labels = {
          app = each.value.name
        }
      }
      spec {
        container {
          name  = each.value.name
          image = each.value.image

          port {
            container_port = each.value.port
          }

					args = each.value.args

          resources {
            limits = {
              cpu    = "0.5"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}



