## code to prepare `tag_output` dataset goes here

library(imaggar)

api_key <- "acc_f0273ebca9e09dc"
api_secret <- "c2340eed126f1870dc3736063f546b83"

image_path <- "https://upload.wikimedia.org/wikipedia/commons/7/73/Lion_waiting_in_Namibia.jpg"

tag_output <- ima_tag(image_path, api_key = api_key, api_secret = api_secret)

usethis::use_data(tag_output, internal = TRUE)
