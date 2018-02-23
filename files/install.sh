#!/bin/bash
set -x
bash <(curl -Ss https://my-netdata.io/kickstart.sh) all --install "$netdata_dir" --dont-wait --dont-start-it
