library(tidyverse)
library(stringr)
library(lubridate)

# Load 'wide_receiver' and 'running_back' data frames
load("wide_receiver.RData")
load("running_back.RData")

# Add 'Position' column to the data frames
wide_receiver$Position <- "Wide Receiver"
running_back$Position <- "Running Back"

# Combine the data frames
combined_data <- bind_rows(wide_receiver, running_back)

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
  labs(title = "Total Cap Number Comparison: Wide Receiver vs Running Back",
       x = "Year",
       y = "Total Cap Number (in millions)") +
  scale_color_manual(values = c("Wide Receiver" = "red", "Running Back" = "blue")) +
  theme_minimal()

ggsave("total_cap_comparison.png", width = 8, height = 6, dpi = 300)
