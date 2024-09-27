# src/data_cleaned.R

library(tidyverse)
library(janitor)

# Define file paths
raw_data_path <- file.path("..", "data", "raw_data", "StudentsPerformance.csv")
cleaned_data_path <- file.path("..", "data", "cleaned_data", "cleaned_student_performance.csv")

# Check if the raw data file exists
if (!file.exists(raw_data_path)) {
  stop("Raw data file not found. Please ensure 'StudentPerformance.csv' is in the 'data/raw_data/' directory.")
}

# Read the CSV file
df <- read_csv(raw_data_path)

# Clean column names
df <- df %>% 
  clean_names()

# Check for missing values
missing_values <- df %>% 
  summarise_all(~sum(is.na(.)))

print("Missing values in each column:")
print(missing_values)

# Remove rows with missing values (if any)
df <- df %>% 
  drop_na()

# Convert categorical variables to factors
categorical_vars <- c("gender", "race_ethnicity", "parental_level_of_education", 
                      "lunch", "test_preparation_course")

df <- df %>%
  mutate(across(all_of(categorical_vars), as.factor))

# Create average score column
df <- df %>%
  mutate(average_score = (math_score + reading_score + writing_score) / 3)

# Create performance category
df <- df %>%
  mutate(performance_category = cut(average_score,
                                    breaks = c(0, 40, 60, 75, 100),
                                    labels = c("Poor", "Average", "Good", "Excellent")))

# Check data types
print("Data types of each column:")
print(sapply(df, class))

# Summary statistics
summary_stats <- df %>%
  summary()

print("Summary statistics:")
print(summary_stats)

# Create the processed_data directory if it doesn't exist
dir.create(dirname(cleaned_data_path), showWarnings = FALSE, recursive = TRUE)

# Save the cleaned data
write_csv(df, cleaned_data_path)

print(paste("Cleaned data saved to:", cleaned_data_path))
