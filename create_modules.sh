#!/bin/bash

# Create directories
mkdir -p modules/{vpc,security_groups,alb,app,rds,s3,bastion}

# Create empty tf files inside each directory
for dir in modules/*; do
  touch "$dir/main.tf" "$dir/variables.tf" "$dir/outputs.tf"
done

echo "✅ Module skeleton successfully created."