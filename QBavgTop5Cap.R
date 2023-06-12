# Load required libraries
library(ggplot2)
library(dplyr)

# Load 'quarterback' data frame
load("quarterback.RData")

# Convert 'Cap Number' and 'Cash Spent' columns to numeric
quarterback$`Cap Number` <- as.numeric(gsub("[$,]", "", quarterback$`Cap Number`))
quarterback$`Cash Spent` <- as.numeric(gsub("[$,]", "", quarterback$`Cash Spent`))

# Convert 'Year' column to date format
quarterback$Year <- as.Date(paste0(quarterback$Year, "-01-01"))

# Filter out Aaron Rodgers' data from 2024
quarterback_filtered <- quarterback %>%
  filter(!(Player == "Aaron Rodgers" & Year == as.Date("2024-01-01")))

# Group by Year and calculate the average of the top 5 'Cap Number' values
average_top5_cap <- quarterback_filtered %>%
  group_by(Year) %>%
  top_n(5, `Cap Number`) %>%
  summarise(Average_Cap = mean(`Cap Number` / 1e6))  # Divide by one million

# Create the line graph with a line of best fit
ggplot(average_top5_cap, aes(x = Year, y = Average_Cap)) +
  geom_line() +
  geom_smooth(method = "lm", se = FALSE) +  # Add a line of best fit
  labs(title = "Average of Top 5 Cap Numbers - Quarterbacks",
       x = "Year",
       y = "Average Cap Number (in millions)") +
  theme_minimal()
