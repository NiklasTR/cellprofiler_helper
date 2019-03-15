#' Add details for a feature extraction of multi-channel_n images to metadata
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
add_flourescent_proj <- function(file_f,
                                 flatfield_dir = "flatfield",
                                 channel_n = c("ch3", "ch4"),
                                 projection_tag = "maxproject.tiff"){
  #if(length(channel_n) == 2){
  file_f %>%
      rowwise() %>%
      mutate(Image_FileName_ch3 = paste0(Metadata_parent, "-", Metadata_timepoint, "-", Metadata_well, "-", Metadata_fld, "-", channel_n[1], "_", projection_tag),
             Image_FileName_ch4 = paste0(Metadata_parent, "-", Metadata_timepoint, "-", Metadata_well, "-", Metadata_fld, "-", channel_n[2], "_", projection_tag),
             Image_PathName_ch3 = Image_PathName_projection %>% stringr::str_sub(1,-4) %>% append(channel_n[1]) %>% paste(collapse = ""),
             Image_PathName_ch4 = Image_PathName_projection %>% stringr::str_sub(1,-4) %>% append(channel_n[2]) %>% paste(collapse = "")) %>%
      ungroup() %>%
      return()
  }
  # if(length(channel_n) == 1){
  #   file_f %>%
  #     rowwise() %>%
  #     mutate(Image_FileName_ch3 = paste(Metadata_parent, Metadata_timepoint, Metadata_well, Metadata_fld, channel_n[1], projection_tag, collapse ="_"),
  #            #Image_FileName_ch4 = paste(Metadata_parent, Metadata_timepoint, Metadata_well, Metadata_fld, channel_n[2], projection_tag, collapse ="_"),
  #            Image_PathName_ch3 = Image_PathName_projection %>% stringr::str_sub(1,-4) %>% append(channel_n[1]) %>% paste(collapse = "")#,
  #            #Image_PathName_ch4 = Image_PathName_projection %>% stringr::str_sub(1,-4) %>% append(channel_n[2]) %>% paste(collapse = "")
  #            ) %>%
  #     ungroup() %>%
  #     return()
  # }
#}

