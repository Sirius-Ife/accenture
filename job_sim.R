# Load required libraries
library(dplyr)      # For data manipulation
library(magrittr)   # For the pipe operator
library(tidyverse)  # For data manipulation and visualization

# Filter out rows with missing User ID in Reactions dataset
Reactions <- Reactions %>% filter(!is.na(`User ID`))

# Remove the 'User ID' column from Reactions and Content datasets
Reactions <- Reactions %>% select(-`User ID`)
Content <- Content %>% select(-`User ID`)

# Perform left joins to merge Reactions and Content datasets with ReactionTypes dataset
joint <- Reactions %>%
  left_join(ReactionTypes, by = 'Type')

final_join <- joint %>% 
  left_join(Content, by = 'Content ID')

# Summarize the total score for each category and arrange them in descending order
top_categories <- final_join %>% 
  group_by(Category) %>% 
  summarise(total_score = sum(Score, na.rm = TRUE)) %>%
  arrange(desc(total_score))

# Write the summarized top categories data to a CSV file
write.csv(top_categories, file = "top_categories.csv", row.names = FALSE)

