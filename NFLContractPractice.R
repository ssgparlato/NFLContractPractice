install.packages('RCurl')
library(RCurl)
library(tidyverse)
library(glue)
library(XML)
library(dplyr)

#URL
url <- 'https://www.spotrac.com/nfl/positional/offense/'

#Webscrape specific table
url_parsed <- htmlParse(getURL(url), asText = TRUE)
tableNodes <- getNodeSet(url_parsed, c('//*[@id="main"]/div/div[3]/table[2]'))

#Name columns
bls_table2 <- readHTMLTable(tableNodes[[1]], header = c('Rank', 'Picture', 'Name',
                            'AAV', '% of Team Salary'))
#Remove Irrelavant columns
player_contracts <- bls_table2[,!names(bls_table2) %in% c("Rank","Picture")]

# check for NA's
sum(is.na(player_contracts$AAV))        
sum(is.na(player_contracts$`% of Team Salary`))
sum(is.na(player_contracts$Name))

#remove $ and % from character columns
player_contracts$AAV <- gsub("\\$", "", player_contracts$AAV)
player_contracts$AAV <- gsub(",", "", player_contracts$AAV)
player_contracts$`% of Team Salary` <- gsub("%", "", player_contracts$`% of Team Salary`)

#converting columns to numeric
player_contracts$`% of Team Salary` <- as.numeric(sub("%", "", 
                                                      player_contracts$`% of Team Salary`)) /100
player_contracts$AAV <- as.numeric(player_contracts$AAV)

#checking data types of columns
sapply(player_contracts, class)

