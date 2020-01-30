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
                                    result_path = "~/dcp_helper/data/results/",
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

  measurement_id <- path_data %>% str_extract(pattern = "0000\\d+__\\d+-\\d\\d-\\d+T\\d+_\\d+_\\d+-Measurement_\\d")
  print("listing files")
  files <- list.files(paste0(result_path, measurement_id), pattern = channel_of_interest, full.names = TRUE) %>% paste0(., "/", measurment_of_interest)

  # I want to avoid saving data that is redundant. Therefore I want to remove every entry from the list of files, that has a matching id in the database
  # I pull the vector of ids in the database
  print("identifying new data")
  measurement <- tbl(pool, "measurement")
  existing_measurement <- measurement %>% dplyr::select(id_observation, id_observation_checksum) %>% distinct() %>% collect()
  # The following function takes the list of files and existing ids. It returns a list of files that have been filtered for the ids

  new_measurement = tibble(id_barcode = measurement_id %>% str_extract(pattern = "0000\\d+"),
         id_measurement = measurement_id,
         id_observation = files %>% str_extract(pattern = "0000\\d+__\\d+-\\d\\d-\\d+T\\d+_\\d+_\\d+-Measurement_\\d-sk\\d-...-f..-ch\\d")
         ) %>%
    separate(id_observation, remove = FALSE, sep = "-", c("t1", "t2", "t3",  "measurement_no", "iteration_no", "well", "field", "channel")) %>% select(-(t1:t3)) %>%
    mutate(measurement_no = str_extract(measurement_no, pattern = "\\d") %>% as.numeric(),
           iteration_no = str_extract(iteration_no, pattern = "\\d") %>% as.numeric()) %>%
    mutate(full_path = files,
           id_observation_checksum = tools::md5sum(full_path) %>% as.character()) %>%
    anti_join(existing_measurement)

  print(paste0("Adding ", nrow(new_measurement), " new Measurements"))
  new_measurement %>%
    dbWriteTable(pool, "measurement", ., append = TRUE)

  print("Writing observations")
  new_measurement %>%
    unite("observation", contains("observation"), sep = "___") %>%
    mutate(data = furrr::future_map2(observation, full_path, ~ {read_csv(.y) %>%
                                       janitor::clean_names() %>%
                                       mutate(observation = .x) %>%
                                       separate(observation, c("id_observation", "id_observation_checksum"), sep = "___") %>%
                                       dbWriteTable(pool, "observation", ., append = TRUE)
                  print(paste0("appended ", .y))}
                                       ))

}


