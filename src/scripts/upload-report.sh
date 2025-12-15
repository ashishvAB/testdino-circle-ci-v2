#!/bin/bash

# Determine if token is an environment variable or direct value
TOKEN_VALUE="$PARAM_TOKEN"

# Check if token value is empty
if [ -z "$TOKEN_VALUE" ]; then
  echo "Error: TestDino token not provided. Please pass the token directly or set the environment variable."
  exit 1
fi

# Check if it looks like an environment variable name (all caps, underscores, digits, starts with letter or underscore)
# and if that environment variable exists
if [[ "$TOKEN_VALUE" =~ ^[A-Z_][A-Z0-9_]*$ ]] && [ -n "${!TOKEN_VALUE}" ]; then
  # It's an env var name and the env var exists, use its value
  ACTUAL_TOKEN="${!TOKEN_VALUE}"
  echo "Using token from environment variable: $TOKEN_VALUE"
else
  # Use it as a direct token value
  # TestDino tokens start with 'trx_' prefix
  ACTUAL_TOKEN="$TOKEN_VALUE"
  if [[ "$TOKEN_VALUE" =~ ^trx_ ]]; then
    echo "Using TestDino token (starting with trx_)"
  else
    echo "Warning: Token doesn't start with 'trx_' prefix. Using provided value anyway."
  fi
fi

if [ -z "$ACTUAL_TOKEN" ]; then
  echo "Error: TestDino token is empty."
  exit 1
fi

if [ ! -d "$PARAM_REPORT_DIRECTORY" ]; then
  echo "Error: Report directory $PARAM_REPORT_DIRECTORY does not exist."
  exit 1
fi

echo "Uploading reports from $PARAM_REPORT_DIRECTORY to TestDino..."

# Build the upload command
UPLOAD_CMD="npx tdpw upload $PARAM_REPORT_DIRECTORY --token=\"$ACTUAL_TOKEN\""

# Add optional flags
if [ "$PARAM_UPLOAD_IMAGES" = "1" ]; then
  UPLOAD_CMD="$UPLOAD_CMD --upload-images"
  echo "Flag: --upload-images enabled"
fi

if [ "$PARAM_UPLOAD_VIDEOS" = "1" ]; then
  UPLOAD_CMD="$UPLOAD_CMD --upload-videos"
  echo "Flag: --upload-videos enabled"
fi

if [ "$PARAM_UPLOAD_HTML" = "1" ]; then
  UPLOAD_CMD="$UPLOAD_CMD --upload-html"
  echo "Flag: --upload-html enabled (complete HTML bundle)"
fi

if [ "$PARAM_UPLOAD_TRACES" = "1" ]; then
  UPLOAD_CMD="$UPLOAD_CMD --upload-traces"
  echo "Flag: --upload-traces enabled"
fi

if [ "$PARAM_UPLOAD_FILES" = "1" ]; then
  UPLOAD_CMD="$UPLOAD_CMD --upload-files"
  echo "Flag: --upload-files enabled"
fi

if [ "$PARAM_UPLOAD_FULL_JSON" = "1" ]; then
  UPLOAD_CMD="$UPLOAD_CMD --upload-full-json"
  echo "Flag: --upload-full-json enabled (complete bundle)"
fi

if [ "$PARAM_VERBOSE" = "1" ]; then
  UPLOAD_CMD="$UPLOAD_CMD --verbose"
  echo "Flag: --verbose enabled"
fi

# Add optional path parameters
if [ -n "$PARAM_JSON_REPORT" ]; then
  UPLOAD_CMD="$UPLOAD_CMD --json-report=\"$PARAM_JSON_REPORT\""
  echo "Using custom JSON report path: $PARAM_JSON_REPORT"
fi

if [ -n "$PARAM_HTML_REPORT" ]; then
  UPLOAD_CMD="$UPLOAD_CMD --html-report=\"$PARAM_HTML_REPORT\""
  echo "Using custom HTML report path: $PARAM_HTML_REPORT"
fi

if [ -n "$PARAM_TRACE_DIR" ]; then
  UPLOAD_CMD="$UPLOAD_CMD --trace-dir=\"$PARAM_TRACE_DIR\""
  echo "Using custom trace directory: $PARAM_TRACE_DIR"
fi

# Execute the upload command
echo "Executing: $UPLOAD_CMD"

if eval "$UPLOAD_CMD"; then
  echo "Successfully uploaded reports to TestDino!"
else
  echo "Failed to upload reports to TestDino."
  exit 1
fi
