#' Title
#'
#' @param path
#'
#' @return
#' @export
#' @import readr
#' @import dplyr
#' @import magrittr
#'
#' @examples
build_filelist <- function(path, force, path_base){
  # path mus be with trailing backslash
  parent <- path %>% str_split(pattern = "/") %>% unlist %>% .[length(.)-2]
  if(file.exists(paste0(path_base, "dir_content_", parent ,".txt")) & force == FALSE){
    print("Found file list")
  } else {
  print("Initiating file list")
  system(paste0("ls ", path, " > ", path_base, "dir_content_", parent ,".txt"))
  }
  print("Reading file list")
  dir_content <- readr::read_csv(paste0(path_base, "dir_content_", parent ,".txt"),col_names = FALSE) %>%
  magrittr::set_colnames(c("file_name")) %>%
  dplyr::mutate(file_path = paste(path, file_name, sep = ""))

  return(dir_content)
}
