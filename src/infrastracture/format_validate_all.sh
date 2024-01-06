#!/bin/bash

# Run terraform fmt in the current directory
terraform fmt 

# Run terraform validate in the current directory
#terraform validate

# Run terraform fmt in all subdirectories
find . -type d -exec sh -c 'cd "{}" && terraform fmt' \;

 # Run terraform validate in all subdirectories
#find . -type d -exec sh -c 'cd "{}" && terraform validate' \;


