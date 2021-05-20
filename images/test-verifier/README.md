# test-verifier Image

This directory contains the files necessary to build the test-verifier
Docker image, used in Cilium's end-to-end test K8sVerifier.

That image has everything necessary to build maptool, cilium-migrate-map,
and Cilium's BPF datapath, as well as tooling to load the datapath once
compiled (bpftool, tc, ip).
