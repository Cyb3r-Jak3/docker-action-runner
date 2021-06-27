# GitHub Actions Runner

This is a docker image that runs [actions/runner](https://github.com/actions/runner). Allows for easy deployment and scale of self-hosted runners. All options are sent through environment variables.

## Using

You can either pull from DockerHub (`docker pull cyb3rjak3/github-runner`) or GitHub(`docker pull ghcr.io/cyb3r-jak3/github-runner`).

Recommended to use an env file for deploying.

Run with `docker run -it -d --env-file=.env --name actions_runner cyb3rjak3/github-runner`. The runner will be online and running after the authentication process completes.

## Environment Variables Options

## Auth

Either `RUNNER_CFG_PAT` or `RUNNER_TOKEN` needs to be set. `RUNNER_CFG_PAT` will be used to generate a `RUNNER_TOKEN` for the given `RUNNER_SCOPE`

### RUNNER_SCOPE

#### Required

URL for the runner. Either repo or org

### LABELS

Labels to added to the runner

### RUNNER_NAME

Name of the runner. Defaults to hostname

### GHE_HOSTNAME

The GitHub Enterprise URL for your deployment.
