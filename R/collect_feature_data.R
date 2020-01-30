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
#'
#' @examples
<<<<<<< HEAD
collect_feature_data <- function(path_data,
                                 channel_of_interest = "ch1",
                                 result_path = "~/dcp_helper/data/results/",
                                 measurment_of_interest = "measurment_IdentifySecondaryObjects.csv"){

  barcode <- path_data %>% str_extract(pattern = "0000\\d+__\\d+-\\d\\d-\\d+T\\d+_\\d+_\\d+-Measurement_\\d")

  print("listing files")
  files <- list.files(paste0(result_path, barcode), pattern = channel_of_interest, full.names = TRUE) %>% paste0(., "/", measurment_of_interest)

  print("collecting data and writing feather object")
  processed_wells <- tibble(full_path = files,
                            barcode = barcode) %>%
    #head(100) %>%
    mutate(data = furrr::future_map(full_path, ~ .x %>% read_csv %>% janitor::clean_names())) %>%
    unnest() %>%
    feather::write_feather(paste0(result_path, barcode, "_feather"))

  return(processed_wells)

}

