#' Prepare the learning dataset for 046703
#'
#' @param path
#' @param ch_number
#' @param interactive
#' @param interactive_path
#' @param name
#'
#' @return
#' @export
#'
#' @examples
#'

pull_046703learningdata <- function(){

  #bad practice but handy
  library(tidyverse)
  # define vars
  path = "/home/ubuntu/bucket/inbox/703__2018-11-07T20_55_16-Measurement_1/Images/"
  interactive = TRUE
  interactive_path = "~/bucket/metadata"
  name = "brightfield"
  bucket_mode = FALSE

  file <- extract_filelist(path)

  file_f <- file %>%
    # I want to get the brightfield images
    dplyr::filter(channel == "ch2") %>%
    # I only want the rows A until D and the wells 1:23
    dplyr::filter(l_row %in% c(LETTERS[1:4]),
                  col != "24")

  file_ff <- file_f %>% reformat_filelist()
  write_metadata(file_ff, path = path, interactive = interactive, bucket_mode = bucket_mode, name = "bf_learningdata")

}
