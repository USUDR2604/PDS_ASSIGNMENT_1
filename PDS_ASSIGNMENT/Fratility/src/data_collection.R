# Load required libraries
library(tidyverse)

# Create the dataset
data <- tibble(
  Height = c(65.8, 71.5, 69.4, 68.2, 67.8, 68.7, 69.8, 70.1, 67.9, 66.8),
  Weight = c(112, 136, 153, 142, 144, 123, 141, 136, 112, 120),
  Age = c(30, 19, 45, 22, 29, 50, 51, 23, 17, 39),
  Grip_strength = c(30, 31, 29, 28, 24, 26, 22, 20, 19, 31),
  Frailty = c('N', 'N', 'N', 'Y', 'Y', 'N', 'Y', 'Y', 'N', 'N')
)

# Save the raw data to a CSV file
write_csv(data, "../data/raw/grip_strength_data.csv")

print("Raw data saved successfully.")
