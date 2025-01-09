# Set the working directory
setwd('C:/Users/rugwe/Downloads/ams_projects')

# Read the dataset
data <- read.csv('health_insurance.csv', na.strings = c("", "NA"))

# View the dataset structure
View(data)
str(data)

# Display descriptive statistics
summary(data)

# Remove unnecessary columns
data$ID <- NULL
data$Region_Code <- NULL

# Load required libraries
library(ggplot2)
library(gridExtra)
library(CatEncoders)
library(corrplot)
library(caret)
library(rpart)

# Exploratory Data Analysis
# Histogram for 'Lower_Age'
ggplot(data) + 
  geom_histogram(aes(x = Lower_Age, y = ..density..), color = "black", fill = "lightblue", binwidth = 40, na.rm = TRUE) + 
  geom_density(aes(x = Lower_Age), color = "blue")

# Histogram for 'Reco_Policy_Premium'
ggplot(data) + 
  geom_histogram(aes(x = Reco_Policy_Premium, y = ..density..), color = "black", fill = "lightblue", binwidth = 40, na.rm = TRUE) + 
  geom_density(aes(x = Reco_Policy_Premium), color = "blue")

# Bar chart for 'Holding_Policy_Type' vs 'Response'
ggplot(data, aes(x = Holding_Policy_Type, fill = factor(Response))) +
  geom_bar(position = "dodge", stat = "count") +
  labs(x = "Holding Policy Type", y = "Count", fill = "Response")

# Data Preprocessing
# Check for missing values
count <- sort(sapply(data, function(y) sum(is.na(y))))
print(count)

# Encode categorical variables
lab1 <- LabelEncoder.fit(data$City_Code)
data$City_Code <- transform(lab1, data$City_Code)

lab2 <- LabelEncoder.fit(data$Accomodation_Type)
data$Accomodation_Type <- transform(lab2, data$Accomodation_Type)

lab3 <- LabelEncoder.fit(data$Reco_Insurance_Type)
data$Reco_Insurance_Type <- transform(lab3, data$Reco_Insurance_Type)

lab4 <- LabelEncoder.fit(data$Is_Spouse)
data$Is_Spouse <- transform(lab4, data$Is_Spouse)

lab5 <- LabelEncoder.fit(data$Health.Indicator)
data$Health.Indicator <- transform(lab5, data$Health.Indicator)

# Impute missing values for numeric columns
data$Health.Indicator[is.na(data$Health.Indicator)] <- round(mean(data$Health.Indicator, na.rm = TRUE))
data$Holding_Policy_Duration <- as.numeric(gsub("\\+", "", data$Holding_Policy_Duration))
data$Holding_Policy_Duration[is.na(data$Holding_Policy_Duration)] <- mean(data$Holding_Policy_Duration, na.rm = TRUE)
data$Holding_Policy_Type[is.na(data$Holding_Policy_Type)] <- round(mean(data$Holding_Policy_Type, na.rm = TRUE))

# Check for missing values again
count <- sort(sapply(data, function(y) sum(is.na(y))))
print(count)

# Check for outliers using boxplots
plot_upper_age <- ggplot(data, aes(x = factor(1), y = Upper_Age, fill = factor(Response))) +
  geom_boxplot() +
  labs(x = "", y = "Upper Age", fill = "Response")

plot_lower_age <- ggplot(data, aes(x = factor(1), y = Lower_Age, fill = factor(Response))) +
  geom_boxplot() +
  labs(x = "", y = "Lower Age", fill = "Response")

plot_reco_policy_premium <- ggplot(data, aes(x = factor(1), y = Reco_Policy_Premium, fill = factor(Response))) +
  geom_boxplot() +
  labs(x = "", y = "Reco Policy Premium", fill = "Response")

grid.arrange(plot_upper_age, plot_lower_age, plot_reco_policy_premium, ncol = 2)

# Remove outliers
remove_outliers <- function(column) {
  Q1 <- quantile(column, 0.25, na.rm = TRUE)
  Q3 <- quantile(column, 0.75, na.rm = TRUE)
  IQR1 <- Q3 - Q1
  subset(column, column > (Q1 - 1.5 * IQR1) & column < (Q3 + 1.5 * IQR1))
}

data <- subset(data, 
               data$Reco_Policy_Premium > quantile(data$Reco_Policy_Premium, 0.25) & 
                 data$Reco_Policy_Premium < quantile(data$Reco_Policy_Premium, 0.75))

# Visualize correlations
corrplot(cor(data[, sapply(data, is.numeric)]), method = "circle")

# Standardize numerical columns
data[, 1:11] <- scale(data[, 1:11])
str(data)

# Split data into training and testing
set.seed(530)
indices <- sample(1:nrow(data), 0.8 * nrow(data))
train <- data[indices, ]
test <- data[-indices, ]

# Ensure consistent features between train and test sets
test <- test[, names(train)]


# Train a Decision Tree model
dtree <- rpart(Response ~ ., data = train, method = "class", control = rpart.control(cp = 0.01))
predictions_dt <- predict(dtree, test, type = "class")

# Ensure predictions and actuals are factors with the same levels
test$Response <- factor(test$Response, levels = unique(c(levels(test$Response), levels(predictions_dt))))
predictions_dt <- factor(predictions_dt, levels = levels(test$Response))

# Evaluate Decision Tree
cm <- confusionMatrix(predictions_dt, test$Response)

# Print confusion matrix
print(cm)

# Extract performance metrics
accuracy <- cm$overall["Accuracy"]
sensitivity <- cm$byClass["Sensitivity"]
specificity <- cm$byClass["Specificity"]

# Print metrics
print(accuracy)
print(sensitivity)
print(specificity)


