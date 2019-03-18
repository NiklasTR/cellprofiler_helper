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
                                    database = "/home/ubuntu/bucket/data/cellevent_tmrm_cellprofiler.db",
                                    channel_of_interest = "ch1",
                                    measurment_of_interest = "measurment_IdentifySecondaryObjects.csv"){

  pool <- pool::dbPool(RSQLite::SQLite(), dbname = database)
  files <- list.files(path_data, pattern = channel_of_interest, full.names = TRUE) %>% paste0(., "/", measurment_of_interest)

  tmp <- files %>% parallel::mclapply(dump_database)


}

