#' Collect Feature data after image analysis with cellprofiler
#'
#' @param path_data
#' @param channel_of_interest
#' @param measurment_of_interest
#'
#' @return
#' @export
#' @import parallel
#' @import janitor
#' @import RSQLite
#' @import RPostgres
#' @import pool
#' @import DBI
#'
#' @examples
collect_feature_data_db <- function(path_data,
                                    host_db = "biosensor.c9k2hfiwt5mi.us-east-2.rds.amazonaws.com",
                                    channel_of_interest = "ch1",
                                    measurment_of_interest = "measurment_IdentifySecondaryObjects.csv"){
  ## This function should not be run in parallel
  #file.copy(database, database_move, overwrite = FALSE)
  pool <- pool::dbPool(RPostgres::Postgres(),
                       host = host_db,
                       dbname = "biosensor",
                       port = 5432,
                       user = "biosensor",
                       password = readLines("~/password.txt"))
  print("listing files")
  files <- list.files(path_data, pattern = channel_of_interest, full.names = TRUE) %>% paste0(., "/", measurment_of_interest)

  tmp <- files %>% parallel::mclapply(dump_database, con = pool)

  # giving the database back
  #timestamp <- Sys.time() %>% stringr::str_remove_all(" ") %>% stringr::str_remove_all(":")
  #system(paste0("cp ", database, " ", paste0(database_move, timestamp, ".db")))
}


