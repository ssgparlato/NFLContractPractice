library(tidyverse)
library(rvest)
library(glue)

# URL
positions_url <- 'https://overthecap.com/position/'

# Building a Web-scraping Function
salary_scrape <- function(year, position) {
  
  positions_url <- glue('https://overthecap.com/position/{position}/{year}')
  
  Sys.sleep(3)  # Delay of 3 seconds
  
  read_html(positions_url) %>%
    html_nodes('#content > div > div.right-panel > table') %>%
    html_table() %>%
    purrr::map_dfr(as.data.frame)  # Convert list to data frame
}

# Combine 'safety' data from 2015 to 2024
year_start <- 2015
year_end <- 2024
safety <- tibble()
position <- 'safety'

for (year in year_start:year_end) {
  data <- salary_scrape(year, position)
  data$Year <- year
  safety <- bind_rows(safety, data)
}

# View the 'safety' data frame
print(safety)

# Save 'safety' data frame
save(safety, file = "safety.RData")
