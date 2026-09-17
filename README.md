# Swarali Web App — ECS Deployment with Terraform & Jenkins CI/CD

##  Problem Statement

Deploy a sample web application on AWS ECS, and fully automate the deployment
process using **Terraform** (Infrastructure as Code) and **Jenkins** (CI/CD
pipeline).

## Tech Stack

| Layer               | Tool / Service                          |
|---------------------|------------------------------------------|
| Application          | Python (Flask)                          |
| Containerization      | Docker                                  |
| Container Registry    | AWS ECR (Elastic Container Registry)    |
| Container Orchestration | AWS ECS (Elastic Container Service)   |
| Infrastructure as Code | Terraform                             |
| CI/CD                 | Jenkins (Declarative Pipeline)          |
| Source Control         | GitHub                                 |

##  Architecture Overview

```
Developer pushes code to GitHub
            │
            ▼
   Jenkins Pipeline triggers
            │
   ┌────────┴────────┐
   │ 1. Checkout SCM   │
   │ 2. Build Docker    │
   │    Image            │
   │ 3. Login to AWS ECR │
   │ 4. Push Image to    │
   │    ECR               │
   │ 5. Deploy to ECS     │
   └────────┬────────┘
            ▼
   AWS ECS pulls latest image
   from ECR and runs updated
   container
            │
            ▼
   Flask App accessible via
   Public IP
```

The underlying AWS infrastructure (ECS Cluster, ECS Service, Task
Definition, ECR Repository, networking/security groups) is provisioned
using **Terraform**, making the entire environment reproducible from
code.

##  Repository Structure

```
.
├── app/                # Flask application source code
├── Dockerfile           # Container build definition for the Flask app
├── Jenkinsfile          # CI/CD pipeline definition
├── terraform/            # Infrastructure as Code (ECR, ECS, networking, etc.)
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── screenshots/           # Proof of working pipeline & deployment
└── README.md
```

##  How the Pipeline Works

1. **Checkout SCM** — Jenkins pulls the latest code from the GitHub
   repository (`swarali-web-app`).
2. **Build Docker Image** — the Flask app is containerized using the
   provided `Dockerfile`.
3. **Login to ECR** — Jenkins authenticates Docker with AWS ECR using
   AWS credentials.
4. **Push to ECR** — the built image is tagged and pushed to the ECR
   repository provisioned via Terraform.
5. **Deploy to ECS** — the ECS service is updated to pull and run the
   new image, triggering a rolling deployment.
6. **Result** — the Flask app becomes accessible via the ECS
   task/service's public IP.

##  Running It Yourself

### 1. Provision infrastructure with Terraform
```bash
cd terraform
terraform init
terraform plan
terraform apply
```
This creates the ECR repository, ECS cluster/service/task definition,
and required networking resources.

### 2. Configure Jenkins
- Set up a Jenkins pipeline job pointing to this repository.
- Add AWS credentials in Jenkins (Manage Jenkins → Credentials) for
  ECR/ECS access.
- Ensure the Jenkins agent has Docker and AWS CLI available.

### 3. Trigger the pipeline
Run the Jenkins job (manually via "Build Now", or via a GitHub webhook
on push). The pipeline will build, push, and deploy automatically.

##  Screenshots

See the `screenshots/` folder for:
- Successful Jenkins pipeline run (all green stages)
- ECR repository with pushed image
- ECS cluster/service running the task
- Live application accessible via public IP

## Live Application

>  Public IP/URL is here and is still active
> `http://54.235.37.237:5000
> infrastructure can be re-provisioned via `terraform apply`."_

##  Status

- [x] GitHub integration
- [x] Docker image build
- [x] AWS ECR push
- [x] AWS ECS deployment
- [x] Infrastructure provisioned via Terraform
- [x] Live app accessible via Public IP
```md

