#' Generate grouping function call
#'
#' @param plate_name
#' @param channel_n
#'
#' @return
#' @export
#'
#' @examples
generate_group <- function(plate_name, channel_n){

# expanding combinations
df <- expand.grid(plate_name, channel_n) %>%
  as_tibble() %>%
  magrittr::set_colnames(c("plate_name", "channel_n"))

# creating bash script
c("#!/bin/sh",
paste0("python /home/ubuntu/bucket/metadata/ManualMetadata_dir.py /home/ubuntu/bucket/metadata/",
       df$plate_name,
       "/ ",
       read_lines("group_template.txt"),
       " ",
       df$channel_n)
) %>%
  write_lines(paste0("/home/ubuntu/bucket/dcphelper/", plate_name[1], "_create_group.sh"))
}
