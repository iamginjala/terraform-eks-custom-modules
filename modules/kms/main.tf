resource "aws_kms_key" "sample-key" {
  description = var.description
  enable_key_rotation = true
  deletion_window_in_days = var.deletion_window_in_days
 tags = merge(var.tags,{
        name = "${var.name_prefix}-kms-key"
    })
}