resource "aws_iam_role" "github-actions-weatherlab-plan" {
  name = "github-actions-weatherlab-plan"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": aws_iam_openid_connect_provider.github_actions.arn
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "token.actions.githubusercontent.com:sub": "repo:lorikhaxhija@67200560/lorik.net@1382530562:ref:refs/heads/main",
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "tofu_plan_permissions" {
  statement {
    actions = ["s3:ListBucket"]

    resources = [
      "arn:aws:s3:::${var.s3_state_bucket}"
    ]
  }
  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.s3_state_bucket}/${var.s3_state_folder}/terraform.tfstate"
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::${var.s3_state_bucket}/${var.s3_state_folder}/terraform.tfstate.tflock"
    ]
  }
}

resource "aws_iam_role_policy" "tofu_plan_policy" {
  name = "tofu_plan_policy"
  role = aws_iam_role.github-actions-weatherlab-plan.id

  policy = data.aws_iam_policy_document.tofu_plan_permissions.json
}
