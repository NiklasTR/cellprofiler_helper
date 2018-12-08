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
write_metadata <- function(df, path, interactive,
                           interactive_path = "~/metadata",
                           name = "pc",
                           bucket_mode){

  if(bucket_mode == TRUE){
    df <- df %>%
      group_by(Image_FileName_brightfield) %>%
      mutate(Image_PathName_brightfield = Image_PathName_brightfield %>%
               str_split(pattern = "/") %>%
               unlist() %>% .[5:length(.)] %>%
               str_flatten(collapse = "/")) %>%
      ungroup()
  }

  parent = df$Metadata_parent %>% unique() %>% .[1]

    print("creating a .csv with metadata")
    #CAVE: start messing with WDs
    #setwd(path)
    #if(interactive == TRUE){setwd("..")}
    #if(interactive == FALSE){setwd(interactive_path)}
    write.csv(df, paste0("~/metadata/metadata_", parent, "_", name, ".csv"), row.names=FALSE)
    #setwd(path)

}
