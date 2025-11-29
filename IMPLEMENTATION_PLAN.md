# Implementation Plan - Ultimate Photo Organiser

## Project Overview

Build a web application for managing photographer assignments at sports tournaments. This plan follows an incremental approach, starting with a simple static website and gradually adding backend functionality.

## Development Approach

**Start Simple, Build Incrementally:**
1. **Phase 1**: Deploy static React website via Amplify (Terraform + GitHub Actions)
2. **Phase 2**: Add backend API and database
3. **Phase 3**: Add authentication and authorization
4. **Phase 4**: Add advanced features

This approach allows you to:
- ✅ See results quickly
- ✅ Learn each service incrementally
- ✅ Have a working site at each phase
- ✅ Deploy and test continuously

---

## Phase 1: Amplify Website Deployment (Current Phase)

**Goal**: Deploy a static React website to AWS Amplify using Terraform and GitHub Actions

**Duration**: 1-2 days

### 1.1 Create React Application

**Tasks:**
- [ ] Initialize React app with Create React App
- [ ] Create basic landing page
- [ ] Add placeholder components for future features
- [ ] Set up basic routing
- [ ] Add mock data for development
- [ ] Style with Material-UI or Tailwind CSS

**Commands:**
```bash
npx create-react-app frontend
cd frontend
npm install react-router-dom
npm install @mui/material @emotion/react @emotion/styled
# or
npm install -D tailwindcss postcss autoprefixer
```

**Pages to create:**
- Home/Landing page
- Tournaments list (with mock data)
- Match details (with mock data)
- About page

### 1.2 Terraform Infrastructure for Amplify

**Files to create:**
- `terraform/main.tf` - Main Terraform configuration
- `terraform/variables.tf` - Input variables
- `terraform/outputs.tf` - Output values  
- `terraform/modules/amplify/main.tf` - Amplify module
- `terraform/modules/amplify/variables.tf` - Module variables
- `terraform/modules/amplify/outputs.tf` - Module outputs
- `terraform/environments/dev/terraform.tfvars` - Dev config
- `terraform/environments/prod/terraform.tfvars` - Prod config

**Key Terraform Resources:**
```hcl
# terraform/modules/amplify/main.tf
resource "aws_amplify_app" "main" {
  name       = "${var.project_name}-${var.environment}"
  repository = var.github_repository_url
  
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - cd frontend
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: frontend/build
        files:
          - '**/*'
      cache:
        paths:
          - frontend/node_modules/**/*
  EOT
  
  access_token = var.github_access_token
  
  # SPA routing support
  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|woff2|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.main.id
  branch_name = "main"
  
  enable_auto_build = true
  stage             = var.environment == "prod" ? "PRODUCTION" : "DEVELOPMENT"
}
```

### 1.3 GitHub Actions Workflow

**File to create:**
- `.github/workflows/deploy.yml`

**Workflow:**
```yaml
name: Deploy to AWS Amplify

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  terraform:
    name: Terraform Deployment
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.0
      
      - name: Terraform Init
        working-directory: ./terraform
        run: terraform init
      
      - name: Terraform Plan
        working-directory: ./terraform
        run: terraform plan -var-file=environments/dev/terraform.tfvars
      
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        working-directory: ./terraform
        run: terraform apply -auto-approve -var-file=environments/dev/terraform.tfvars

  build-test:
    name: Build and Test Frontend
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json
      
      - name: Install dependencies
        working-directory: ./frontend
        run: npm ci
      
      - name: Run tests
        working-directory: ./frontend
        run: npm test -- --coverage --watchAll=false
      
      - name: Build
        working-directory: ./frontend
        run: npm run build
```

### 1.4 Configuration and Setup

**GitHub Secrets to configure:**
- `AWS_ACCESS_KEY_ID` - Your AWS access key
- `AWS_SECRET_ACCESS_KEY` - Your AWS secret key
- `GITHUB_TOKEN` - Automatically provided by GitHub Actions

**Terraform Variables:**
```hcl
# environments/dev/terraform.tfvars
project_name          = "photo-organiser"
environment           = "dev"
aws_region            = "us-east-1"
github_repository_url = "https://github.com/LikkanChung/ulti-photo-organiser"
```

### 1.5 Deployment Steps

1. **Set up AWS credentials** in GitHub repository secrets
2. **Commit code** to repository
3. **Push to main branch**
4. **GitHub Actions** automatically runs
5. **Terraform** deploys Amplify app
6. **Amplify** builds and hosts the React app

### 1.6 Expected Outcomes

✅ React app accessible at Amplify URL (e.g., `https://main.xxxxx.amplifyapp.com`)  
✅ Automatic deployments on push to main  
✅ Infrastructure defined as code  
✅ Working CI/CD pipeline  
✅ Foundation for adding backend services  

---

## Phase 2: Backend API and Database (Future)

**Goal**: Add AppSync GraphQL API or REST API with DynamoDB

**Components to add:**
- DynamoDB tables for data storage
- AppSync GraphQL API or API Gateway + Lambda
- CRUD operations for tournaments and matches
- Connect frontend to backend API

**Will create:**
- `terraform/modules/dynamodb/` - Database module
- `terraform/modules/appsync/` - API module (or API Gateway)
- Backend integration in React app

---

## Phase 3: Authentication (Future)

**Goal**: Add user authentication with Cognito

**Components to add:**
- Cognito User Pool
- User groups (photographers, admins)
- Login/signup functionality in frontend
- Protected routes and authorization

**Will create:**
- `terraform/modules/cognito/` - Authentication module
- Authentication components in React
- Role-based access control

---

## Phase 4: Core Features (Future)

**Goal**: Implement main application features

**Features to build:**
- Tournament management (CRUD)
- Match tracking
- Photographer assignment
- Coverage status tracking
- Real-time updates

---

## Phase 5: Advanced Features (Future)

**Goal**: Add advanced functionality

**Features to add:**
- Photo upload to S3
- Email/SMS notifications (SNS/SES)
- Analytics dashboard
- Mobile app (React Native)
- Advanced reporting

---

## Current Phase: Getting Started Checklist

### Prerequisites
- [ ] AWS account created
- [ ] AWS CLI installed and configured
- [ ] Terraform installed (v1.0+)
- [ ] Node.js installed (v18+)
- [ ] GitHub account
- [ ] Git installed

### Setup Steps

1. **Create React Application**
```bash
npx create-react-app frontend
cd frontend
npm start  # Test locally
```

2. **Create Terraform Files**
```bash
mkdir -p terraform/modules/amplify
mkdir -p terraform/environments/dev
mkdir -p terraform/environments/prod
# Create main.tf, variables.tf, outputs.tf, etc.
```

3. **Set up GitHub Repository**
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/LikkanChung/ulti-photo-organiser.git
git push -u origin main
```

4. **Configure GitHub Secrets**
- Go to Settings → Secrets and variables → Actions
- Add `AWS_ACCESS_KEY_ID`
- Add `AWS_SECRET_ACCESS_KEY`

5. **Create GitHub Actions Workflow**
```bash
mkdir -p .github/workflows
# Create deploy.yml
```

6. **Test Deployment**
```bash
git add .
git commit -m "Add GitHub Actions workflow"
git push origin main
# Check Actions tab in GitHub to see deployment
```

### Success Criteria

- [ ] React app runs locally (`npm start`)
- [ ] GitHub Actions workflow runs without errors
- [ ] Terraform successfully creates Amplify app
- [ ] Website is accessible at Amplify URL
- [ ] Changes pushed to main trigger automatic deployment

---

## Timeline

| Phase | Duration | Deliverable |
|-------|----------|-------------|
| Phase 1: Amplify Website | 1-2 days | Static website deployed |
| Phase 2: Backend API | 3-5 days | API + Database working |
| Phase 3: Authentication | 2-3 days | User login functional |
| Phase 4: Core Features | 1-2 weeks | Main features working |
| Phase 5: Advanced | Ongoing | Additional features |

---

## Resources

### Documentation
- [AWS Amplify Hosting](https://docs.aws.amazon.com/amplify/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions](https://docs.github.com/en/actions)
- [React Documentation](https://react.dev)

### Tutorials
- [Terraform + Amplify Guide](https://developer.hashicorp.com/terraform/tutorials/aws/aws-amplify)
- [React + GitHub Actions](https://docs.github.com/en/actions/deployment/deploying-a-react-app)

---

## Next Steps

1. ✅ Review this plan
2. 📝 Create React application
3. 🏗️ Set up Terraform configuration
4. ⚙️ Configure GitHub Actions
5. 🚀 Deploy and test
6. 🎉 Celebrate your first deployment!

Once Phase 1 is complete, we'll add the backend services incrementally.
