#' Title
#'
#' @param path
#' @param ch_number
#' @param interactive
#' @param interactive_path
#' @param name
#'
#' @return()
#'
#' @examples
create_flatfield_metadata <- function(path = paste0(getwd(), "/"),
                                      ch_number,
                                      force = FALSE,
                                      name = "bf",
                                      range = c(1, 16),
                                      interactive = TRUE,
                                      interactive_path = "~/bucket/metadata"){
  file <- extract_filelist(path, force)
  #TODO: remove deprecated interactive etc. flags

  #filtering the channel of interest
  file_f <- file %>%
    dplyr::filter(channel == ch_number) %>%
    dplyr::filter(n_zst %in% c(range[1]:range[2]))


  #I reformat the table
  file_ff <- file_f %>% reformat_filelist()

  write_metadata(file_ff, path = path, interactive = interactive, name = name)
}
