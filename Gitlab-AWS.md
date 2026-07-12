# Configure OpenID Connect in AWS to retrieve temporary credentials
https://docs.gitlab.com/ci/cloud_services/aws/#add-the-identity-provider

## Configure in AWS
- Add the identity provider
- ```aws iam create-open-id-connect-provider \
    --url "https://gitlab.com" \
    --client-id-list "https://gitlab.com" ```
    
- Configure the role and trust
- 
- Retrieve a temporary credential
