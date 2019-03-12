#' @param path
#' @param interactive
#' @param interactive_path
#' @param name
#'
#' @return
#' @export
#' @import parallel
#'
#' @examples
write_split_with_name <- function(df, parent, name, path_base){
  well <- df$Metadata_well %>% unique()

  metadata_split_path <- paste0(path_base, "metadata_", parent, "_", name, "_", well, ".csv")

  write.csv(df, metadata_split_path, row.names=FALSE)
  print(paste0("created ", metadata_split_path))

  return(metadata_split_path)
}

# Example function that can be used with mtcars

# cyl_write <- function(df){
#   well <- df$cyl %>% unique
#   write.csv(df, paste0("test_", well))
# }
#
# mtcars %>% mutate(cyl = factor(cyl)) %>% split(.$cyl) %>% parallel::mclapply(cyl_write)
