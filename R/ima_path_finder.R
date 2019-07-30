#' Title
#'
#' @param image_path Where is the image url or local path
#' @param api_key Api Key
#' @param api_secret Api Secret
#' @param ... More arguments
#'
#' @return The url complete where to call the IMAGGA API
#' @export
#'
#' @examples
#'
ima_path_finder <- function(image_path = "", api_key = api_key, api_secret = api_secret, ...) {
  end_point <- "https://api.imagga.com/v2/tags?"

  sHEAD <- purrr::safely(httr::HEAD)
  url_checked <- sHEAD(image_path)
  is_image_path_url <- assertthat::see_if(
    assertthat::are_equal(url_checked$result$status_code, 200)
  )

  if (is_image_path_url[[1]]) {
    message("Success! Status is 200 so image is hoshtaged in an url")

    tags_endpoint <- "image_url="
    image_path_complete <- paste0(end_point, tags_endpoint, image_path)
    return(image_path_complete)
  } else if (assertthat::is.readable(image_path)) {
    message("Trying image in local path")

    image_upload_id <- ima_upload(image_path, api_key = api_key, api_secret = api_secret)
    assertthat::assert_that(assertthat::not_empty(image_upload_id))
    message("Success! Image has an upload_id")
    tags_endpoint <- "image_upload_id="
    image_path_complete <- paste0(end_point, tags_endpoint, image_upload_id)
    return(image_path_complete)
  } else {
    message("Failing in url and path sorry about that!")
  }
}
