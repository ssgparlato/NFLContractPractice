library(tidyverse)
library(stringr)
library(lubridate)

# Load 'right_tackle' and 'left_tackle' data frames
load("right_tackle.RData")
load("left_tackle.RData")

# Add 'Position' column to the data frames
right_tackle$Position <- "right-tackle"
left_tackle$Position <- "left-tackle"

# Combine 'right_tackle' and 'left_tackle' data frames
combined_data <- bind_rows(right_tackle, left_tackle)

# Remove '$' and ',' from 'Cap Number' and 'Cash Spent'
combined_data <- combined_data %>%
  mutate(`Cap Number` = as.numeric(str_remove_all(`Cap Number`, "[$,]")),
         `Cash Spent` = as.numeric(str_remove_all(`Cash Spent`, "[$,]")))

# Convert 'Year' to date format
combined_data <- combined_data %>%
  mutate(Year = as.Date(paste0(Year, "-01-01")))

# Calculate total cap number per position and year
total_cap <- combined_data %>%
  group_by(Year, Position) %>%
  summarise(Total_Cap = sum(`Cap Number` / 1e6))  # Divide by one million

# Create the double line graph
ggplot(total_cap, aes(x = Year, y = Total_Cap, color = Position, group = Position)) +
  geom_line(size = 1.5) +
  labs(title = "Total Cap Number Comparison: Right Tackle vs Left Tackle",
       x = "Year",
       y = "Total Cap Number (in millions)") +
  scale_color_manual(values = c("right-tackle" = "red", "left-tackle" = "blue")) +
  theme_minimal()

ggsave("total_cap_comparison.png", width = 8, height = 6, dpi = 300)
