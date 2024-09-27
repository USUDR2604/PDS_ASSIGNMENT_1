# Grip Strength and Frailty Analysis

## Project Overview

This project analyzes the relationship between grip strength and frailty in female participants. It processes raw data, performs statistical analyses, and creates visualizations to explore the connections between various factors such as age, grip strength, and frailty status.

## Data Description

The dataset contains information on 10 female participants, including:
- Height (inches)
- Weight (pounds)
- Age (years)
- Grip strength (kilograms)
- Frailty (binary: Y/N)

## Project Structure

Fratility/
├── data/
│ ├── raw/grip_strength_data.csv
│ ├── cleaned_data/grip_strength_data.csv
│ └── processed_data/grip_strength_data.csv
├── src/
│ └── data_cleaning.R
│ └── data_collection.R
│ └── data_preprocessing.R
├── results/
│ ├── results.txt
│ ├── correlation_heatmap.png
│ ├── grip_vs_age_frailty.png
│ └── grip_strength_frailty_boxplot.png
└── README.md


## Analysis Workflow

## Analysis Workflow

The `data_preprocessing.R` script performs the following steps:

1. **Data Loading and Preprocessing**: 
   - Loads the cleaned data
   - Standardizes the features
   - Saves the processed data

2. **Exploratory Data Analysis (EDA)**:
   - Generates summary statistics
   - Calculates correlations
   - Performs t-tests

3. **Model Training and Evaluation**:
   - Splits data into training and testing sets
   - Trains a logistic regression model
   - Evaluates the model's performance

4. **Visualization Creation**:
   - Correlation heatmap
   - Scatter plot of grip strength vs. age
   - Box plot of grip strength by frailty status
   - Confusion matrix
   - ROC curve

## How to Run the Analysis

1. Ensure you have R installed on your system.
2. Install required packages:
   ```R
   install.packages(c("tidyverse", "caret", "corrplot", "RColorBrewer", "pROC"))
    Cmd: Rscript data_preprocessing.R

The analysis produces several outputs:
Processed data file: data/processed_data/grip_strength_data.csv
Results summary: results/results.txt
Contains summary statistics, correlation analysis, t-test results, and model evaluation metrics

## Visualizations:
Correlation heatmap: results/correlation_heatmap.png
Grip strength vs. age scatter plot: results/grip_vs_age_frailty.png
Grip strength by frailty box plot: results/grip_strength_frailty_boxplot.png
Confusion matrix: results/confusion_matrix.png
ROC curve: 'results/roc_curve.png'