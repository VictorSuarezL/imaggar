#' Upload an image and return upload_id
#'
#' @param image_path Image path
#' @param api_key Api Key
#' @param api_secret Api Secret
#' @param ... More arguments to pass
#'
#' @return This function returns `upload_id`
#' @export
#'
#' @examples
#'
ima_upload <- function(image_path = "", api_key = api_key, api_secret = api_secret, ...) {
  assertthat::assert_that(assertthat::is.readable(image_path))

  response_text_json <- httr::POST(
    url = "https://api.imagga.com/v2/uploads",
    body = list(image = httr::upload_file(image_path)),
    httr::authenticate(api_key, api_secret)
  ) %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(flatten = TRUE)

  assertthat::assert_that(assertthat::are_equal(response_text_json$status$type, "success"))

  return(response_text_json$result$upload_id)
}
