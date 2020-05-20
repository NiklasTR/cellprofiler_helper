#!/bin/sh
aws s3 sync ~/dcp_helper/ s3://ascstore/dcp_helper  --exclude "data*" --exclude ".git*"
