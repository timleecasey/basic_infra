locals {
  name       = "${var.env}-${var.shreg}-${var.tag}"
  account_id = data.aws_caller_identity.current.account_id

  tags = merge(
    var.tags,
    {
      env  = var.env
      reg  = var.shreg
      unit = var.tag
    }
  )
}
