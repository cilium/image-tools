module github.com/cilium/image-tools/images/maker

go 1.14

require (
	github.com/docker/buildx v0.5.1 // indirect
	github.com/errordeveloper/docker-credential-env v0.1.5 // indirect
	github.com/errordeveloper/imagine v0.0.0-20201215192748-b3494e82bc78 // indirect
	github.com/errordeveloper/kue v0.3.1 // indirect
)

// based on https://github.com/docker/buildx/blob/v0.5.1/go.mod#L61-L68

replace (
	// protobuf: corresponds to containerd (through buildkit)
	github.com/golang/protobuf => github.com/golang/protobuf v1.3.5
	github.com/jaguilar/vt100 => github.com/tonistiigi/vt100 v0.0.0-20190402012908-ad4c4a574305

	// genproto: corresponds to containerd (through buildkit)
	google.golang.org/genproto => google.golang.org/genproto v0.0.0-20200224152610-e50cd9704f63
)
