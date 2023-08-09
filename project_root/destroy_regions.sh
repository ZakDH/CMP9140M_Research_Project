#!/bin/bash

terraform apply -destroy

cd primary_region
terraform apply -destroy
cd ..

# cd secondary_region
# terraform apply -destroy
# cd ..
