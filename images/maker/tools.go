//go:build tools
// +build tools

package tools

import (
	_ "github.com/docker/buildx/cmd/buildx"
	_ "github.com/errordeveloper/docker-credential-env"
)
