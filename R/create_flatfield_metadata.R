#' Create input metadata for flatfield correction in distributed cell profiler
#'
#' @param path the path of the directry to screen. The path is not checked recursively.
#' @param csv should a .csv file with image metadata be created?
#' @param n_ch1 number of images in channel one (for example digital phase contrast)
#' @param n_ch2 number of images in channel two (for example brightfield) The function can only handle two channels.
#' @param create_flag should image files that are part of an incomplete set be renamed?
#' @param interactive if TRUE: the report will be created in the parent dir of path; if FALSE: the report will be created in the default dir on the ctrl node.
#' @param bucket_mode if TRUE: all file names have a relative path to the bucket root, if FALSE: all files have their root to the CTRL NODE
#'
#' @return No returned object. The function creates the available image sets for completeness, flags incomplete datasets and will write a metadata file.
#' @export
#'
#' @examples
create_flatfield_metadata <- function(path = getwd(), csv = TRUE,
                               n_ch1 = 16, n_ch2 = 16,
                               create_flag = FALSE,
                               interactive = TRUE,
                               bucket_mode = TRUE,
                               brightfield_channel = "ch2"){
  file <- extract_filelist(path)

  file_count <- file %>% group_by(well, fld, channel) %>% count() %>%
    ungroup %>% nest(-well, -fld) %>%
    mutate(new = map(data, ~ .x$n == c(n_ch1,n_ch2))) %>% unnest(new) %>% distinct()

  incomplete <- file %>% group_by(well, fld, channel) %>% count() %>%
    filter(!(channel == "ch1" & n == n_ch1)) %>% filter(!(channel == "ch2" & n == n_ch2))

  complete_file <- anti_join(file %>% ungroup(), incomplete %>% ungroup() %>% dplyr::select(well, fld), by = c("well", "fld")) %>%
    separate(file_path, c("name", "ext"), sep = "\\.", remove = FALSE)

  incomplete_file <- left_join(incomplete %>% ungroup() %>% dplyr::select(well, fld), file %>% ungroup(), by = c("well", "fld")) %>%
    separate(file_path, c("name", "ext"), sep = "\\.", remove = FALSE) %>% mutate(new_file_path = paste0(name, "_INCOMPLETE.", ext))

  #I reformat the complete_file tibble to match Cell Profiler requirements
  complete_file_cp <- complete_file%>%
    dplyr::rename(Image_FileName_brightfield = file_name,
                  Image_PathName_brightfield = file_path,
                  Metadata_well = well,
                  Metadata_fld = fld,
                  Metadata_zst = zst,
                  Metadata_channel = channel,
                  Metadata_parent = parent) %>%
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
    #remove non-brightfield images
    dplyr::filter(Metadata_channel == brightfield_channel) %>%
    #remove unwanted columns
    dplyr::select(Image_FileName_brightfield, Image_PathName_brightfield,
                  Metadata_fld, Metadata_channel,
                  Metadata_parent,
                  Metadata_original,
                  Metadata_zst)

  #cropping the first three directories, assuming that the s3 bucket is mounted under:
  #/home/ubuntu/bucket
  if(bucket_mode == TRUE){
    complete_file_cp <- complete_file_cp %>%
      group_by(Image_FileName_brightfield) %>%
      mutate(Image_PathName_brightfield = Image_PathName_brightfield %>%
               str_split(pattern = "/") %>%
               unlist() %>% .[5:length(.)] %>%
               str_flatten(collapse = "/")) %>%
      ungroup()
  }


  if((file_count$new %>% min()) == 0){
     incomplete %>%
      print.data.frame()
    print(sprintf("Not all well-field combinations contain %i and %i images. A list has been printed", n_ch1, n_ch2))
    print("if create_flag == TRUE, flags can be added")
    if(create_flag == TRUE){
      print("I am creating a clean directory")
      #CAVE: start messing with WDs
      # setwd(path)
      # setwd("..")
      # file.create("Images_complete_cases", showWarnings = TRUE)
      # file.copy(complete_file$file_path)
      file.rename(incomplete_file$file_path, incomplete_file$new_file_path)
    }
  }


  #CAVE: start messing with WDs
  setwd(path)
  if(interactive == TRUE){setwd("..")}
  if(interactive == FALSE){setwd("~/metadata")}
  write.csv(complete_file_cp, "metadata.csv", row.names=FALSE)
  print(paste0("creating a .csv with metadata at", getwd()))
}
