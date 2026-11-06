# 🏥 Public Health & Biostatistics Analytics Pipeline

An end-to-end biostatistical analysis and health risk predictive modeling pipeline written in R. This project demonstrates epidemiological surveillance, multivariate logistic regression, clinical risk profiling, and ROC evaluation.

---

## 📌 Executive Summary & Key Results
- **Stroke Risk Prediction Model**: Achieved an **AUC of 0.925** using multivariate logistic regression on clinical and demographic predictors (Age, Hypertension, Heart Disease, Glucose Level, BMI).
- **Heart Disease Clinical EDA**: Discovered a statistically significant lower median Maximum Heart Rate (`MaxHR`) among heart disease patients (~130 bpm vs ~150 bpm in healthy subjects).
- **Epidemiological Surveillance**: Constructed standardized Epidemic Curves (Epi Curves) for disease outbreak monitoring.

---

## 📁 Repository Structure
```text
public-health-inference/
│
├── 01_epidemiology_plots.R   # Surveillance Epi Curve & Baseline Forest Plot
├── 02_stroke_analysis.R      # Data Cleaning, Table 1 (gtsummary), & Logistic Regression
├── 03_model_evaluation.R     # Model Discrimination & ROC-AUC Analysis (pROC)
├── 04_heart_analysis.R       # Heart Disease Clinical EDA & MaxHR Boxplot
│
├── healthcare-dataset-stroke-data.csv
└── heart.csv