#!/bin/bash

terraform init
terraform apply -auto-approve

cd primary_region
terraform init
terraform apply -auto-approve
cd ..

cd secondary_region
terraform init
terraform apply -auto-approve
cd ..
