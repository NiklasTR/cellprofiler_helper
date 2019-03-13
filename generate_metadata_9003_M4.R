################ Important Inputs
## Define directory names - you will have to change this manually!
## The pipeline assumes there is a directory in the "inbox" directory that has the following name:
## Call this script with: Rscript generate_metadata_"your-name-here".R
plate_name = c("000012049003__2019-02-01T12_09_07-Measurement_4")

################ Sometimes you also have to change these variables
## json templates
new_json_path_flat = "/home/ubuntu/bucket/metadata/job_flatfield_template.json"
new_json_path_max = "/home/ubuntu/bucket/metadata/job_maxproj_template.json"
new_json_path_seg = "/home/ubuntu/bucket/metadata/job_segmentation_template.json"

## Name channels
channel_v <- c("ch1", "ch2", "ch3", "ch4")
channel_n <- c("pc", "bf", "ce", "tm")

################ This is where the execution starts
################ Creating metadata
library(tidyverse)
library(dcphelper)

## Define paths
new_path_base = paste0("/home/ubuntu/bucket/metadata/", plate_name,"/")
inbox_path_base= paste0("/home/ubuntu/bucket/inbox/", plate_name,"/Images/")

## Creating target dir
lapply(new_path_base, dir.create) # Do not execute this from a local machine if you expect other AWS services to access the directory later on

## Creating metadata directories
# print("creating pc metadata")
# for(j in 1:length(inbox_path_base)){
#   metadata_split_path <- create_flatfield_metadata_split(
#     path = inbox_path_base[j],
#     channel_of_interest = channel_v[1], #brightfield
#     name = "pc",
#     json_path = new_json_path, #not needed
#     path_base = new_path_base[j],
#     force = FALSE,
#     include_brightfield_proj = TRUE,
#     include_additional_proj = TRUE)
# }
#
#
# for(i in 2:length(channel_n)){
#   print(paste0("creating ", channel_n[i], " metadata"))
#   for(j in 1:length(inbox_path_base)){
#     metadata_split_path <- create_flatfield_metadata_split(
#       path = inbox_path_base[j],
#       channel_of_interest = channel_v[i], #brightfield
#       name = channel_n[i],
#       json_path = new_json_path, #not needed
#       path_base = new_path_base[j],
#       force = FALSE)
#   }
# }

################ Grouping data

print("Creating shell script for grouping")
generate_group(plate_name, channel_n)

print("Grouping data using python script")
path = paste0("/home/ubuntu/bucket/metadata/", plate_name[1], "/", plate_name[1], "_create_group.sh")
system(path)

################ Aggregating information and executable file

for(j in new_path_base){
  link_json_metadata(metadata_split_path = list.files(j, pattern = "metadata_", full.names = TRUE) %>%
                       stringr::str_subset(pattern = ".csv") %>%
                       stringr::str_subset(pattern = "pc"),
                     json_path = new_json_path_seg,
                     path_base = j)
}


for(j in new_path_base){
  link_json_metadata(metadata_split_path = list.files(j, pattern = "metadata_", full.names = TRUE) %>%
                       stringr::str_subset(pattern = ".csv") %>%
                       stringr::str_subset(pattern = "bf"),
                     json_path = new_json_path_flat,
                     path_base = j)
}


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

### Grouping final job files

for(j in new_path_base){
  for(i in 1:length(channel_n)){
    group_jobs_bash(path_base = j,
                    name = channel_n[i],
                    letter_row_interval = c(1:16),
                    number_col_interval = c(1:24))
  }
}
