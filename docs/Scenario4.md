# covergo-test
## Design a multi-stage deployment pipeline
Utilizing the AWS Cloud provider with 2 EKS clusters:

- EKS cluster Dev.
- EKS cluster Prod.

The "covergo-test" repository on Github contains the following branches:
- `Dev` branch for the Dev environment.
- `Main` branch for the Prod environment.

For CI/CD, I will use Github Actions.

### Diagram
![alt text](https://github.com/thongle92/covergo-test/blob/main/images/default.png)
#### Create IAM User for GitHub Actions
Firstly, create an IAM User in AWS with the necessary permissions to manage the EKS clusters and ECR. Then, provide the credentials such as AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to GitHub Actions, so it can authenticate with your AWS account.
#### Install AWS CLI and Connect to AWS with GitHub Actions
In the GitHub Actions workflow, you need to install the AWS CLI and use it to log in to your AWS account with the IAM User credentials provided earlier.

For example:
```
- name: Configure AWS credentials
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  run: aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID && aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY && aws configure set default.region ap-southeast-1
```
#### Install Helm on Github Actions
Add a step to install Helm on the GitHub Actions runner. You can use the following example to install Helm.
```
- name: Install Helm
  run: |
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

```
#### Build and Push Docker Images to ECS
Your application is containerized and you have a Dockerfile, you'll need to build the Docker image and push it to an Amazon ECR repository.

Dev environment.
```
- name: Build and Push Docker Image Dev
  id: push-image-dev
  if: github.event_name != 'pull_request' && startsWith(github.ref, 'refs/heads/dev/')
  env:
    ECR_REGISTRY: 123456789.dkr.ecr.your-region.amazonaws.com
    DEV_IMAGE_TAG: dev-latest
  run: |
    docker build -t $ECR_REGISTRY/app1:$DEV_IMAGE_TAG ./app1
    $(aws ecr get-login --no-include-email)
    docker push $ECR_REGISTRY/app1:$IMAGE_TAG

```

Prod environment.
```
- name: Build and Push Docker Image Prod
  id: push-image-prod
  if: github.event_name != 'pull_request' && startsWith(github.ref, 'refs/heads/main/')
  env:
    ECR_REGISTRY: 123456789.dkr.ecr.your-region.amazonaws.com
    PROD_IMAGE_TAG: prod-latest
  run: |
    docker build -t $ECR_REGISTRY/app1:$PROD_IMAGE_TAG ./app1
    $(aws ecr get-login --no-include-email)
    docker push $ECR_REGISTRY/app1:$IMAGE_TAG
```
#### Deploy Helm Chart to EKS cluster
Dev environment.
```
- name: Deploy Helm Chart to Dev Cluster
  id: push-image-prod
  if: github.event_name != 'pull_request' && startsWith(github.ref, 'refs/heads/dev/')
  run: |
    helm upgrade --install app1 ./chart/app1 \
      --set image.repository=$ECR_REGISTRY/app1 \
      --set image.tag=$DEV_IMAGE_TAG

```

Prod environment.
```
- name: Deploy Helm Chart to Prod Cluster
  id: push-image-prod
  if: github.event_name != 'pull_request' && startsWith(github.ref, 'refs/heads/main/')
  run: |
    helm upgrade --install app1 ./chart/app1 \
      --set image.repository=$ECR_REGISTRY/app1 \
      --set image.tag=$PROD_IMAGE_TAG
```

### Deployment application with ArgoCD
#### Diagram
![alt text](https://github.com/thongle92/covergo-test/blob/main/images/argocd.png)
#### Set up GitHub Actions for CI
Configure GitHub Actions with the necessary steps for your CI process:
- Which includes building dependencies.
- Performing code analysis (e.g., SonarQube).
- Building the Docker image for your application.
- The final step should be pushing the Docker image to Amazon ECR.
#### Install and Configure ArgoCD:
Set up ArgoCD in EKS cluster. You can follow the official ArgoCD documentation for installation instructions.

After installation, you will have the ArgoCD control panel available to manage your deployments.

#### Install ArgoCD ImageUpdater Plugin:
Install the ArgoCD ImageUpdater plugin in your ArgoCD installation.

This plugin allows ArgoCD to watch for updates to the images in your ECR repository and automatically sync the changes to your manifests, ensuring the latest version of the image is deployed.

#### Watch Image Updates and Auto-Deploy:
With the ImageUpdater plugin enabled, ArgoCD will continuously monitor your ECR repository for updates to the latest image.

When a new image version is available in ECR, ArgoCD will automatically detect the change, update the deployment manifest with the new image version, and initiate a new deployment to your EKS cluster with the latest image.
