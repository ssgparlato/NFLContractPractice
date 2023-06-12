library(tidyverse)
library(nflfastR)
library(ggimage)
library(gt)
library(ggthemes)
library(stringr)
library(lubridate)
library(ggplot2)
library(nflverse)
library(ggrepel)

# Pulling play-by-play data
pbp22 <- load_pbp(2022)

# get QB EPA/play, create a pass rate column and join teams_colors_logos
qb_epa_play22 <- pbp22 |> 
  filter(pass == 1 | rush == 1, !is.na(epa)) |> 
  group_by(id) |> 
  summarize(name = first(name),
            team = last(posteam),
            plays = n(),
            epa_play = mean(epa),
            pass_attempts = sum(incomplete_pass + complete_pass, na.rm = T)) |> 
  filter(plays >= 100, pass_attempts >= 30)

# Load 'quarterback' data frame
load("quarterback.RData")

# Grab QB Contract data from 2022
qb_contracts22 <- quarterback |> 
  filter(Year == 2022)

# Convert 'Player' column to initial and last name format
qb_contracts22 <- qb_contracts22 %>%
  mutate(abbrev_name = str_extract(Player, "\\b\\w") %>% 
           paste0(".", str_extract(Player, "\\b\\w+$")))

# Combine QB Contract and EPA data
qb_combined_data <- inner_join(qb_contracts22, qb_epa_play22, 
                               by = c("abbrev_name" = "name"))

# Converting Cap and Cash columns to numerics
qb_combined_data$`Cap Number`<- as.numeric(gsub("[$,]", "",
                                                qb_combined_data$`Cap Number`))
qb_combined_data$`Cash Spent`<- as.numeric(gsub("[$,]", "", 
                                                qb_combined_data$`Cash Spent`))

# Team Colors
qb_combined_data <- qb_combined_data |> 
  left_join(load_teams(), by = c('team' = 'team_abbr'))

# Create linear regression model
model <- lm(`Cap Number` / 1e6 ~ epa_play, data = qb_combined_data)

# Plot the linear regression model
ggplot(qb_combined_data, aes(x = epa_play, y = `Cap Number` / 1e6)) +
  geom_point(color = qb_combined_data$team_color) +
  geom_text_repel(aes(label=abbrev_name)) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, color = "blue") +
  labs(title = "Linear Regression: QB EPA/Play vs Cap Number in 2022",
       x = "EPA Play",
       y = "Cap Number (in millions)") +
  theme_minimal()

