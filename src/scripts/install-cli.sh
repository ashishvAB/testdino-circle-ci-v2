#!/bin/bash

if ! command -v npx &> /dev/null; then
  echo "npx not found. Please ensure Node.js is installed."
  exit 1
fi
echo "TestDino CLI will be installed via npx when running the upload command"
