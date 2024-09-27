# Load required libraries
library(tidyverse)

# Load the raw data
df <- read_csv("../data/raw/grip_strength_data.csv")

# Check for missing values
print("Missing values:")
print(colSums(is.na(df)))

# Check for duplicates
print("Duplicate rows:")
print(sum(duplicated(df)))

# Convert 'Frailty' to binary (0 for 'N', 1 for 'Y')
df <- df %>%
  mutate(Frailty = ifelse(Frailty == 'N', 0, 1))

# Save the cleaned data
write_csv(df, "../data/cleaned_data/grip_strength_data.csv")

print("Cleaned data saved successfully.")