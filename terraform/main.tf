resource "kind_cluster" "default" {
  name           = "new"
  wait_for_ready = true
  node_image     = "kindest/node:v1.27.3"
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    networking {
      disable_default_cni = true
      pod_subnet          = "192.168.0.0/16"
    }

    node {
      role = "control-plane"
      extra_mounts {
        host_path      = "./data"
        container_path = "/data"
      }
    }

    node {
      role = "worker"
      labels = {
        app = "web"
      }
    }

    node {
      role = "worker"
      labels = {
        app = "web"
      }
    }
  }
}
