#' Linking JSON job file to metadata object
#'
#' @param name
#'
#' @return
#' @export
#' @import jsonlite
#' @import parallel
#'
#' @examples
link_json_metadata <- function(json_path, metadata_split_path, path = "~/bucket/metadata/"){
  #loading json file
  json <- jsonlite::read_json(path = json_path)

  json_metadata <- parallel::mclapply(list(metadata_split_path), insert_data_file, json_template = json)


}



# name_metadata <- metadata_split_path %>% str_split(pattern = "/") %>% unlist() %>% tail(1) %>% str_sub(1, -5)
# name_json <- json_template %>% str_split(pattern = "/") %>% unlist() %>% tail(1) %>% str_sub(1, -6)
#
# write_json(json_new, pretty = TRUE, path = paste0(path, name_json, "_", name_metadata))
