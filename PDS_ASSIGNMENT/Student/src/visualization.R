library(tidyverse)
library(ggplot2)
library(corrplot)

# Load processed data
df <- read_csv("../data/processed_data/preprocessed_student_performance.csv")

# Visualization 1: Distribution of average scores
ggplot(df, aes(x = average_score)) +
  geom_histogram(aes(y = ..density..), bins = 30, fill = "skyblue", color = "black") +
  geom_density(color = "red") +
  labs(title = "Distribution of Average Scores",
       x = "Average Score",
       y = "Density") +
  theme_minimal()
ggsave("../results/avg_score_distribution.png", width = 10, height = 6)

# Visualization 2: Performance category by gender
ggplot(df, aes(x = performance_category, fill = gender)) +
  geom_bar(position = "dodge") +
  labs(title = "Performance Category by Gender",
       x = "Performance Category",
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("../results/performance_by_gender.png", width = 10, height = 6)

# Visualization 3: Correlation heatmap of scores
score_cols <- c("math_score", "reading_score", "writing_score", "average_score")
cor_matrix <- cor(df[score_cols])
png("../results/score_correlation_heatmap.png", width = 800, height = 600)
corrplot(cor_matrix, method = "color", type = "upper", tl.col = "black", tl.srt = 45,
         addCoef.col = "black", number.cex = 0.7,
         title = "Correlation Heatmap of Scores")
dev.off()

# Visualization 4: Average scores by parental education level
ggplot(df, aes(x = parental_level_of_education, y = average_score)) +
  geom_boxplot() +
  labs(title = "Average Scores by Parental Education Level",
       x = "Parental Education Level",
       y = "Average Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("../results/avg_score_by_parent_education.png", width = 12, height = 6)

# Visualization 5: Average scores by test preparation course
ggplot(df, aes(x = test_preparation_course, y = average_score)) +
  geom_violin(trim = FALSE) +
  geom_boxplot(width = 0.1) +
  labs(title = "Average Scores by Test Preparation Course",
       x = "Test Preparation Course",
       y = "Average Score") +
  theme_minimal()
ggsave("../results/avg_score_by_test_prep.png", width = 10, height = 6)

print("Visualizations completed and saved in the results folder.")
