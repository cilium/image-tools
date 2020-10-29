module github.com/cilium/image-tools/images/maker

go 1.14

require (
	github.com/docker/buildx v0.4.2 // indirect
	github.com/errordeveloper/docker-credential-env v0.1.4 // indirect
	github.com/errordeveloper/imagine v0.0.0-20201029113538-97024922900e
	github.com/errordeveloper/kue v0.3.1
)

// based on https://github.com/docker/buildx/blob/f3111bcbef8ce7e3933711358419fa18294b3daf/go.mod#L69-L73

replace github.com/containerd/containerd => github.com/containerd/containerd v1.3.1-0.20200227195959-4d242818bf55

replace github.com/docker/docker => github.com/docker/docker v1.4.2-0.20200227233006-38f52c9fec82

replace github.com/jaguilar/vt100 => github.com/tonistiigi/vt100 v0.0.0-20190402012908-ad4c4a574305
