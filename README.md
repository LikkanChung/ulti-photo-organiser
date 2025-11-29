# Ultimate Photo Organiser

A web application for managing photographers at sports tournaments, enabling them to view and track match coverage.

## Overview

This application helps coordinate photography coverage at sports tournaments by:
- Displaying current and upcoming matches
- Allowing photographers to mark matches as covered
- Tracking which matches need photography coverage
- Managing photographer assignments and availability

## Current Implementation Status

**Phase 1: Amplify Website Deployment** ✅ (In Progress)
- Setting up React frontend with AWS Amplify hosting
- Automated deployment via GitHub Actions
- Infrastructure as Code using Terraform

**Future Phases:**
- Backend API (AppSync/API Gateway + Lambda)
- Database (DynamoDB)
- Authentication (Cognito)
- Real-time updates and notifications

## Technology Stack

### Frontend (Phase 1)
- **Framework**: React
- **Hosting**: AWS Amplify
- **UI Library**: Material-UI or Tailwind CSS
- **CI/CD**: GitHub Actions
- **Infrastructure**: Terraform

### Backend (Future)
- **API**: AWS AppSync (GraphQL) or API Gateway + Lambda
- **Database**: Amazon DynamoDB
- **Authentication**: Amazon Cognito
- **File Storage**: Amazon S3

## Current Architecture

```
┌─────────────────────────┐
│   GitHub Repository     │
│   (Source Code)         │
└───────────┬─────────────┘
            │
            │ Push to main
            ▼
┌─────────────────────────┐
│   GitHub Actions        │
│   (CI/CD Pipeline)      │
└───────────┬─────────────┘
            │
            │ Deploy via Terraform
            ▼
┌─────────────────────────┐
│   AWS Amplify           │
│   (Hosting + Build)     │
└─────────────────────────┘
            │
            │ Serves
            ▼
┌─────────────────────────┐
│   React Web App         │
│   (Static Site)         │
└─────────────────────────┘
```

## Features

### Phase 1: Static Website (Current)
- [ ] Deploy React application to AWS Amplify
- [ ] Set up Terraform for infrastructure
- [ ] Configure GitHub Actions for CI/CD
- [ ] Create basic UI layout and components
- [ ] Landing page with project information
- [ ] Mock data for development

### Phase 2: Backend & Database
- [ ] Set up DynamoDB tables
- [ ] Create AppSync GraphQL API or REST API
- [ ] Implement CRUD operations for tournaments and matches

### Phase 3: Authentication
- [ ] Configure Cognito User Pools
- [ ] Implement user login/signup
- [ ] Add photographer and admin roles

### Phase 4: Core Features
- [ ] View list of tournaments
- [ ] View matches for a tournament (current & upcoming)
- [ ] Mark matches as "covered" by photographer
- [ ] Real-time updates

### Phase 5: Advanced Features
- [ ] Admin panel for tournament management
- [ ] Photo upload capability
- [ ] Email/SMS notifications
- [ ] Analytics and reporting

## Data Model (Future Implementation)

The application will use the following data model once the backend is implemented:

### User
- userId, email, name, role (photographer/admin)
- profilePictureUrl, createdAt, updatedAt

### Tournament
- tournamentId, name, startDate, endDate, location
- description, status, createdBy, timestamps

### Match
- matchId, tournamentId, homeTeam, awayTeam
- scheduledTime, location, status
- isCovered, coveredBy, coveredAt, notes

### Coverage
- coverageId, matchId, photographerId
- status, timestamp

## Getting Started

### Prerequisites
- Node.js (v18 or later)
- npm or yarn
- AWS Account
- Terraform (v1.0+)
- AWS CLI configured with appropriate credentials
- GitHub account

### Quick Start

1. Clone the repository:
```bash
git clone https://github.com/LikkanChung/ulti-photo-organiser.git
cd ulti-photo-organiser
```

2. Install frontend dependencies:
```bash
cd frontend
npm install
```

3. Run development server locally:
```bash
npm start
```

### Deploying to AWS Amplify

#### Option 1: Using Terraform (Recommended)

1. Configure AWS credentials:
```bash
aws configure
```

2. Update Terraform variables:
```bash
cd terraform
# Edit environments/dev/terraform.tfvars with your GitHub repo URL
```

3. Deploy infrastructure:
```bash
terraform init
terraform plan -var-file=environments/dev/terraform.tfvars
terraform apply -var-file=environments/dev/terraform.tfvars
```

#### Option 2: Using GitHub Actions

1. Set up AWS credentials in GitHub Secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

2. Push to main branch:
```bash
git push origin main
```

The GitHub Actions workflow will automatically deploy to AWS Amplify.

### Local Development

```bash
cd frontend
npm start
```

Visit `http://localhost:3000` to view the app.

## Environment Variables (Future)

Once backend services are added, create a `.env` file in the frontend directory:

```env
REACT_APP_AWS_REGION=us-east-1
REACT_APP_USER_POOL_ID=<cognito-user-pool-id>
REACT_APP_USER_POOL_CLIENT_ID=<cognito-client-id>
REACT_APP_API_ENDPOINT=<api-gateway-or-appsync-endpoint>
```

For now, the static site doesn't require environment variables.

## Project Structure

```
ulti-photo-organiser/
├── .github/
│   └── workflows/           # GitHub Actions CI/CD
│       └── deploy.yml
├── frontend/                # React application
│   ├── public/
│   ├── src/
│   │   ├── components/     # React components
│   │   ├── pages/          # Page components
│   │   ├── App.js
│   │   └── index.js
│   └── package.json
├── terraform/              # Infrastructure as Code
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── modules/
│   │   └── amplify/        # Amplify hosting module
│   └── environments/
│       ├── dev/
│       └── prod/
├── docs/                   # Documentation
│   └── IMPLEMENTATION_PLAN.md
├── README.md
└── IMPLEMENTATION_PLAN.md
```

## API Endpoints (Future Implementation)

API endpoints will be added in Phase 2 when the backend is implemented.

## Testing

```bash
# Frontend tests
cd frontend
npm test

# End-to-end tests
npm run test:e2e
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

MIT License - see LICENSE file for details

## Support

For issues and questions:
- Create an issue on GitHub
- Contact: [your-email@example.com]

## Roadmap

See the [IMPLEMENTATION_PLAN.md](./IMPLEMENTATION_PLAN.md) for detailed development phases and technical implementation details.
