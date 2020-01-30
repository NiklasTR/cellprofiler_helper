#!/bin/sh
#Only run this script on the CTRL node, not the R instance you used to generate metadata.
aws s3 sync s3://ascstore/dcp_helper ~/dcp_helper/ --exclude "data*" --exclude "git*"
