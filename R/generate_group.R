#' Generate grouping function call
#'
#' @param plate_name
#' @param channel_n
#'
#' @return
#' @export
#'
#' @examples
generate_group <- function(plate_name, channel_n, path_base){

  # expanding combinations
  df <- expand.grid(plate_name, channel_n) %>%
    as_tibble() %>%
    magrittr::set_colnames(c("plate_name", "channel_n"))

  path = paste0(path_base, plate_name[1], "_create_group.sh")

  # creating bash script
  c("#!/bin/sh",
    paste0("python ~/dcp_helper/python/ManualMetadata_dir.py ~/bucket/metadata/",
           df$plate_name,
           "/ ",
           read_lines("group_template.txt"),
           " ",
           df$channel_n)
  ) %>%
    write_lines(path)

  return(path)
}
