# Orb Template

<!---
[![CircleCI Build Status](https://circleci.com/gh/<organization>/<project-name>.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/<organization>/<project-name>) [![CircleCI Orb Version](https://badges.circleci.com/orbs/<namespace>/<orb-name>.svg)](https://circleci.com/developer/orbs/orb/<namespace>/<orb-name>) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/<organization>/<project-name>/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

--->

A project template for Orbs.

This repository is designed to be automatically ingested and modified by the CircleCI CLI's `orb init` command.

_**Edit this area to include a custom title and description.**_

---

## Resources

[CircleCI Orb Registry Page](https://circleci.com/developer/orbs/orb/<namespace>/<orb-name>) - The official registry page of this orb for all versions, executors, commands, and jobs described.

[CircleCI Orb Docs](https://circleci.com/docs/orb-intro/#section=configuration) - Docs for using, creating, and publishing CircleCI Orbs.

### How to Contribute

We welcome [issues](https://github.com/<organization>/<project-name>/issues) to and [pull requests](https://github.com/<organization>/<project-name>/pulls) against this repository!

### How to Publish An Update
1. Merge pull requests with desired changes to the main branch.
    - For the best experience, squash-and-merge and use [Conventional Commit Messages](https://conventionalcommits.org/).
2. Find the current version of the orb.
    - You can run `circleci orb info <namespace>/<orb-name> | grep "Latest"` to see the current version.
3. Create a [new Release](https://github.com/<organization>/<project-name>/releases/new) on GitHub.
    - Click "Choose a tag" and _create_ a new [semantically versioned](http://semver.org/) tag. (ex: v1.0.0)
      - We will have an opportunity to change this before we publish if needed after the next step.
4.  Click _"+ Auto-generate release notes"_.
    - This will create a summary of all of the merged pull requests since the previous release.
    - If you have used _[Conventional Commit Messages](https://conventionalcommits.org/)_ it will be easy to determine what types of changes were made, allowing you to ensure the correct version tag is being published.
5. Now ensure the version tag selected is semantically accurate based on the changes included.
6. Click _"Publish Release"_.
    - This will push a new tag and trigger your publishing pipeline on CircleCI.

### Development Orbs

A [Development orb](https://circleci.com/docs/orb-concepts/#development-orbs) can be created to help with rapid development or testing. Development orbs are mutable and expire after 90 days. They are versioned as `<orb-name>@dev:<branch-name>` or `<orb-name>@dev:alpha`.

To create and publish a Development orb on every commit with preview links:

#### 1. Set up GitHub Token (Required for PR Comments)

Add a `GITHUB_TOKEN` environment variable to your CircleCI publishing context:
- Go to CircleCI → Organization Settings → Contexts → Your Publishing Context
- Add an environment variable named `GITHUB_TOKEN`
- For **public repositories**: No special scopes required (use a basic GitHub token)
- For **private repositories**: Token needs `repo` scope

You can create a GitHub token at: https://github.com/settings/tokens

#### 2. Update the Configuration Files

**a) Update the `orb-tools/publish` job** in `.circleci/test-deploy.yml`:
   - Change `pub_type: production` to `pub_type: dev`
   - Change `filters: *release-filters` to `filters: *filters`
   - Add `add_pr_comment: true` to enable PR comments
   - Add `github_token: GITHUB_TOKEN` to authenticate with GitHub

```yaml
- orb-tools/publish:
    orb_name: <namespace>/<orb-name>
    vcs_type: github
    pub_type: dev
    # Enable PR comments with preview links
    add_pr_comment: true
    github_token: GITHUB_TOKEN
    # Ensure this job requires all test jobs and the pack job.
    requires:
      - orb-tools/pack
      - command-test
    context: <publishing-context>
    filters: *filters  # Changed from *release-filters
```

**b) Update the `orb-tools/pack` job** to use `filters: *filters` instead of `filters: *release-filters`

#### 3. What You'll Get

After pushing your changes to a pull request, the CircleCI pipeline will:
- ✅ Publish a dev orb on every commit
- ✅ **Automatically comment on the PR** with a preview link to the dev orb in the CircleCI Orb Registry
- ✅ Include the dev orb version (e.g., `<namespace>/<orb-name>@dev:<branch-name>`)
- ✅ Provide a direct link to test the orb in other projects

The dev orb can be referenced in other projects as `<namespace>/<orb-name>@dev:<branch-name>`

#### Reverting to Production

**Note:** Remember to revert these changes back to `pub_type: production` and `filters: *release-filters` before merging to main if you want to maintain the production release workflow.
# testdino-circle-ci-orb-v2
# testdino-circle-ci-v2
