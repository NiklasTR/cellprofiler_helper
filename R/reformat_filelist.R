#' Title
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
reformat_filelist <- function(df){
  df%>%
    dplyr::rename(Image_FileName_brightfield = file_name,
                  Image_PathName_brightfield = file_path,
                  Metadata_well = well,
                  Metadata_fld = fld,
                  Metadata_zst = zst,
                  Metadata_channel = channel,
                  Metadata_parent = parent,
                  Metadata_timepoint = timepoint) %>%
    #I keep the original file name
    mutate(Metadata_original = Image_FileName_brightfield) %>%
    #For stability, I add a letter in front of the field object
    #CAVE: The script did not introduce this cahnge - start looking for errors here
    mutate(Metadata_fld = paste0("f", Metadata_fld)) %>%
    #change the path name
    group_by(Image_FileName_brightfield) %>%
    mutate(Image_PathName_brightfield = Image_PathName_brightfield %>%
             str_split(pattern = "/") %>% unlist() %>% .[1:length(.)-1] %>% str_flatten(collapse = "/")) %>%
    #add the file extension back
    ungroup() %>%
    mutate(Image_FileName_brightfield = paste0(Image_FileName_brightfield, ".", ext)) %>%
    #remove unwanted columns
    dplyr::select(Image_FileName_brightfield, Image_PathName_brightfield,
                  Metadata_fld, Metadata_channel,
                  Metadata_parent,
                  Metadata_original,
                  Metadata_zst,
                  Metadata_timepoint,
                  Metadata_well) %>%
    return()
}
