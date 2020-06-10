#' Title
#'
#' @param path
#' @param channel
#' @param interactive
#' @param interactive_path
#' @param name
#'
#' @return
#' @export
#'
#' @examples
create_flatfield_metadata_split <- function(path = paste0(getwd(), "/"),
                                      channel_of_interest,
                                      name = "bf",
                                      range = c(1, 16),
                                      json_path = "~/bucket/metadata/job_flatfield_template.json", #TODO not needed
                                      path_base = "~/bucket/metadata/",
                                      force = FALSE,
                                      include_brightfield_proj = FALSE,
                                      include_additional_proj = FALSE){
  file <- extract_filelist(path, force, path_base)

  number_of_planes = max(file %>% select(channel, n_zst) %>% filter(channel == "ch2") %>% .$n_zst)

  #filtering the channel of interest
  print("filtering channel")
  file_f <- file %>%
    dplyr::filter(channel == channel_of_interest) %>%
    dplyr::filter(n_zst %in% c(range[1]:range[2]))


  #I reformat the table
  print("formatting data")
  file_ff <- file_f %>% reformat_filelist()

  if(include_brightfield_proj == TRUE | include_additional_proj == TRUE){
    file_ff <- add_brightfield_proj(file_ff, p=sprintf('p%02d', number_of_planes))
    print("adding brightfield metadata")
  }
  # uncoupled the two if statements
  if(include_additional_proj == TRUE){
      file_ff <- add_flourescent_proj(file_ff)
      print("adding additional metadata")
  }
  # hacky way of removing brightfield information - this is necessary as flourescent proj depends on code in brightfield proj.
  if(include_additional_proj == TRUE & include_brightfield_proj == FALSE){
    file_ff <- file_ff %>% dplyr::select(-contains("projection"))
    print("removing brightfield metadata")
  }

  metadata_split_path <- write_metadata_split(file_ff, name = name, path_base = path_base)

  # Creating metadata bash file
  #group_metadata_bash(metadata_split_path, path_base)

  return(metadata_split_path)



  #link_json_metadata(metadata_split_path = metadata_split_path, json_path = json_path, path_base = path_base)


}
