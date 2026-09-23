locals {
  name = "${var.env}-${var.shreg}-${var.tag}"

  tags = merge(
    var.tags,
    {
      Name = local.name
      env  = var.env
      reg  = var.shreg
      unit = var.tag
    }
  )
}
