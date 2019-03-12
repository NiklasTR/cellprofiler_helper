#' Fill a JSON template with a specific metadata path and metadata groupings
#'
#' @param name
#'
#' @return
#' @export
#' @import jsonlite
#' @import parallel
#'
#' @examples
link_data_file <- function(metadata_split_path, json_template, json_path, path_base){
  json_new <- json_template #propably not needed

  json_new$data_file <- metadata_split_path %>% str_sub(21, -1) #10, -1

  out_path <- path_base %>% str_split(pattern = "/") %>% unlist()
  out_path[5] <- "flatfield"
  out_path <- out_path[c(5,6)] %>% paste(., collapse = "/")
  json_new$output <- out_path

  # I create the path for the grouping data
  grouping_path <-  metadata_split_path %>% str_sub(.,1, -5) %>% paste0(., "batch.txt")
  # I import the grouping text after trimming the last comma
  grouping <- readLines(grouping_path) %>% paste(. , collapse = " ") %>% str_sub(., 1, -3) %>% paste("[", ., "]") %>% fromJSON()

  # Now I insert the grouping into the JSON
  json_new$groups <- grouping

  # Finally I write my results
  name_metadata <- metadata_split_path %>% str_split(pattern = "/") %>% unlist() %>% tail(1) %>% str_sub(1, -5)
  name_json <- json_path %>% str_split(pattern = "/") %>% unlist() %>% tail(1) %>% str_sub(1, -15)

  write_json(json_new, pretty = TRUE, path = paste0(path_base, name_json, "_", name_metadata, ".json"), auto_unbox = TRUE)
  print(paste0("created ", paste0(path_base, name_json, "_", name_metadata, ".json")))

}