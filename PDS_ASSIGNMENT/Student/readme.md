# Student Performance Analysis

This project analyzes student performance data, including preprocessing steps and visualizations to gain insights into factors affecting academic achievement.

## Project Structure
student_performance_analysis/
├── data/
│ ├── raw_data/
│ │ └── StudentPerformance.csv
│ ├── cleaned_data/
│ │ └── cleaned_student_performance.csv
│ └── processed_data/
│ └── preprocessed_student_performance.csv
├── src/
│ ├── data_cleaned.R
│ └── data_preprocessing.R
├── results/
│ ├── avg_score_distribution.png
│ ├── performance_by_gender.png
│ ├── score_correlation_heatmap.png
│ ├── avg_score_by_parent_education.png
│ └── avg_score_by_test_prep.png
└── README.md


## Data Processing Steps

1. **Data Cleaning** (`data_cleaned.R`):
   - Loads raw data from `StudentPerformance.csv`
   - Cleans column names
   - Handles missing values
   - Creates derived variables (e.g., average score, performance category)
   - Saves cleaned data to `cleaned_student_performance.csv`

2. **Data Preprocessing** (`data_preprocessing.R`):
   - Loads cleaned data
   - Performs feature engineering (e.g., creating binary 'passed' column, interaction terms)
   - Encodes categorical variables
   - Scales numerical features
   - Performs feature selection
   - Adds unique identifier
   - Saves preprocessed data to `preprocessed_student_performance.csv`

## Visualizations

The `data_preprocessing.R` script also generates the following visualizations:

1. Distribution of Average Scores
2. Performance Category by Gender
3. Correlation Heatmap of Scores
4. Average Scores by Parental Education Level
5. Average Scores by Test Preparation Course

These visualizations are saved in the `results/` directory.

## How to Run

1. Ensure you have R installed on your system.
2. Install required packages:
   ```R
   install.packages(c("tidyverse", "caret", "corrplot"))

Cmd: Rscript src/data_cleaned.R
Cmd: Rscript src/data_preprocessing.R

## Results
1. After running the scripts, you'll find:
2. Cleaned data in data/cleaned_data/cleaned_student_performance.csv
3. Preprocessed data in data/processed_data/preprocessed_student_performance.csv
4. Visualizations in the results/ directory