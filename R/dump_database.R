#' Dump a dataframe into a database
#'
#' @param path_data
#' @param channel_of_interest
#' @param measurment_of_interest
#'
#' @return
#' @export
#' @import DBI
#' @import janitor
#' @import stringr
#' @import pool
#' @import RSQLite
#'
#' @examples
dump_database <- function(x, name_of_table = "cells"){
  x %>%
    read_csv %>%
    mutate(id = stringr::str_split(x, pattern = "/") %>% unlist() %>% .[8]) %>%
  janitor::clean_names() %>%
  dbWriteTable(pool, name_of_table, ., append = TRUE)

  print(paste0("dumped ", x))
}
