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
collect_feature_data <- function(path_data,
                                 channel_of_interest = "ch1",
                                 result_path = "~/dcp_helper/data/results/",
                                 measurment_of_interest = "measurment_IdentifySecondaryObjects.csv"){
  #path_data <- "~/bucket/flatfield/000012070903__2019-01-10T20_04_27-Measurement_3/"
  #channel_of_interest = "ch1"
  #measurment_of_interest = "measurment_IdentifySecondaryObjects.csv"

  barcode <- path_data %>% str_extract(pattern = "0000\\d+__\\d+-\\d\\d-\\d+T\\d+_\\d+_\\d+-Measurement_\\d")

  # run this command first: aws s3 sync s3://ascstore/flatfield/ ~/dcp_helper/data/results/ --exclude "*" --include "*.csv" --force-glacier-transfer

  barcode %>%
    paste0("aws s3 ls s3://ascstore/flatfield/", ., "/ > processed_wells.txt") %>%
    system()

  processed_wells <- read_table2("processed_wells.txt",
                                 col_names = FALSE) %>% janitor::clean_names() %>%
    filter(grepl(x2, pattern = channel_of_interest)) %>%
    transmute(full_path = paste0(result_path, barcode, "/", x2, measurment_of_interest),
              barcode) %>%
    #head(10) %>%
    # reading all csv contents
    mutate(data = furrr::future_map(full_path, ~ .x %>% read_csv %>% janitor::clean_names())) %>%
    unnest() %>%
    feather::write_feather(paste0("~/bucket/flatfield/", barcode, "_feather"))


  #files <- list.files(path_data, pattern = channel_of_interest, full.names = TRUE) %>% paste0(., "/", measurment_of_interest)

  tmp <- files %>% parallel::mclapply(., function(x) x %>% read_csv %>% mutate(id = stringr::str_split(x, pattern = "/") %>% unlist() %>% .[8])) %>%
    bind_rows() %>%
    janitor::clean_names()
    tmp %>%
    write_csv2(paste0(path_data, measurment_of_interest))
}

