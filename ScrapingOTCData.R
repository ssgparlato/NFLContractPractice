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

# Combine 'center' data from 2015 to 2024
year_start <- 2015
year_end <- 2024
center <- tibble()
position <- 'center'

for (year in year_start:year_end) {
  data <- salary_scrape(year, position)
  data$Year <- year
  center <- bind_rows(center, data)
}

# Combine 'fullback' data from 2015 to 2024
fullback <- tibble()
position <- 'fullback'

for (year in year_start:year_end) {
  data <- salary_scrape(year, position)
  data$Year <- year
  fullback <- bind_rows(fullback, data)
}

# View the combined data frames
print(center)
print(fullback)

# Save 'center' data frame
save(center, file = "center.RData")

# Save 'fullback' data frame
save(fullback, file = "fullback.RData")