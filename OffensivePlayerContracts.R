# Load the required packages
library(tidyverse)
library(rvest)

# URL
url <- 'https://www.spotrac.com/nfl/positional/offense/'

# Read the table directly using rvest
op_contracts <- url %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="main"]/div/div[3]/table[2]') %>%
  html_table(fill = TRUE) %>%
  .[[1]]

# Assign column names
colnames(op_contracts) <- c('Rank', 'Picture', 'Name', 'AAV', '% of Team Salary')

# Remove irrelevant columns
op_contracts <- op_contracts[, !names(op_contracts) %in% c("Rank", "Picture")]

# Clean and convert the columns
op_contracts$AAV <- gsub("[\\$,]", "", op_contracts$AAV)
op_contracts$`% of Team Salary` <- gsub("%", "", op_contracts$`% of Team Salary`)
op_contracts$AAV <- as.numeric(op_contracts$AAV)
op_contracts$`% of Team Salary` <- as.numeric(op_contracts$`% of Team Salary`) / 100

# Checking data types of columns
sapply(op_contracts, class)
