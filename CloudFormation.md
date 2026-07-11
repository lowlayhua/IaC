# Create Cloud Formation for OIDC and Role
```
cat > gitlab-trust-policy.json <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Principal": {
"Federated": "arn:aws:iam::339712913435:oidc-provider/gitlab.com"
},
"Action": "sts:AssumeRoleWithWebIdentity",
"Condition": {
"StringEquals": {
"gitlab.com:aud": "sts.amazonaws.com",
"gitlab.com:sub": "project_path:lowlayhua-group1/learn-tf:ref_type:branch:ref:main"
}
}
}
]
}
```
# Create S3 for  Terraform State file 
```
cat > terraform-backend.yaml <<'EOF'
AWSTemplateFormatVersion: '2010-09-09'
Description: Terraform Backend Resources

Parameters:

  BucketName:
    Type: String
    Default: terraform-state-316490106169

Resources:

  TerraformStateBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Ref BucketName

      VersioningConfiguration:
        Status: Enabled

      BucketEncryption:
        ServerSideEncryptionConfiguration:
          - ServerSideEncryptionByDefault:
              SSEAlgorithm: AES256

      PublicAccessBlockConfiguration:
        BlockPublicAcls: true
        BlockPublicPolicy: true
        IgnorePublicAcls: true
        RestrictPublicBuckets: true

  TerraformStateBucketPolicy:
    Type: AWS::S3::BucketPolicy
    Properties:
      Bucket: !Ref TerraformStateBucket
      PolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Sid: DenyInsecureTransport
            Effect: Deny
            Principal: "*"
            Action: "s3:*"
            Resource:
              - !Sub arn:aws:s3:::${TerraformStateBucket}
              - !Sub arn:aws:s3:::${TerraformStateBucket}/*
            Condition:
              Bool:
                aws:SecureTransport: false

  TerraformLockTable:
    Type: AWS::DynamoDB::Table
    Properties:
      TableName: terraform-locks

      BillingMode: PAY_PER_REQUEST

      AttributeDefinitions:
        - AttributeName: LockID
          AttributeType: S

      KeySchema:
        - AttributeName: LockID
          KeyType: HASH

Outputs:

  BucketName:
    Description: Terraform State Bucket
    Value: !Ref TerraformStateBucket

  DynamoDBTable:
    Description: Terraform Lock Table
    Value: !Ref TerraformLockTable

  BucketArn:
    Description: Terraform State Bucket ARN
    Value: !GetAtt TerraformStateBucket.Arn
EOF
```


## 2. Validate 
```
aws cloudformation validate-template \
  --template-body file://terraform-backend.yaml
```
## 3. Deploy
```
aws cloudformation deploy \
  --stack-name terraform-backend \
  --template-file terraform-backend.yaml
```

# Create Terraform BootStap create a bootstrap stack that gives your GitLab OIDC role access to:
- S3 Terraform State Bucket
- DynamoDB Lock Table

- GitLab Pipeline
      |
      v
GitLabTerraformRole
      |
      +--> S3 State Bucket
      |
      +--> DynamoDB Lock Table
      |
      +--> AWS Infrastructure

## 1. Create terraform-bootstrap.yaml 
```
cat > terraform-bootstrap.yaml <<'EOF'
AWSTemplateFormatVersion: '2010-09-09'
Description: Terraform Bootstrap Permissions

Parameters:

  TerraformRoleName:
    Type: String
    Default: GitLabTerraformRole

  TerraformStateBucket:
    Type: String
    Default: terraform-state-316490106169

  TerraformLockTable:
    Type: String
    Default: terraform-locks

Resources:

  TerraformBackendPolicy:
    Type: AWS::IAM::ManagedPolicy
    Properties:
      ManagedPolicyName: TerraformBackendPolicy

      PolicyDocument:
        Version: '2012-10-17'

        Statement:

          - Sid: TerraformStateBucket
            Effect: Allow
            Action:
              - s3:ListBucket
              - s3:GetBucketVersioning
            Resource:
              - !Sub arn:aws:s3:::${TerraformStateBucket}

          - Sid: TerraformStateObjects
            Effect: Allow
            Action:
              - s3:GetObject
              - s3:PutObject
              - s3:DeleteObject
            Resource:
              - !Sub arn:aws:s3:::${TerraformStateBucket}/*

          - Sid: TerraformLockTable
            Effect: Allow
            Action:
              - dynamodb:GetItem
              - dynamodb:PutItem
              - dynamodb:DeleteItem
              - dynamodb:UpdateItem
              - dynamodb:DescribeTable
            Resource:
              - !Sub arn:aws:dynamodb:${AWS::Region}:${AWS::AccountId}:table/${TerraformLockTable}

  AttachPolicy:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: AttachTerraformBackendPolicy
      Roles:
        - !Ref TerraformRoleName

      PolicyDocument:
        Version: '2012-10-17'

        Statement:

          - Effect: Allow
            Action:
              - s3:ListBucket
              - s3:GetBucketVersioning
            Resource:
              - !Sub arn:aws:s3:::${TerraformStateBucket}

          - Effect: Allow
            Action:
              - s3:GetObject
              - s3:PutObject
              - s3:DeleteObject
            Resource:
              - !Sub arn:aws:s3:::${TerraformStateBucket}/*

          - Effect: Allow
            Action:
              - dynamodb:GetItem
              - dynamodb:PutItem
              - dynamodb:DeleteItem
              - dynamodb:UpdateItem
              - dynamodb:DescribeTable
            Resource:
              - !Sub arn:aws:dynamodb:${AWS::Region}:${AWS::AccountId}:table/${TerraformLockTable}

Outputs:

  PolicyName:
    Value: TerraformBackendPolicy

  RoleName:
    Value: !Ref TerraformRoleName

EOF
```

## 2. validate
```
aws cloudformation validate-template \
  --template-body file://terraform-bootstrap.yaml
```

## 4.3 deploy
```
aws cloudformation deploy \
  --stack-name terraform-bootstrap \
  --template-file terraform-bootstrap.yaml \
  --capabilities CAPABILITY_NAMED_IAM
```


# check
```
aws iam list-attached-role-policies \
>   --role-name GitLabTerraformRole
{
    "AttachedPolicies": [
        {
            "PolicyName": "AdministratorAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AdministratorAccess"
        }
    ]
}
```

# Terraform Configuration
```
terraform {
  backend "s3" {
    bucket         = "terraform-state-316490106169"
    key            = "network/dev.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```


