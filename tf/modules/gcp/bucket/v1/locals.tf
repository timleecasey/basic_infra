

locals {
  bucket_name = "${var.company}-${var.group}-${var.env}-${var.project}-${var.region}-${var.archival_storage_class}"
}
