library(tidyverse)
library(rvest)
library(glue)

# URL
positions_url <- 'https://overthecap.com/position/'

# Building a Webscraping Function
salary_scrape <- function(year, position) {
  
  positions_url <- glue('https://overthecap.com/position/{position}/{year}')
  
  Sys.sleep(3)  # Delay of 3 seconds
  
  read_html(positions_url) %>%
    html_nodes('#content > div > div.right-panel > table') %>%
    html_table() %>%
    purrr::map_dfr(as.data.frame)  # Convert list to data frame
}

# Combine 'right-tackle' data from 2015 to 2024
year_start <- 2015
year_end <- 2024
right_tackle <- tibble()
position <- 'right-tackle'

for (year in year_start:year_end) {
  data <- salary_scrape(year, position)
  data$Year <- year
  right_tackle <- bind_rows(right_tackle, data)
}

# Combine 'left-tackle' data from 2015 to 2024
left_tackle <- tibble()
position <- 'left-tackle'

for (year in year_start:year_end) {
  data <- salary_scrape(year, position)
  data$Year <- year
  left_tackle <- bind_rows(left_tackle, data)
}

# View the combined data frames
print(right_tackle)
print(left_tackle)

# Save 'right_tackle' data frame
save(right_tackle, file = "right_tackle.RData")

# Save 'left_tackle' data frame
save(left_tackle, file = "left_tackle.RData")

