#' Title
#'
#' @param path
#' @param well_no
#' @param z
#' @param expected
#'
#' @return
#' @export
#' @import magrittr
#' @import dplyr
#' @import tidyr
#' @import stringr
#' @import purrr
#'
#' @examples
check_image_set <- function(path = getwd(), well_no = 384, z = 16, expected = c(1)){
  file <- extract_filelist(path = path)

  stopifnot(nrow(file) > 0)

  print(paste0("expecting ", well_no, " wells"))
  print(paste0("counted ", file$well %>% unique() %>% length(), " wells"))

  fld <- file$fld %>% unique() %>% length()
  print(paste0("identified ", fld, " fields per well"))

  # file_count <- file %>% group_by(well, fld, channel) %>% count() %>%
  #   ungroup() %>%
  #   rename(number_of_images_per_fld_and_channel = n) %>%
  #   group_by(number_of_images_per_fld_and_channel) %>%
  #   summarise(count = n()) %>%
  #   mutate(status = if_else(number_of_images_per_fld_and_channel %in% c(expected, z), "expected", "error"))

  file_count <- file %>% group_by(well, fld, channel) %>% count() %>%
    ungroup %>% nest(-well, -fld) %>%
    mutate(complete = map(data, ~ .x %>% arrange(n) %>% .$n %in% c(expected,z))) %>%
    unnest(complete) %>% distinct() %>%
    left_join(file %>% group_by(well, fld, channel) %>% count(), by = c("well", "fld")) %>%
    filter(complete == FALSE)

  if(nrow(file_count) == 0){
    print(paste0("I evaluated the directory: ", path))
    print("the dataset does not seem incomplete")
  } else {
    print("the dataset seems incomplete, printing report")
    print(file_count %>% as.data.frame())
  }

}
