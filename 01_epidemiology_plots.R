# ==============================================================================
# PUBLIC HEALTH INFERENCE & EPIDEMIOLOGICAL VISUALIZATION PIPELINE
# ==============================================================================

library(tidyverse)

# ------------------------------------------------------------------------------
# 1. EPIDEMIC CURVE (Kurva Surveillance Wabah DBD)
# ------------------------------------------------------------------------------
set.seed(2026)
data_surveillance <- tibble(
  tanggal = seq.Date(from = as.Date("2026-01-01"), to = as.Date("2026-03-31"), by = "day"),
  kasus = rpois(90, lambda = c(rep(6, 25), rep(40, 35), rep(12, 30))) # Puncak tren wabah
)

plot_epi_curve <- ggplot(data_surveillance, aes(x = tanggal, y = kasus)) +
  geom_col(fill = "#2b8cbe", color = "white", width = 1) +
  geom_smooth(method = "loess", color = "#e31a1c", se = FALSE, linewidth = 1.2) +
  labs(
    title = "Epidemic Curve: Surveillance Harian DBD",
    subtitle = "Trend Lonjakan Kasus Demam Berdarah (Januari - Maret 2026)",
    x = "Tanggal Pelaporan",
    y = "Jumlah Kasus Konfirmasi"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    panel.grid.minor = element_blank()
  )

# Tampilkan Epi Curve
print(plot_epi_curve)


# ------------------------------------------------------------------------------
# 2. FOREST PLOT (Visualisasi Risiko Odds Ratio & 95% CI)
# ------------------------------------------------------------------------------
data_forest <- tibble(
  variabel = factor(c("Aktivitas Fisik Kurang", "Status Merokok (Ya)", "Usia >= 45 Tahun"), 
                    levels = c("Aktivitas Fisik Kurang", "Status Merokok (Ya)", "Usia >= 45 Tahun")),
  OR = c(1.85, 2.15, 1.40),
  lower = c(1.12, 1.35, 0.88),
  upper = c(3.05, 3.42, 2.22)
)

plot_forest <- ggplot(data_forest, aes(x = OR, y = variabel)) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "red", linewidth = 0.8) +
  geom_errorbarh(aes(xmin = lower, xmax = upper), height = 0.2, color = "#2c7fb8", linewidth = 1) +
  geom_point(size = 4, color = "#084594") +
  labs(
    title = "Forest Plot: Multivariate Adjusted Odds Ratio",
    subtitle = "Analisis Risk Factors Kejadian Hipertensi (Garis Merah = OR Netral = 1.0)",
    x = "Odds Ratio (OR)",
    y = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    panel.grid.minor = element_blank()
  )

# Tampilkan Forest Plot
print(plot_forest)