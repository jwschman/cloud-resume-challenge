# Cloud Resume Challenge

A serverless resume website built as part of the Cloud Resume Challenge, featuring a visitor counter and fully automated CI/CD pipeline.

View the website at [jwschman.click](https://jwschman.click).

Or check out my [full blog post about it here](https://jwschman.github.io/posts/2025/07-16-completing-the-cloud-resume-challenge/).

## Directory Structure

- `.github/workflows/build-lambda.yaml` - GitHub Action to rebuild and deploy Lambda function on changes
- `.github/workflows/sync-frontend-s3.yaml` - GitHub Action to sync website assets to S3 on changes
- `infrastructure/envs/production` - contains the root Terraform file used for the site
- `infrastructure/modules` - contains all the Terraform modules I wrote for individual pieces of AWS infrastructure
- `remote-state` - separate terraform root for managing the remote state, also on AWS
- `website` - assets to be uploaded to the S3 bucket to serve the website

## Infrastructure Diagram

![infrastructure diagram](images/infrastructure.png)

## AWS Services Used

**Frontend & Delivery:**

- **S3** - Storage for static website assets
- **CloudFront** - Global content delivery for S3 assets
- **Route53** - DNS management and domain registration

**Backend & API:**

- **Lambda** - Serverless function for visitor counter
- **API Gateway** - REST API endpoint for Lambda function
- **DynamoDB** - NoSQL database for visitor count storage

**Security:**

- **IAM** - Access management for AWS resources

## Technologies Used

- **Infrastructure**: Terraform, AWS
- **Backend**: Go
- **Frontend**: HTML, CSS, JavaScript
- **CI/CD**: GitHub Actions
