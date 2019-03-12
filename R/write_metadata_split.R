#' Title
#'
#' @param df
#' @param path
#' @param interactive
#' @param interactive_path
#' @param name
#'
#' @return
#' @export
#'
#' @examples
write_metadata_split <- function(df, name = "pc", path_base){

  parent = df$Metadata_parent %>% unique() %>% .[1]
  well = df$Metadata_well %>% unique()




  print("creating multiple .csv with metadata for each well")
  #splitting data by well using a custom function
  metadata_split_path <- df %>%
    mutate(Metadata_well = factor(Metadata_well)) %>%
    split(.$Metadata_well) %>%
    #calling mclapply and passing on parent and name
    parallel::mclapply(write_split_with_name, parent = parent, name = name, path_base = path_base)

  #handing the paths over
  return(metadata_split_path)

}
