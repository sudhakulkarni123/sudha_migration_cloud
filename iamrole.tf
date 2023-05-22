#create the OIDC provider in aws account
# resource "aws_iam_openid_connect_provider" "oidc_provider" {
#   url = "https://token.actions.githubusercontent.com"
#   client_id_list = ["sts.amazonaws.com"]
#   thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
#   #tags = local.common_tags
# }

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
  #tags = local.common_tags
}

#create an IAM role that can be assumed by actions runners running
# aginst repos in the list
resource "aws_iam_role" "migration_oidc_role" {
  name = "migration_lab_github_oidc_role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
  
}

data "aws_iam_policy_document" "github_actions_assume_role" {
    statement {
      sid = "github"
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals{
        type = "Federated"
        identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
      }
      condition {
        test ="StringEquals"
        variable = "token.actions.githubusercontent.com:aud"
        values =  ["sts.amazonaws.com"]
      }
      condition {
        test ="StringLike"
        variable = "token.actions.githubusercontent.com:sub"
        values = [
        "repo:sudhakulkarni123/*:*"
      ]
      }
    }
}
 
resource "aws_iam_role_policy_attachment" "github_actions_iam_policy" {
    role = aws_iam_role.migration_oidc_role.id
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    
                 
}