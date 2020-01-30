library(dcphelper)
library(tidyverse)


plate_name = args = commandArgs(trailingOnly=TRUE)
# for debugging only
#plate_name = "000012095203__2019-12-09T17_58_26-Measurement_1"
print(paste0("Processing plate ", plate_name))

# sync files from S3 bucket for enhanced speed
print("Syncing result files to local directory, make sure you have sufficient disk space & your data is not in glacier. \n
      Glacier data can be recovered using the tools in the 'glacier_helper' directory.")
system('aws s3 sync s3://ascstore/flatfield/ ~/dcp_helper/data/results/ --exclude "*" --include "*.csv" --force-glacier-transfer')

# crawl local directory
for(i in plate_name){
  print(paste0("Processing plate ", i))
  collect_feature_data_db(i)
}
