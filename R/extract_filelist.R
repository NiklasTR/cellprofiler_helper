#' Return tibble describing each image file with well, field etc. in a given directory
#'
#' @param path the path of the directry to screen. The path is not checked recursively
#' @return a tibble with columns: file_name, n_zst, well:zst, l_row, channel, file_path, parent
#' @export
#'
#' @examples
#'
extract_filelist <- function(path = getwd(), force, path_base){
   file <- build_filelist(path, force, path_base) %>%
     # tibble(file_name = list.files(path = path, full.names = FALSE),
     #             file_path = list.files(path = path, full.names = TRUE)) %>%
    #I keep only tiff files
    mutate(is_image = grepl(pattern = ".tiff", x = file_name)) %>% filter(is_image == TRUE) %>%
    #I start formatting files
    separate(file_name, c("file_name", "type"), sep = "\\.") %>% separate(file_name, c("location", "channel"), remove = FALSE, sep = "-") %>%
    #I separate the file name variable twice, as I want to convert one batch to numerics
    separate(location, c("row", "col", "fld", "zst"), sep = c(3, 6, 9), remove= FALSE) %>%
    separate(location, c("n_row", "n_col", "n_fld", "n_zst"), sep = c(3, 6, 9)) %>%
    mutate_at(vars(row:zst), funs(substr(., 2,3))) %>% mutate_at(vars(n_row:n_zst), funs(substr(., 2,3))) %>%
    mutate_at(vars(n_row:n_zst), funs(as.numeric)) %>%
    #I create a well letter
    mutate(l_row = LETTERS[n_row]) %>%
    #I create a well variable
    unite(well, l_row, col, remove = FALSE, sep ="") %>%
    separate(channel, c("channel", "timepoint", "fkfl"), sep = c(3, 6), remove= FALSE) %>%
    # mutate(channel = substr(channel, 1, 3)) %>% #legacy
    mutate(parent = path %>% str_split(pattern = "/") %>% unlist %>% .[length(.)-2]) %>%
    dplyr::select(file_name, n_zst, well:zst, l_row, channel, file_path, parent, timepoint) %>%
     separate(file_path, c("name", "ext"), sep = "\\.", remove = FALSE)

  return(file)
}
