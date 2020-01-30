#' Creating a shell script that submits a whole collection of Jobs for job files that match a given pattern and well range
#'
#' @param path_base the path to the directory containing the job files
#' @param pattern a string that has to be contained in the job files of interest
#' @param letter_row_interval a vector of the form "c(1:3)" that will be translated to row letters
#' @param number_col_interval a vector of the form "c(1:3)" that will be translated to col numbers
#' @param python_call a python call that will be created
#'
#' @return
#' @export group_jobs_bash
#'
#' @examples
group_jobs_bash <- function(path_base,
                            name,
                            letter_row_interval,
                            number_col_interval,
                            python_call = "python ~/Distributed-CellProfiler/run.py submitJob "){
  # naming bash file
  # bash_file <- paste0(path_base, "/", "quick_group_jobs_bash_", name, "_", (Sys.Date()), ".sh")
  bash_file <- paste0(path_base, "/", "quick_group_jobs_bash_", name, "_", ".sh")
  # opening bash file connection
  fileConn<-file(bash_file)

  tibble(file_name = list.files(path_base, pattern = "job")) %>%
    filter(grepl(file_name, pattern = name)) %>%
    #removing every non-job file per default
    #filter(grepl(file_name, pattern = "job")) %>%
    #removing every non-json file per default
    filter(grepl(file_name, pattern = "json")) %>%
    #isolating the well annotation that is at the end of the file
    mutate(well = stringr::str_sub(file_name, -8, -6)) %>%
    #splitting into row and column
    mutate(letter_row = stringr::str_sub(well, 1, 1),
           number_col = stringr::str_sub(well, 2, 3) %>% as.numeric()) %>%
    #filtering by desired row and column range
    filter(letter_row %in% LETTERS[letter_row_interval]) %>%
    filter(number_col %in% number_col_interval) %>%
    #creating coumn with DCP function call
    mutate(call = paste0(python_call, path_base, "/", file_name)) %>%
    .$call %>%
    #writing to batch script file
    c('#!/bin/sh', .) %>%
    writeLines(., fileConn)

  #run system command to make it executable
  system(paste0("chmod +x ", bash_file))

  #message
  print(paste0("created ", bash_file))

  #writeLines(c("Hello","World"), fileConn)
  close(fileConn)
}
