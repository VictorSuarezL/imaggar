#' A function to call the tagger option in IMAGA API
#'
#' @param image_path The path where the image is located, it can be a url or a local directory.
#' @param api_key Api Key
#' @param api_secret Api Secret
#' @param limit_tag A number to limit the total n of tags to receive.
#' @param syssleep Modify system sleep. By default 5 to be polite.
#' @param rescale If your image is too big you can rescale it.
#'
#' @return Return a data frame containing `limit_tag` from an image.
#' @export
#'
#' @examples
#'
ima_tag <- function(image_path = "", api_key = api_key, api_secret = api_secret, limit_tag = -1, syssleep = 5, rescale = FALSE) {
  assertthat::assert_that(assertthat::is.string(image_path))
  assertthat::assert_that(assertthat::is.string(api_key))
  assertthat::assert_that(assertthat::is.string(api_secret))

  if (rescale) {
    image_path <- ima_rescale(image_path)
  }

  x_complete <- ima_path_finder(
    image_path = image_path,
    api_key = api_key, api_secret = api_secret
  )

  response <- httr::GET(
    url = x_complete,
    query = list(limit = limit_tag),
    httr::authenticate(api_key, api_secret)
  )

  if (response$status_code == 200) {
    mess <- paste(
      "Congrats image uploaded!\nYou have",
      response$headers$`monthly-limit-remaining`,
      "request left"
    )
    message(mess)
  } else {
    message("Sorry unable to connect :(")
  }

  response_text <- httr::content(response, as = "text", encoding = "UTF-8")

  image_df <- jsonlite::fromJSON(response_text, flatten = TRUE) %>%
    data.frame() %>%
    dplyr::as_tibble()

  Sys.sleep(5)
  return(image_df)
}
