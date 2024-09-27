# src/data_preprocessing.R

library(tidyverse)
library(caret)
library(corrplot)

# Define file paths
cleaned_data_path <- file.path("..", "data", "cleaned_data", "cleaned_student_performance.csv")
preprocessed_data_path <- file.path("..", "data", "processed_data", "preprocessed_student_performance.csv")
visualization_path <- file.path("..", "results")

# Check if the cleaned data file exists
if (!file.exists(cleaned_data_path)) {
  stop("Cleaned data file not found. Please ensure the cleaned_student_performance.csv file is in the data/cleaned_data/ directory.")
}

# Read the cleaned CSV file
df <- read_csv(cleaned_data_path)

# 1. Feature Engineering

# Create a binary column for passing (average score >= 60)
df <- df %>%
  mutate(passed = ifelse(average_score >= 60, 1, 0))

# Create interaction terms
df <- df %>%
  mutate(
    prep_parent_edu = interaction(test_preparation_course, parental_level_of_education),
    prep_lunch = interaction(test_preparation_course, lunch)
  )

# 2. Encoding categorical variables
# One-hot encoding for multi-level categorical variables
df_encoded <- df %>%
  mutate(across(where(is.factor), as.character)) %>%
  mutate(across(where(is.character), factor))

dummy <- dummyVars(" ~ .", data = df_encoded)
df_encoded <- predict(dummy, newdata = df_encoded)
df_encoded <- as.data.frame(df_encoded)

# 3. Scaling numerical features
numeric_features <- c("math_score", "reading_score", "writing_score", "average_score")
preprocessParams <- preProcess(df_encoded[, numeric_features], method = c("center", "scale"))
df_encoded[, numeric_features] <- predict(preprocessParams, df_encoded[, numeric_features])

# 4. Feature selection (example: removing highly correlated features)
correlation_matrix <- cor(df_encoded)
highly_correlated <- findCorrelation(correlation_matrix, cutoff = 0.9)
df_encoded <- df_encoded[, -highly_correlated]

# 5. Add a unique identifier
df_encoded <- df_encoded %>%
  mutate(student_id = row_number())

# 6. Reorder columns (student_id first)
df_encoded <- df_encoded %>%
  select(student_id, everything())

# Create the processed_data directory if it doesn't exist
dir.create(dirname(preprocessed_data_path), showWarnings = FALSE, recursive = TRUE)

# Save the preprocessed data
write_csv(df_encoded, preprocessed_data_path)

print(paste("Preprocessed data saved to:", preprocessed_data_path))

# Print summary of preprocessed data
print("Summary of preprocessed data:")
print(summary(df_encoded))

# Print dimensions of preprocessed data
print(paste("Dimensions of preprocessed data:", nrow(df_encoded), "rows and", ncol(df_encoded), "columns"))

# Visualizations
dir.create(visualization_path, showWarnings = FALSE, recursive = TRUE)

# 1. Distribution of average scores
ggplot(df, aes(x = average_score)) +
  geom_histogram(aes(y = after_stat(density)), bins = 30, fill = "skyblue", color = "black") +
  geom_density(color = "red") +
  labs(title = "Distribution of Average Scores", x = "Average Score", y = "Density") +
  theme_minimal()
ggsave(file.path(visualization_path, "avg_score_distribution.png"), width = 10, height = 6)

# 2. Performance category by gender
ggplot(df, aes(x = performance_category, fill = gender)) +
  geom_bar(position = "dodge") +
  labs(title = "Performance Category by Gender", x = "Performance Category", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(file.path(visualization_path, "performance_by_gender.png"), width = 10, height = 6)

# 3. Correlation heatmap of scores
score_cols <- c("math_score", "reading_score", "writing_score", "average_score")
cor_matrix <- cor(df[score_cols])
png(file.path(visualization_path, "score_correlation_heatmap.png"), width = 800, height = 600)
corrplot(cor_matrix, method = "color", type = "upper", tl.col = "black", tl.srt = 45,
         addCoef.col = "black", number.cex = 0.7,
         title = "Correlation Heatmap of Scores")
dev.off()

# 4. Average scores by parental education level
ggplot(df, aes(x = parental_level_of_education, y = average_score)) +
  geom_boxplot() +
  labs(title = "Average Scores by Parental Education Level", x = "Parental Education Level", y = "Average Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(file.path(visualization_path, "avg_score_by_parent_education.png"), width = 12, height = 6)

# 5. Average scores by test preparation course
ggplot(df, aes(x = test_preparation_course, y = average_score)) +
  geom_violin(trim = FALSE) +
  geom_boxplot(width = 0.1) +
  labs(title = "Average Scores by Test Preparation Course", x = "Test Preparation Course", y = "Average Score") +
  theme_minimal()
ggsave(file.path(visualization_path, "avg_score_by_test_prep.png"), width = 10, height = 6)

print("Visualizations completed and saved in the results folder.")
