resource "kubernetes_manifest" "virtualserver" {

  depends_on = [ kubernetes_namespace.services, kubernetes_deployment.deployment, kubernetes_namespace.services ]

  manifest = {
    "apiVersion" = "k8s.nginx.org/v1"
    "kind"       = "VirtualServer"
    "metadata" = {
      "name"      = "app-vs"
      "namespace" = "services"
    }
    "spec" = {
      "host"             = "app.com"
      "ingressClassName" = "nginx"
      "upstreams" = [for application in local.json_data.applications :
        {
          "name"    = application.name,
          "service" = application.name
          "port"    = application.port
        }
      ]
      "routes" = [
        {
          "path" : "/"
          "splits" = [for application in local.json_data.applications :
            {
              "weight" = application.traffic_weight,
              "action" = {
                "pass" = application.name
              }
            }
          ]
        }
      ]
    }
  }
}
