extract_metadata_raw <- function(path = getwd(), csv = TRUE, n_ch1 = 1, n_ch2 = 16, create_flag = FALSE, interactive = FALSE){
  #require(tidyverse)
  #library(platetools)
  file <- tibble(file_name = list.files(path = path, full.names = FALSE),
                 file_path = list.files(path = path, full.names = TRUE)) %>%
    #I keep only tiff files
    mutate(is_image = grepl(pattern = ".tiff", x = file_name)) %>% filter(is_image == TRUE) %>%
    #I start formatting files
    separate(file_name, c("file_name", "type"), sep = "\\.") %>% separate(file_name, c("location", "channel"), remove = FALSE, sep = "-") %>%
    #I separate the file name variable twice, as I want to convert one batch to numerics
    separate(location, c("row", "col", "fld", "zst"), sep = c(3, 6, 9), remove= FALSE) %>%
    separate(location, c("n_row", "n_col", "n_fld", "n_zst"), sep = c(3, 6, 9)) %>%
    mutate_at(vars(row:zst), funs(substr(., 2,3))) %>% mutate_at(vars(n_row:n_zst), funs(substr(., 2,3))) %>%
    mutate_at(vars(n_row:n_zst), funs(as.numeric)) %>%
    #I create a well letter
    mutate(l_row = LETTERS[n_row]) %>%
    #I create a well variable
    unite(well, l_row, col, remove = FALSE, sep ="") %>%
    mutate(channel = substr(channel, 1, 3)) %>%
    mutate(parent = path %>% str_split(pattern = "/") %>% unlist %>% .[length(.)-1]) %>%
    dplyr::select(file_name, n_zst, well:zst, l_row, channel, file_path, parent)

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
                  Metadata_original)


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

  print("creating a .csv with metadata")
  #CAVE: start messing with WDs
  setwd(path)
  if(interactive == TRUE){setwd("..")}
  if(interactive == FALSE){setwd("~/metadata")}
  write.csv(complete_file_cp, "metadata.csv", row.names=FALSE)
}
