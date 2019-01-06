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
                           name = "pc"){

  parent = df$Metadata_parent %>% unique() %>% .[1]


    print("creating a .csv with metadata")
    #CAVE: start messing with WDs
    #setwd(path)
    #if(interactive == TRUE){setwd("..")}
    #if(interactive == FALSE){setwd(interactive_path)}
    write.csv(df, paste0("~/metadata/metadata_", parent, "_", name, ".csv"), row.names=FALSE)
    #setwd(path)

}
