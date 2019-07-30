#' Rescale big images if its needed
#'
#' @param image_path File path where the image is located
#' @param ... More arguments passed to this function
#'
#' @return Path directory where te rescale image is.
#' @export
#'
#' @examples
#'
ima_rescale <- function(image_path = "", ...) {
  sfile.remove <- purrr::quietly(file.remove)
  image_read_magick <- magick::image_read(image_path)
  print(image_read_magick)
  image_width <- magick::image_info(image_read_magick)$width
  image_height <- magick::image_info(image_read_magick)$height

  if (image_width < 300 && image_height < 300) {
    message("No resize in image is needed, check your connection")
  } else if (image_width < image_height) {
    image_read_magick <- magick::image_scale(image_read_magick, "300")
  } else {
    image_read_magick <- magick::image_scale(image_read_magick, "x300")
  }

  image_path <- magick::image_write(image_read_magick, tempfile())

  return(image_path)
  sfile.remove(image_path)
}
