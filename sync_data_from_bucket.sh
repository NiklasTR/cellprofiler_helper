#!/bin/sh
aws s3 sync s3://ascstore/flatfield/ ~/dcp_helper/data/results/ --exclude "*" --include "*.csv" --force-glacier-transfer
