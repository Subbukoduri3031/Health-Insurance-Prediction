Health Insurance Prediction Project
This project uses R to predict customer interest in health insurance plans based on demographic, policy, and recommendation data. It involves data preprocessing, exploratory data analysis (EDA), and building a decision tree classifier.

Project Overview
This project predicts whether a customer is likely to respond positively to a recommended health insurance plan using a decision tree model. The dataset includes demographic details, policy information, and customer-specific features. The project focuses on:

Data Cleaning and Preprocessing
Exploratory Data Visualization
Decision Tree Model Implementation
Evaluation using Accuracy, Sensitivity, and Specificity
Dataset
The dataset is sourced from Kaggle.
Key Features:

Demographics: City code, region code, age ranges, and accommodation type.
Policy Information: Holding policy type and duration, recommended policy category, and premium.
Customer Details: Spousal status and health condition indicators.
Target Variable: Response (1 for Interested, 0 for Not Interested).
Technologies Used
Programming Language: R
Key Libraries:
ggplot2, gridExtra: For data visualization
caret, rpart: For modeling and evaluation
CatEncoders: For encoding categorical variables
Code Overview
1. Data Preprocessing
Removed unnecessary columns such as ID and Region_Code.
Encoded categorical variables using LabelEncoder.
Handled missing values using mean imputation.
2. Exploratory Data Analysis
Visualized distributions of age, recommended policy premium, and other features.
Analyzed the relationship between features and the target variable (Response).
3. Decision Tree Modeling
Built a decision tree classifier using the rpart library.
Split data into an 80-20 training-testing ratio.
Evaluated performance using a confusion matrix.
Results
Accuracy: ~77%
Sensitivity: 100% (All interested customers identified)
Specificity: 0% (Non-interested customers misclassified)
How to Run
Clone this repository:
bash
Copy code
git clone https://github.com/your-username/Health-Insurance-Prediction.git
cd Health-Insurance-Prediction
Open the R script HealthInsurancePrediction_Model.R in RStudio.
Install required R libraries:
R
Copy code
install.packages(c("ggplot2", "gridExtra", "CatEncoders", "caret", "rpart"))
Run the script step by step to reproduce the results.
Future Work
Address class imbalance in the target variable using techniques like SMOTE.
Experiment with other models like Random Forest or XGBoost for improved performance.
Explore feature selection methods to optimize model efficiency.
License
This project is licensed under the MIT License. See the LICENSE file for more details.
