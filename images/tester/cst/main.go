// Copyright 2020 Authors of Cilium
// SPDX-License-Identifier: Apache-2.0

package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"runtime"

	"github.com/GoogleContainerTools/container-structure-test/cmd/container-structure-test/app/cmd/test"

	"github.com/GoogleContainerTools/container-structure-test/pkg/color"
	"github.com/GoogleContainerTools/container-structure-test/pkg/drivers"
	"github.com/GoogleContainerTools/container-structure-test/pkg/types/unversioned"
)

const (
	configFile = "/test/spec.yaml"
)

/* container-structure-test can be used inside a contaner, however multiple flags have to be set and
   metadata file has to be provided also, namely:

   /usr/local/bin/container-structure-test --force --driver host --metadata /tmp/metadata.json --config /test/spec.yaml

   this version eliminates all of the flags, stubs out metadata and expects to find test specs at
   /test/spec.yaml, so the invocation is as simple as:

   /test/bin/cst
*/

func main() {
	version := flag.Bool("V", false, "print version and exit")

	flag.Parse()

	if *version {
		fmt.Printf("%s %s/%s", runtime.Version(), runtime.GOOS, runtime.GOARCH)
		os.Exit(0)
	}

	color.NoColor = true

	fakeMetadataPath, err := fakeMetadata()
	if err != nil {
		fmt.Printf("unable to write fake metadata: %s\n", err)
		os.Exit(4)
	}
	defer os.Remove(fakeMetadataPath)

	driverConfig := &drivers.DriverConfig{
		Metadata: fakeMetadataPath,
	}

	channel := make(chan interface{}, 1)

	go func() {
		tests, err := test.Parse(configFile, driverConfig, drivers.InitDriverImpl(drivers.Host))
		if err != nil {
			channel <- &unversioned.TestResult{
				Errors: []string{
					fmt.Sprintf("error parsing config file: %s", err),
				},
			}
			fmt.Printf("failed to load test spec: %s\n", err)
			os.Exit(3)
		}
		if tests == nil {
			fmt.Printf("failed to test: no tests\n")
			os.Exit(2)
		}

		tests.RunAll(channel, configFile)
		close(channel)
	}()

	if err := test.ProcessResults(os.Stdout, false, channel); err != nil {
		os.Exit(1)
	}
}

func fakeMetadata() (string, error) {
	content := []byte(`{ "config": {} }`)
	file, err := ioutil.TempFile("", "metadata")
	if err != nil {
		return "", err
	}
	if _, err := file.Write(content); err != nil {
		return "", err
	}
	if err := file.Close(); err != nil {
		return "", err
	}
	return file.Name(), nil
}
