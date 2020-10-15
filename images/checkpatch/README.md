# Checkpatch Image

This directory contains the files necessary to package a custom version of
checkpatch as a Docker image.

## Checkpatch.pl Script

The `checkpatch.pl` script in this repository comes from the Linux repository.
The latest version should be available at
<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/checkpatch.pl>.

The latest version for the accompanying spelling file can be downloaded from
<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/spelling.txt>.

The script `checkpatch.pl` is distributed under the terms of the GNU General
Public License (GPL) version 2 (see file [COPYING](COPYING)).

## Bash Script and Other Additions

The bash wrapper is used to call the `checkpatch.pl` script with the relevant
options and arguments for working on Cilium's code base. It passes makes sure
`checkpatch.pl` is run on the latest commits or, if the `-a` option is passed,
on the source files under the `bpf/` directory. It should be executed from the
root of Cilium's repository:

```
docker run --rm --user 1000 -it --workdir /workspace -v $PWD:/workspace <container_id> /opt/checkpatch/checkpatch.sh
```

The list of deprecated terms was specifically added for Cilium.

## Custom Patches

When building the Docker image, several patches are applied to the script.

* `fixes/ignore-C99-comments-for-SPDX-tags.diff`: Cilium follows the kernel
  coding style, and avoids the use of C99-style comments in its eBPF programs.
  The script `checkpatch.pl` is instructed to report such comments, but it is
  not able to distinguish when they are used for SPDX license tags, which is a
  legitimate use. This script fixes `checkpatch.pl` accordingly. Note that it
  was [submitted for upstream inclusion](https://lore.kernel.org/patchwork/patch/1265784/),
  but rejected by the maintainer.

* `fixes/use-CODEOWNERS-instead-of-MAINTAINERS.diff`: Cilium has a `CODEOWNERS`
  file instead of the `MAINTAINERS` used by the Linux kernel. Replace a few
  occurrences in `checkpatch.pl`, where relevant, to check and point to the
  correct owner file when new source code files are added.
