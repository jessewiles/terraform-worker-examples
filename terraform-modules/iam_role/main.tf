# System Policy
resource "aws_iam_role" "default" {
  name = var.name
  assume_role_policy = templatefile("${path.module}/policies/service_assume_role.json.tpl",
    {
      services = jsonencode(var.assume_services)
      accounts = jsonencode(var.assume_accounts)
  })

  path                  = var.path
  description           = var.description
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies
  tags                  = var.tags
}

resource "aws_iam_policy" "default" {
  name        = var.name
  description = var.description

  policy = var.policy
  path   = var.path
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

resource "aws_kms_grant" "default" {
  count             = var.kms_arn == "" ? 0 : 1
  name              = "${var.name}-key-grant"
  key_id            = var.kms_arn
  operations        = var.kms_operations
  grantee_principal = aws_iam_role.default.arn
}
