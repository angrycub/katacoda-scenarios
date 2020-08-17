#!/bin/bash

ERROR=" \
Levant is not found on the path. Please ensure that you have:

* downloaded linux-amd64-levant file
* set it to be executable
* moved it to /usr/local/bin/levant
"

command -v levant >/dev/null 2>&1 && echo "done" || echo $ERROR
