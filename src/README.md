# TestDino CircleCI Orb

CircleCI orb for integrating TestDino with your Playwright test workflow. This orb simplifies uploading Playwright test reports with configurable attachment options.

## Features

- Upload Playwright test reports to TestDino
- Flexible attachment options (images, videos, HTML, traces, files)
- Support for custom report paths
- Verbose logging option
- Support for custom API endpoints
- Simple integration with existing CircleCI workflows

## Commands

### `upload-report`
Upload Playwright test reports to TestDino platform with configurable attachment options.

**Parameters:**

**Required:**
- `token` (env_var_name, default: TESTDINO_TOKEN) - Environment variable containing TestDino API token

**Optional:**
- `report_directory` (string, default: "./playwright-report") - Directory containing Playwright test reports
- `api_url` (string) - Override TestDino API endpoint URL

**Attachment Options (boolean flags):**
- `upload_images` (boolean, default: false) - Upload image attachments (JSON + images)
- `upload_videos` (boolean, default: false) - Upload video attachments (JSON + videos)
- `upload_html` (boolean, default: false) - Upload HTML reports (JSON + HTML + images + videos - complete bundle)
- `upload_traces` (boolean, default: false) - Upload trace files (JSON + traces)
- `upload_files` (boolean, default: false) - Upload file attachments like .md, .pdf, .txt, .log (JSON + files)
- `upload_full_json` (boolean, default: false) - Upload all attachments (JSON + images + videos + files - complete bundle)

**Custom Paths:**
- `json_report` (string) - Specific JSON report path
- `html_report` (string) - Specific HTML report path
- `trace_dir` (string) - Specific trace directory path

**Other:**
- `verbose` (boolean, default: false) - Enable verbose logging

**Flag Combinations:**
- No flags: Only JSON report uploaded
- `upload_images`: JSON + image attachments
- `upload_videos`: JSON + video attachments
- `upload_files`: JSON + file attachments (.md, .pdf, .txt, .log)
- `upload_traces`: JSON + trace files
- `upload_html`: JSON + HTML + images + videos (complete HTML bundle)
- `upload_full_json`: JSON + images + videos + files (complete bundle)

**Examples:**

Basic upload (JSON only):
```yaml
- testdino/upload-report:
    token: TESTDINO_TOKEN
```

Upload with HTML bundle:
```yaml
- testdino/upload-report:
    report_directory: "./playwright-report"
    token: TESTDINO_TOKEN
    upload_html: true
    verbose: true
```

Upload complete bundle:
```yaml
- testdino/upload-report:
    token: TESTDINO_TOKEN
    upload_full_json: true
```

Upload with custom paths:
```yaml
- testdino/upload-report:
    report_directory: "./test-results"
    token: TESTDINO_TOKEN
    upload_images: true
    upload_videos: true
    json_report: "./test-results/results.json"
    html_report: "./test-results/index.html"
```

## Jobs

### `upload-reports`
Complete job to upload Playwright test reports to TestDino. This job includes checkout and uses the default Node.js executor.

**Parameters:**
All parameters from the `upload-report` command are supported, plus:
- `node_version` (string, default: "lts") - Node.js version tag for the executor

## Usage Examples

### Basic Usage (JSON only)
```yaml
version: 2.1

orbs:
  testdino: testdino/testdino@1.0.0

jobs:
  test:
    docker:
      - image: mcr.microsoft.com/playwright:v1.40.0-focal
    steps:
      - checkout
      - run: npm ci
      - run: npx playwright test
      - testdino/upload-report:
          token: TESTDINO_TOKEN

workflows:
  test-workflow:
    jobs:
      - test
```

### Upload with HTML Bundle
```yaml
version: 2.1

orbs:
  testdino: testdino/testdino@1.0.0

jobs:
  test:
    docker:
      - image: mcr.microsoft.com/playwright:v1.40.0-focal
    steps:
      - checkout
      - run: npm ci
      - run: npx playwright test
      - testdino/upload-report:
          report_directory: "./playwright-report"
          token: TESTDINO_TOKEN
          upload_html: true
          verbose: true

workflows:
  test-workflow:
    jobs:
      - test:
          context: testdino-credentials
```

### Upload Complete Bundle
```yaml
version: 2.1

orbs:
  testdino: testdino/testdino@1.0.0

jobs:
  test:
    docker:
      - image: mcr.microsoft.com/playwright:v1.40.0-focal
    steps:
      - checkout
      - run: npm ci
      - run: npx playwright test
      - testdino/upload-report:
          token: TESTDINO_TOKEN
          upload_full_json: true
          verbose: true
      - store_artifacts:
          path: ./playwright-report
          destination: playwright-report

workflows:
  test-workflow:
    jobs:
      - test:
          context: testdino-credentials
```

### Upload with Custom Paths and Multiple Attachments
```yaml
version: 2.1

orbs:
  testdino: testdino/testdino@1.0.0

jobs:
  test:
    docker:
      - image: mcr.microsoft.com/playwright:v1.40.0-focal
    steps:
      - checkout
      - run: npm ci
      - run: npx playwright test
      - testdino/upload-report:
          report_directory: "./test-results"
          token: TESTDINO_TOKEN
          upload_images: true
          upload_videos: true
          upload_traces: true
          json_report: "./test-results/results.json"
          verbose: true

workflows:
  test-workflow:
    jobs:
      - test
```

## Setup

1. Set up your TestDino API token as an environment variable in CircleCI:
   - Go to Project Settings > Environment Variables
   - Add `TESTDINO_TOKEN` with your API token value

2. Add the orb to your `.circleci/config.yml` file

3. Use the commands or jobs in your workflow

## Documentation

For more information about TestDino, visit:
- Documentation: https://docs.testdino.com
- Website: https://testdino.com

## See Also
- [Orb Author Intro](https://circleci.com/docs/2.0/orb-author-intro/#section=configuration)
- [Reusable Configuration](https://circleci.com/docs/2.0/reusing-config)
