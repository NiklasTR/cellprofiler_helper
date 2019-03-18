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
#'
#' @examples
collect_feature_data_db <- function(path_data,
                                    database = "/home/ubuntu/cellevent_tmrm_cellprofiler.db",
                                    database_move = "/home/ubuntu/bucket/data/cellevent_tmrm_cellprofiler",
                                    channel_of_interest = "ch1",
                                    measurment_of_interest = "measurment_IdentifySecondaryObjects.csv"){
  # This function should not be run in parallel
  #file.copy(database, database_move, overwrite = FALSE)
  pool <- pool::dbPool(RSQLite::SQLite(), dbname = database)
  files <- list.files(path_data, pattern = channel_of_interest, full.names = TRUE) %>% paste0(., "/", measurment_of_interest)

  tmp <- files %>% lapply(dump_database)

  # giving the database back
  timestamp <- Sys.time() %>% stringr::str_remove_all(" ") %>% stringr::str_remove_all(":")
  system(paste0("cp ", database, " ", paste0(database_move, timestamp, ".db")))
}

