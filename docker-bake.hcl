target "default" {
    inherits = ["linux"]
}

target "linux" {
    dockerfile="Dockerfile"
    tags=[
        "cyb3rjak3/github-runner:linux",
        "ghcr.io/cyb3r-jak3/github-runner:linux"
    ] 
}

// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {}

target "release" {
    inherits = ["docker-metadata-action", "linux"]
}