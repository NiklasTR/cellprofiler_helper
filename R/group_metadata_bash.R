#' LEGACY: Creating a shell script that used the Distributed Cell Profiler script ManualMetadata.py to create groupings
#'
#' @param metadata_split_path
#'
#' @return
#' @export
#'
#' @examples
group_metadata_bash <- function(metadata_split_path, path_base,
                                python_function = "python ~/dcp_helper/python/ManualMetadata_dir.py ",
                                metadata_grouping = "[\'Metadata_parent\',\'Metadata_timepoint\', \'Metadata_well\', \'Metadata_fld\', \'Metadata_channel\']"){

  bash_file <- paste0(path_base, "group_metadata_split_path.sh")
  print("writing bash script for metadata grouping")

  # create shell script to expand groupings
  fileConn<-file(bash_file)



  ##########LEGACY
  # # Create a shell script
  # metadata_split_path %>% unlist() %>% unname() %>% paste0(python_function, ., ' \"', metadata_grouping, '\"') %>%
  paste0(python_function, path_base, ' \"', metadata_grouping, '\"') %>%
  #adding the bin bash
    c('#!/bin/sh',
      'pip install --user pandas', #ugly way of managing the dependency of the cellprofiler function
      .) %>%
    writeLines(., fileConn)

  #run system command to make it executable
  system(paste0("chmod +x ", bash_file))

  #writeLines(c("Hello","World"), fileConn)
  close(fileConn)
  print(paste0("Now you have to execute the bash file to group metadata: ", bash_file))
}
