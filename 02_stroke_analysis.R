# ==============================================================================
# STROKE RISK FACTOR ANALYSIS & BIOSTATISTICS PIPELINE
# File: 02_stroke_analysis.R
# Project: public-health-inference
# ==============================================================================

# 1. Load Pustaka Utama
library(tidyverse)
library(gtsummary)
library(broom)

# 2. Impor Data & Data Cleaning
data_stroke <- read_csv("healthcare-dataset-stroke-data.csv") %>%
  filter(gender != "Other") %>%                # Hapus entri pencilan gender
  mutate(
    stroke = factor(stroke, levels = c(0, 1), labels = c("Tidak Stroke", "Stroke")),
    hypertension = factor(hypertension, levels = c(0, 1), labels = c("Tidak", "Ya")),
    heart_disease = factor(heart_disease, levels = c(0, 1), labels = c("Tidak", "Ya")),
    smoking_status = factor(smoking_status),
    bmi = as.numeric(bmi)                       # Konversi variabel BMI ke bentuk numerik
  )

# 3. Rancang "Table 1" (Karakteristik Pasien Berdasarkan Status Stroke)
tabel_karakteristik <- data_stroke %>%
  select(age, gender, hypertension, heart_disease, avg_glucose_level, bmi, smoking_status, stroke) %>%
  tbl_summary(
    by = stroke,
    label = list(
      age ~ "Usia (Tahun)",
      gender ~ "Jenis Kelamin",
      hypertension ~ "Riwayat Hipertensi",
      heart_disease ~ "Riwayat Penyakit Jantung",
      avg_glucose_level ~ "Rata-Rata Glukosa Darah",
      bmi ~ "Indeks Massa Tubuh (BMI)",
      smoking_status ~ "Status Merokok"
    ),
    missing = "no"                              # Sembunyikan baris data missing pada visual tabel
  ) %>%
  add_overall(last = FALSE) %>%                 # Tambah kolom Total Populasi
  add_p() %>%                                   # Uji statistik otomatis (Chi-Square/t-test)
  bold_labels()

# Tampilkan Table 1 di Viewer Panel
tabel_karakteristik

# 4. Pemodelan Regresi Logistik Multivariat (Odds Ratio)
model_stroke <- glm(
  stroke ~ age + hypertension + heart_disease + avg_glucose_level + bmi,
  data = data_stroke,
  family = binomial
)

# Format Hasil Regresi Menjadi Tabel Odds Ratio (OR) + 95% CI
tabel_or <- tbl_regression(
  model_stroke,
  exponentiate = TRUE,                          # Konversi nilai log-odds ke Odds Ratio (OR)
  label = list(
    age ~ "Usia",
    hypertension ~ "Hipertensi",
    heart_disease ~ "Penyakit Jantung",
    avg_glucose_level ~ "Kadar Glukosa",
    bmi ~ "BMI"
  )
) %>%
  bold_p(t = 0.05)                              # Cetak tebal p-value signifikan (< 0.05)

# Tampilkan Tabel Odds Ratio di Viewer Panel
tabel_or

# 5. Visualisasi Forest Plot (Odds Ratio & 95% Confidence Interval)
data_forest <- tidy(model_stroke, exponentiate = TRUE, conf.int = TRUE) %>%
  filter(term != "(Intercept)") %>%
  mutate(
    term = case_when(
      term == "age" ~ "Usia",
      term == "hypertensionYa" ~ "Hipertensi (Ya)",
      term == "heart_diseaseYa" ~ "Penyakit Jantung (Ya)",
      term == "avg_glucose_level" ~ "Kadar Glukosa",
      term == "bmi" ~ "BMI",
      TRUE ~ term
    )
  )

plot_forest_stroke <- ggplot(data_forest, aes(x = estimate, y = reorder(term, estimate))) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "#e41a1c", linewidth = 0.8) +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0.2, color = "#2b8cbe", linewidth = 1) +
  geom_point(size = 3.5, color = "#084594") +
  labs(
    title = "Forest Plot: Adjusted Odds Ratio (AOR) Risiko Stroke",
    subtitle = "Dataset Stroke Kaggle (Garis Merah Putus-putus = Netral / OR = 1.0)",
    x = "Adjusted Odds Ratio (OR) & 95% CI",
    y = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    panel.grid.minor = element_blank()
  )

# Tampilkan Forest Plot di Tab Plots
print(plot_forest_stroke)