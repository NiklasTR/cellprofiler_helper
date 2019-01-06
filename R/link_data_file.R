#' Link metadata path into JSON job object
#'
#' @param name
#'
#' @return
#' @export
#' @import jsonlite
#' @import parallel
#'
#' @examples
link_data_file <- function(metadata_split_path, json_template){
  json_new <- json_template #propably not needed

  json_new$data_file <- metadata_split_path

  return(json_new)
}
