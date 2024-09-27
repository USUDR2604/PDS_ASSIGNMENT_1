# Load required libraries
library(tidyverse)
library(caret)
library(corrplot)
library(RColorBrewer)
library(pROC)

# Set a consistent theme for ggplot
theme_set(theme_minimal())

# Function to save plots
save_plot <- function(plot, filename, width = 8, height = 6) {
  ggsave(filename, plot, width = width, height = height)
  cat(paste("Saved:", filename, "\n"))
}

# Load and preprocess data
load_and_preprocess_data <- function() {
  df <- read_csv("../data/cleaned_data/grip_strength_data.csv")
  X <- df %>% select(-Frailty)
  y <- df$Frailty
  
  preprocess_params <- preProcess(X, method = c("center", "scale"))
  X_scaled <- predict(preprocess_params, X)
  
  processed_df <- bind_cols(X_scaled, Frailty = y)
  write_csv(processed_df, "../data/processed_data/grip_strength_data.csv")
  cat("Processed data saved successfully.\n")
  
  return(processed_df)
}

# Perform EDA
perform_eda <- function(processed_df) {
  sink("../results/results.txt")
  
  cat("Summary statistics of processed data:\n")
  print(summary(processed_df))
  
  correlation <- cor(processed_df$Grip_strength, processed_df$Frailty)
  cat("\nCorrelation between Grip_strength and Frailty:", round(correlation, 2), "\n")
  
  mean_grip_frail <- mean(processed_df$Grip_strength[processed_df$Frailty == 1])
  mean_grip_non_frail <- mean(processed_df$Grip_strength[processed_df$Frailty == 0])
  cat("\nMean grip strength for frail participants:", round(mean_grip_frail, 2), "kg\n")
  cat("Mean grip strength for non-frail participants:", round(mean_grip_non_frail, 2), "kg\n")
  
  t_test_result <- t.test(Grip_strength ~ Frailty, data = processed_df)
  cat("\nt-test results comparing grip strength between frail and non-frail groups:\n")
  print(t_test_result)
  
  sink()
  cat("EDA results have been written to results.txt\n")
}

# Train and evaluate model
train_and_evaluate_model <- function(processed_df) {
  set.seed(42)
  train_index <- createDataPartition(processed_df$Frailty, p = 0.8, list = FALSE)
  train_data <- processed_df[train_index, ]
  test_data <- processed_df[-train_index, ]
  
  model <- glm(Frailty ~ Grip_strength + Age, data = train_data, family = "binomial")
  y_pred <- predict(model, newdata = test_data, type = "response")
  y_pred_class <- ifelse(y_pred > 0.5, 1, 0)
  
  accuracy <- mean(y_pred_class == test_data$Frailty)
  conf_matrix <- confusionMatrix(factor(y_pred_class), factor(test_data$Frailty))
  class_report <- conf_matrix$byClass
  
  sink("../results/results.txt", append = TRUE)
  cat("\nModel Evaluation Results:\n")
  cat(paste("Accuracy:", round(accuracy, 2), "\n"))
  cat("\nConfusion Matrix:\n")
  print(conf_matrix$table)
  cat("\nClassification Report:\n")
  print(class_report)
  sink()
  
  cat("Model evaluation results have been appended to results.txt\n")
  
  return(list(y_pred = y_pred, test_data = test_data, conf_matrix = conf_matrix))
}

# Create visualizations
create_visualizations <- function(processed_df, model_results) {
  # Correlation Heatmap
  correlation_matrix <- cor(processed_df)
  png("../results/correlation_heatmap.png", width = 800, height = 600)
  corrplot(correlation_matrix, method = "color", type = "upper", order = "hclust", 
           addCoef.col = "black", number.cex = 0.7,
           col = colorRampPalette(c("#67001F", "#B2182B", "#D6604D", "#F4A582", 
                                    "#FDDBC7", "#F7F7F7", "#D1E5F0", "#92C5DE", 
                                    "#4393C3", "#2166AC", "#053061"))(200),
           title = "Correlation Heatmap (including Frailty)", mar = c(0,0,1,0))
  dev.off()
  cat("Saved: ../results/correlation_heatmap.png\n")
  
  # Scatter plot
  p1 <- ggplot(processed_df, aes(x = Age, y = Grip_strength, color = factor(Frailty))) +
    geom_point() +
    scale_color_manual(values = c("#67001F", "#053061"), 
                       labels = c("Non-frail", "Frail"),
                       name = "Frailty") +
    labs(title = "Grip Strength vs Age (Colored by Frailty)",
         x = "Age", y = "Grip Strength")
  save_plot(p1, "../results/grip_vs_age_frailty.png")
  
  # Box plot
  p2 <- ggplot(processed_df, aes(x = factor(Frailty), y = Grip_strength, fill = factor(Frailty))) +
    geom_boxplot() +
    scale_fill_manual(values = c("#67001F", "#053061"),
                      labels = c("Non-frail", "Frail"),
                      name = "Frailty") +
    labs(title = "Boxplot of Grip Strength by Frailty",
         x = "Frailty", y = "Grip Strength")
  save_plot(p2, "../results/grip_strength_frailty_boxplot.png")
  
  # Confusion Matrix
  conf_matrix_plot <- as.data.frame(model_results$conf_matrix$table)
  names(conf_matrix_plot) <- c("Actual", "Predicted", "Freq")
  p3 <- ggplot(conf_matrix_plot, aes(x = Predicted, y = Actual, fill = Freq)) +
    geom_tile() +
    geom_text(aes(label = Freq), color = "white", size = 8) +
    scale_fill_gradient(low = "#67001F", high = "#053061") +
    labs(title = "Confusion Matrix",
         x = "Predicted",
         y = "Actual") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  save_plot(p3, "../results/confusion_matrix.png", width = 6, height = 4)
  
  # ROC Curve
  roc_obj <- roc(model_results$test_data$Frailty, model_results$y_pred)
  auc_value <- auc(roc_obj)
  png("../results/roc_curve.png", width = 600, height = 500)
  plot(roc_obj, main = paste("ROC Curve (AUC =", round(auc_value, 2), ")"))
  dev.off()
  cat("Saved: ../results/roc_curve.png\n")
}

# Main execution
main <- function() {
  processed_df <- load_and_preprocess_data()
  perform_eda(processed_df)
  model_results <- train_and_evaluate_model(processed_df)
  create_visualizations(processed_df, model_results)
  cat("Analysis complete. All results and visualizations have been saved.\n")
}

# Run the analysis
main()