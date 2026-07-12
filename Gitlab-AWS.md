# Configure OpenID Connect in AWS to retrieve temporary credentials
https://docs.gitlab.com/ci/cloud_services/aws/#add-the-identity-provider

## Configure in AWS
## Add the identity provider


```
aws iam create-open-id-connect-provider \
    --url "https://gitlab.com" \
    --client-id-list "https://gitlab.com" ```
```    

### Step 2. Configure the role and trust
```
cat << 'EOF' > trust-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::529349714625:oidc-provider/gitlab.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "gitlab.com:aud": "https://gitlab.com"
        },
        "StringLike": {
          "gitlab.com:sub": "project_path:lowlayhua-group/aws-test-01:ref_type:branch:*"
        }
      }
    }
  ]
}
EOF
```
- `aws iam create-role --role-name GitLab-Terraform-Execution-Role --assume-role-policy-document file://trust-policy.json --description Role assumed by GitLab CI/CD to provision resources via Terraform`

### Step 3: Attach Permissions for role-name GitLab-Terraform-Execution-Role
- aws iam attach-role-policy \
    --role-name GitLab-Terraform-Execution-Role \
    --policy-arn arn:aws:iam::aws:policy/PowerUserAccess
- 
- Retrieve a temporary credential
