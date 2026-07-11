# 🚢 Titanic Survival Analysis with Python
---

# 📖 Project Overview

This project presents an end-to-end **Python Data Analysis** solution based on the famous **Titanic dataset**.

The project combines data analysis, statistical calculations, data validation, and Python programming to simulate a real-world passenger boarding process while estimating the passenger's probability of survival.

Using historical Titanic passenger data, the program analyzes survival patterns and predicts the survival probability of a new passenger according to demographic and ticket information.

The project demonstrates practical skills in data analysis, data preprocessing, statistical reasoning, and Python application development.

---

# 🎯 Project Objectives

The main objective of this project is to analyze historical Titanic passenger data and use the findings to estimate the survival probability of a newly registered passenger.

The project demonstrates how Python can be used to:

- Analyze historical datasets.
- Clean and preprocess data.
- Validate user input.
- Apply statistical analysis.
- Generate analytical predictions.
- Create an interactive Python application.

---

# 🚢 Business Scenario

The Titanic disaster is one of the most well-known historical datasets used in data science and machine learning.

Passenger survival depended on several factors such as:

- Age
- Gender
- Passenger Class
- Ticket Fare

This project analyzes these factors and estimates the survival probability for a new passenger based on patterns found in the original dataset.

---

# 📂 Dataset

The analysis is based on the Titanic passenger dataset.

The dataset includes passenger information such as:

- Passenger Name
- Age
- Gender
- Passenger Class
- Ticket Fare
- Ticket Number
- Survival Status

The dataset is processed using **Pandas DataFrames** for analysis and calculations.

---

# ⚙ Application Workflow

The application simulates the boarding process of a new Titanic passenger.

The workflow consists of seven main stages:

### 1️⃣ Passenger Name Validation

- Required field
- Letters only
- Prevents empty or invalid names

---

### 2️⃣ Passenger Age Validation

- Numeric values only
- Valid age range
- Input validation

---

### 3️⃣ Gender Validation

Supports multiple user inputs:

- M / F
- Male / Female
- male / female
- 1 / 0

All values are standardized into one format.

---

### 4️⃣ Passenger Class Determination

The passenger class is calculated according to the ticket fare.

The algorithm analyzes historical fare distributions using quartiles and median values in order to assign the passenger to the most appropriate travel class.

---

### 5️⃣ Ticket Generation

The application generates a unique six-digit ticket number.

Before assigning the ticket, the program verifies that the number does not already exist in either the historical dataset or the tickets generated during the current execution.

---

### 6️⃣ Boarding Ticket Creation

A boarding ticket is automatically generated as a TXT file containing:

- Ticket Number
- Passenger Name
- Age
- Gender
- Ticket Fare
- Passenger Class
- Estimated Survival Probability

---

### 7️⃣ Survival Probability Estimation

The project estimates survival probability based on historical Titanic data.

The calculation considers three major factors:

- Passenger Gender
- Passenger Class
- Passenger Age Category

Missing age values in the dataset are handled by replacing them with the average age of passengers with the same gender.

Passengers are grouped into age categories:

- Infant
- Child
- Teenager
- Young Adult
- Middle Aged
- Senior

Each factor receives a predefined weight, and the final survival probability is calculated using a weighted average approach.

---

# 📊 Data Analysis Techniques

The project includes:

- Data Cleaning
- Missing Value Handling
- Feature Engineering
- GroupBy Analysis
- Statistical Aggregation
- Quartile Analysis
- Median Calculation
- Weighted Scoring
- Probability Estimation
- Data Validation

---

# 📈 Key Features

- Interactive user input
- Data validation
- Automatic passenger classification
- Unique ticket generation
- Survival probability prediction
- TXT ticket creation
- Statistical analysis based on historical data

---

# 💻 Technologies

- Python
- Pandas
- NumPy
- Random
- OS
- Text File Handling

---

# 💼 Skills Demonstrated

This project demonstrates practical experience in:

- Python Programming
- Data Analysis
- Data Cleaning
- Data Validation
- Statistical Analysis
- Feature Engineering
- Probability Analysis
- Predictive Logic
- File Handling
- User Input Validation
- Algorithm Design
- Business Logic Implementation

---

# 🚀 Learning Outcomes

Through this project I strengthened my ability to:

- Analyze real-world datasets using Python.
- Build interactive Python applications.
- Apply statistical reasoning to solve analytical problems.
- Clean and preprocess data for analysis.
- Develop reusable functions.
- Combine data analysis with software development principles.

---

# 👩‍💻 Author

**Anat Shmueli**

**Data Analyst**

📧 anatshmoueli@gmail.com

---

⭐ Thank you for visiting this project.
