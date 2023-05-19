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

# Grab Over The Cap URL
otc_url <- 'https://overthecap.com/contracts'

# Read the table directly using rvest
otc_data <- otc_url %>% 
  read_html() %>%
  html_nodes('#content > div > div.contracts-container > table') %>% 
  html_table(fill = TRUE) %>% 
  .[[1]]


# Buffalo Bills Contracted Players and Contracts 
#(88 total; not all players signed)
bills_otc_url <- 'https://overthecap.com/salary-cap/buffalo-bills'

# Pull data from table
bills_pc2023 <- bills_otc_url %>%
  read_html() %>%
  html_nodes('#y2023 > div:nth-child(4) > table') %>% 
  html_table(fill = TRUE) %>% 
  .[[1]]

# Properly Name Each Column
colnames(bills_pc2023) <- c("Player", "Base Salary", "Prorated Bonus",
                            "Roster Bonus: Regular", "Roster Bonus: Per Game", 
                            "Workout Bonus", "Other Bonus", "B", "Guaranteed Salary",
                            "BL", "Cap Number", "BLA", "D", "DD", "DDD")

# Remove irrelevant columns
bills_pc2023 <- bills_pc2023[, !names(bills_pc2023) %in% c("B", "BL", "BLA", 
                                                           "D", "DD", "DDD")]
