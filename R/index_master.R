# ####### setting global variables
# library(tidyverse)
# library(dcphelper)
#
# new_path_base = c("/home/ubuntu/bucket/metadata/000012049003__2019-01-28T21_02_07-Measurement_2/"
# )
#
# inbox_path_base= c("/home/ubuntu/bucket/inbox/000012049003__2019-01-28T21_02_07-Measurement_2/Images/")
#
# new_json_path_flat = "/home/ubuntu/bucket/metadata/job_flatfield_template.json"
# new_json_path_max = "/home/ubuntu/bucket/metadata/job_maxproj_template.json"
# new_json_path_seg = "/home/ubuntu/bucket/metadata/job_segmentation_template.json"
#
# ## Creating target dir
# dir.create(new_path_base) # Do not execute this from a local machine if you expect other AWS services to access the directory later on
#
# ## Name channels
# channel_v <- c("ch1", "ch2", "ch3", "ch4")
# channel_n <- c("pc", "bf", "ce", "tm")
#
# ####### indexing directory
#
# for(j in 1:length(inbox_path_base)){
#   metadata_split_path <- create_flatfield_metadata_split(
#     path = inbox_path_base[j],
#     channel_of_interest = channel_v[i], #brightfield
#     name = "pc",
#     json_path = new_json_path, #not needed
#     path_base = new_path_base,
#     force = FALSE,
#     include_brightfield_proj = TRUE,
#     include_additional_proj = TRUE)
# }
#
#
# for(i in 2:length(channel_n)){
#   for(j in 1:length(inbox_path_base)){
#     metadata_split_path <- create_flatfield_metadata_split(
#       path = inbox_path_base[j],
#       channel_of_interest = channel_v[i], #brightfield
#       name = channel_n[i],
#       json_path = new_json_path, #not needed
#       path_base = new_path_base,
#       force = FALSE)
#   }
# }
#
