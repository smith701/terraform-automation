resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
    namespace = "${local.namespace}"

    labels {
      app = "nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "mounikavenna1281991/nginx"

          port {
            container_port = 80
          }
        }

      }
    }
  }
}

##############################resoure of nodejs##################
resource "kubernetes_deployment" "nodejs" {
  metadata {
    name = "nodejs"
    namespace = "${local.namespace}"

    labels {
      app = "nodejs"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "nodejs"
      }
    }

    template {
      metadata {
        labels {
          app = "nodejs"
        }
      }

      spec {
        container {
          name  = "nodejs"
          image = "mounikavenna1281991/nodejs"

          port {
            container_port = 3001
          }
        }

      }
    }
  }
}
##############################service file for nodejssvc#####################
resource "kubernetes_service" "nodejssvc" {
  metadata {
    name      = "nodejssvc"
    namespace = "${local.namespace}"
    labels {
      app = "nodejs"
    }
  }
  spec {
    port {
      name        = "nodejssvc"
      protocol    = "TCP"
      port        = 3001
      target_port = "3001"
    }
    selector {
      app = "nodejs"
    }
  }
} 

###########################service file for nginx#################################
resource "kubernetes_service" "svc" {
  metadata {
    name      = "svc"
    namespace = "${local.namespace}"
    labels {
      app = "nginx"
    }
  }

  spec {
    port {
      name        = "svc"
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }

    selector {
      app = "nginx"
    }

    type = "LoadBalancer"
  }
}

#########################variables file #########################################

variable "namespace" {
  description = "Namespace, which could be your organization name, e.g. `cp` or `cloudposse`"
}

variable "stage" {
  description = "Stage, e.g. `prod`, `staging`, `dev`, or `test`"
}

variable "name" {
  description = "Solution name, e.g. `app`"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `name`, `stage` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes, e.g. `1`"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map(`BusinessUnit`,`XYZ`)"
}

variable "convert_case" {
  description = "Convert fields to lower case"
  default     = "true"
}

################################## variables for node creation########
variable "project_id" {
  description = "The name of the project_id"
  default    = "applied-fusion-241610"
}

variable "region" {
  description = "The names of the project_region"
  default     = "us-east4"
}

variable "node_name" {
  type       = "string"
  description = "The name of the Node Pool"
}

variable "zone" {
  description = "In which zone to create the Node Pool"
  default     = "us-east4-c"
}


variable "node_count" {
  type   = "string"
  description = "The number of nodes to create in this Node Pool"
}

variable "cluster_name" {
  description = "Name of the cluster to which to add this Node Pool"
}

variable "machine_type" {
  description = "The type of machine to use for nodes in the pool"
  default     = "n1-standard-1"
}

variable "disk_size_gb" {
  description = "Disk of which size to attach to the nodes in the pool "
  default     = "10"
}

variable "image_type" {
  description = "The image type to use for nodes. See supported image types https://cloud.google.com/kubernetes-engine/docs/concepts/node-images"
  default     = "COS"                                                                                                                             # Container-Optimized OS
}

###################################outputs file########################
output "id" {
  value       = "${local.id}"
  description = "Disambiguated ID"
}

output "name" {
  value       = "${local.name}"
  description = "Normalized name"
}

output "namespace" {
  value       = "${local.namespace}"
  description = "Normalized namespace"
}

output "stage" {
  value       = "${local.stage}"
  description = "Normalized stage"
}

output "attributes" {
  value       = "${local.attributes}"
  description = "Normalized attributes"
}

output "tags" {
  value       = "${local.tags}"
  description = "Normalized Tag map"
}


