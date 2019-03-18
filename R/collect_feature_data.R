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
collect_feature_data <- function(path_data, channel_of_interest = "ch1", measurment_of_interest = "measurment_IdentifySecondaryObjects.csv"){
  #path_data <- "~/bucket/flatfield/000012070903_2019-01-10T20_04_27-Measurement_3/"
  #channel_of_interest = "ch1"
  #measurment_of_interest = "measurment_IdentifySecondaryObjects.csv"

  files <- list.files(path_data, pattern = channel_of_interest, full.names = TRUE) %>% paste0(., "/", measurment_of_interest)

  tmp <- files %>% parallel::mclapply(., function(x) x %>% read_csv %>% mutate(id = stringr::str_split(x, pattern = "/") %>% unlist() %>% .[8])) %>%
    bind_rows() %>%
    janitor::clean_names()
    tmp %>%
    write_csv2(paste0(path_data, measurment_of_interest))
}

