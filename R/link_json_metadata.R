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
link_json_metadata <- function(json_path,
                               metadata_split_path,
                               path_base){
  #loading json file
  json <- jsonlite::read_json(path = json_path)

  json_metadata <- parallel::mclapply(metadata_split_path, link_data_file, json_template = json, json_path = json_path, path_base = path_base)


}




