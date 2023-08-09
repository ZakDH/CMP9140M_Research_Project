#!/bin/bash

cd primary_region
terraform apply -destroy
cd ..

# cd secondary_region
# terraform apply -destroy
# cd ..

terraform apply -destroy