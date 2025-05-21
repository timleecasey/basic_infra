terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }

  backend "gcs" {
    bucket = "tlc-demo-state"
    prefix = "terraform/demo/us-west-1/demo/hw"
  }

}

provider google {
  project = var.project_id
  region  = var.region
}
provider google-beta {
  project = var.project_id
  region  = var.region
}

variable "bucket_name"    {
  type = string
}
variable "db_connection"  {
  type = string
}

