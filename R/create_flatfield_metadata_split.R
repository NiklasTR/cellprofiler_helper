#' Title
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
create_flatfield_metadata_split <- function(path = paste0(getwd(), "/"),
                                      ch_number,
                                      force = FALSE,
                                      name = "bf",
                                      range = c(1, 16)){
  file <- extract_filelist(path, force)

  #filtering the channel of interest
  file_f <- file %>%
    dplyr::filter(channel == ch_number) %>%
    dplyr::filter(n_zst %in% c(range[1]:range[2]))


  #I reformat the table
  file_ff <- file_f %>% reformat_filelist()

  write_metadata_split(file_ff, name = name)
}
