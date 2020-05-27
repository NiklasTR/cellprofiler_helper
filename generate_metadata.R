################ Important Inputs
## Define directory names - you will have to change this manually!
## Make sure the directories contain no spaces!
## The pipeline assumes there is a directory in the "inbox" directory that has the following name:
## Call this script with: Rscript generate_metadata_"your-platename(s)-here".R

plate_name = args = commandArgs(trailingOnly=TRUE)
# for debugging only
#plate_name = "000012095203__2019-12-09T17_58_26-Measurement_1"
print(paste0("Processing plate ", plate_name))

################ Sometimes you also have to change these variables
## json templates
new_json_path_flat = "~/dcp_helper/python/job_flatfield_template.json" #brightfield
new_json_path_max = "~/dcp_helper/python/job_maxproj_template.json" #flourescence channels
new_json_path_seg = "~/dcp_helper/python/job_segmentation_template.json" #

## Name of channels
channel_v <- c("ch1", "ch2", "ch3", "ch4")
channel_n <- c("pc", "bf", "ce", "tm")

################ This is where the execution starts
################ Creating metadata
library(tidyverse)
library(dcphelper)
library(tictoc)

## Define paths
new_path_base = paste0("~/dcp_helper/metadata/", plate_name,"/") #relative path acceptable
inbox_path_base= paste0("/home/ubuntu/bucket/inbox/", plate_name,"/Images/") #absolute path with /home/ubuntu/ required
flatfield_path_base= paste0("~/bucket/flatfield/", plate_name,"/") #deprecated: only used for result collection

## Creating target dir
lapply(new_path_base, dir.create) # Do not execute this from a local machine if you expect other AWS services to access the directory later on

tic()
#### Creating metadata directories
print("creating pc metadata")
for(j in 1:length(inbox_path_base)){
  metadata_split_path <- create_flatfield_metadata_split(
    path = inbox_path_base[j],
    channel_of_interest = channel_v[1], #brightfield
    name = "pc",
    json_path = new_json_path, #not needed
    path_base = new_path_base[j],
    force = FALSE,
    include_brightfield_proj = TRUE, # setting this value to FALSE will skip brightfield image analysis
    include_additional_proj = TRUE)
}
toc()

tic()
for(i in 2:length(channel_n)){
  print(paste0("creating ", channel_n[i], " metadata"))
  for(j in 1:length(inbox_path_base)){
    metadata_split_path <- create_flatfield_metadata_split(
      path = inbox_path_base[j],
      channel_of_interest = channel_v[i], #brightfield
      name = channel_n[i],
      json_path = new_json_path, #not needed
      path_base = new_path_base[j],
      force = FALSE)
  }
}
toc()

################ Grouping data

tic()
print("Creating shell script for grouping")
path <- c()
for(i in 1:length(plate_name)){
path <- generate_group(plate_name[i], channel_n, new_path_base[i])


print(path)

print("Grouping data using python script")
system(path)
}
toc()

################ Aggregating information and executable file
print("Aggregating information and executable file")

tic()
for(j in new_path_base){
  link_json_metadata(metadata_split_path = list.files(j, pattern = "metadata_", full.names = TRUE) %>%
                       stringr::str_subset(pattern = ".csv") %>%
                       stringr::str_subset(pattern = "pc"),
                     json_path = new_json_path_seg,
                     path_base = j)
}
toc()

tic()
for(j in new_path_base){
  link_json_metadata(metadata_split_path = list.files(j, pattern = "metadata_", full.names = TRUE) %>%
                       stringr::str_subset(pattern = ".csv") %>%
                       stringr::str_subset(pattern = "bf"),
                     json_path = new_json_path_flat,
                     path_base = j)
}
toc()

tic()
channel_n_mod <- channel_n[3:4]
for(j in new_path_base){
  for(i in 1:length(channel_n_mod)){
    link_json_metadata(metadata_split_path = list.files(j, pattern = "metadata_", full.names = TRUE) %>%
                         stringr::str_subset(pattern = ".csv") %>%
                         stringr::str_subset(pattern = channel_n_mod[i]),
                       json_path = new_json_path_max,
                       path_base = j)
  }
}
toc()

### Grouping final job files

tic()
for(j in new_path_base){
  for(i in 1:length(channel_n)){
    group_jobs_bash(path_base = j,
                    name = channel_n[i],
                    letter_row_interval = c(1:16),
                    number_col_interval = c(1:24))
  }
}
toc()

### Pushing metadata to S3 bucket
system("./sync_metadata_to_bucket.sh")
