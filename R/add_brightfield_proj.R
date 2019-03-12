#' Add details for a brightfield projection to the metadata object
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
add_brightfield_proj <- function(file_f, p = "p16",
                                 flatfield_dir = "flatfield",
                                 brightfield_channel = "ch2",
                                 fk = "fk1fl1",
                                 projection_tag = "_projection",
                                 image_tag = ".tiff"){

    file_f %>%
    rowwise() %>%
    mutate(path_tag = paste(Metadata_parent, Metadata_timepoint, Metadata_well, Metadata_fld, brightfield_channel, sep = "-"),
           file_tag = paste0(brightfield_channel, Metadata_timepoint, fk, projection_tag, image_tag),
           Image_FileName_projection = Metadata_original %>%
             stringr::str_split(pattern = "-") %>%
             unlist() %>% .[1] %>% stringr::str_sub(1, -4) %>% paste0(., p) %>%
             append(file_tag) %>%
             paste(collapse = "-"),
           Image_PathName_projection = Image_PathName_brightfield %>%
             stringr::str_split(pattern = "/") %>%
             unlist() %>% .[c(1:4)] %>%
             append(flatfield_dir) %>%
             append(Metadata_parent) %>%
             append(path_tag) %>%
             paste(collapse = "/")) %>%
    select(-path_tag, -file_tag) %>% ungroup() %>% return()
}
