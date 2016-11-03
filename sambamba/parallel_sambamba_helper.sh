#!/bin/bash
<${2} xargs -n 1 -P 4 -tl -i{} sambamba slice -o {}.slice.bam ${1} {}
