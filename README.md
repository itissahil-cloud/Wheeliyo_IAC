# Wheeliyo_IAC
This repository contains the Infrastructure as Code (IaC) definitions required to provision and manage a scalable, secure AWS environment.
🚀 Big Picture (Understand First)

This file is:

👉 GitHub Actions workflow (automation script)
👉 Runs Terraform automatically
👉 Safe infra deployment process

Flow:

1️⃣ You open PR → Terraform PLAN runs
2️⃣ Plan is shown in PR comment
3️⃣ PR merged → Terraform APPLY waits for approval
4️⃣ You approve → Infra created/updated

👉 This is production safe flow

⭐ Top Section
name: Terraform CI/CD

👉 Just workflow name
👉 Visible in GitHub Actions UI

⭐ Trigger Section (WHEN pipeline runs)

on:
  pull_request:
  push:
    branches: [ main ]

Meaning:

✅ On Pull Request

When you open PR → run PLAN

✅ On Push to main

When PR merged → run APPLY

👉 This is standard infra workflow

⭐ Permissions (VERY IMPORTANT)
permissions:
  id-token: write
  contents: read
  pull-requests: write

This tells GitHub:

🔐 id-token: write

Needed for OIDC login to AWS

👉 No AWS keys stored (very secure)

Industry standard.

📄 contents: read

Allows pipeline to read repo code

💬 pull-requests: write

Needed to comment Terraform plan on PR

⭐ Jobs Section
jobs:

Jobs = pipeline stages

You have:

👉 plan job
👉 apply job

🔵 PLAN JOB (Runs on PR)

plan:
  if: github.event_name == 'pull_request'

Means:

👉 Only run when PR opened

Important safety rule.
# GitHub creates temporary Linux machine.

runs-on: ubuntu-latest

⭐ Steps (Actual work)

1️⃣ Checkout code

- uses: actions/checkout@v4

Downloads repo code to runner. Without this Terraform cannot run.

2️⃣ Login to AWS (BIG CONCEPT)

- uses: aws-actions/configure-aws-credentials@v4

This logs GitHub into AWS using:

role-to-assume: terraform-github-role

Meaning:

👉 GitHub assumes IAM Role
👉 Temporary credentials generated
👉 No access keys required using OIDC

🔥 This is modern AWS security.

3️⃣ Install Terraform

- uses: hashicorp/setup-terraform@v3

Installs Terraform CLI.

4️⃣ Terraform Init

terraform init

Beginner meaning:

👉 Downloads providers
👉 Connects backend
👉 Prepares Terraform project

Think:  “Install project dependencies”

5️⃣ Terraform Validate

terraform validate

Checks:

👉 Syntax correct
👉 No Terraform errors

Like code linting.

6️⃣ Terraform Plan (MOST IMPORTANT)

terraform plan -no-color

Plan = preview changes.

Shows:
✅ What will be created
✅ What will be updated
✅ What will be destroyed

👉 Nothing is created yet

Very important.

⭐ Plan Output Capture

id: plan

Allows using plan output later.

⭐ Comment Plan on PR (Industry Standard)

# This posts plan result into PR.

marocchino/sticky-pull-request-comment

So reviewers can see:

👉 Infra changes before merging

This is DevOps review culture.

🟢 APPLY JOB (Runs after merge)

apply:
  if: github.ref == 'refs/heads/main' && github.event_name == 'push'

Meaning:

👉 Only after PR merged
👉 Only on main branch

Safety rule.

⭐ Environment = production (VERY IMPORTANT)
environment: production

This enables:

👉 Manual approval before apply

GitHub pauses pipeline.

You must click:

👉 Review deployment → Approve

🔥 This prevents accidental infra changes.

Companies ALWAYS do this.

⭐ Apply Steps

Same steps:

1️⃣ Checkout
2️⃣ Login AWS
3️⃣ Install Terraform
4️⃣ Init
5️⃣ Apply

Final Step

terraform apply -auto-approve

Now Terraform:

👉 Creates infra
👉 Updates infra
👉 Executes changes

Because approval already happened in GitHub.

⭐ Real Flow (Important Mental Model)
👨‍💻 Developer opens PR

→ Plan runs
→ Team reviews infra changes

👨‍💻 PR merged

→ Apply job starts
→ GitHub asks approval

👤 DevOps approves

→ Infra deployed

