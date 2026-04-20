# Wellington Temperature Analysis (MATH803 Project Part A)

A MATLAB-based time series analysis of hourly temperature data for Wellington, New Zealand, covering 1–30 January 2025.

**Author:** Nyan Tun Aye (23198368)
**Course:** MATH803 — AUT

---

## Overview

This project analyses 720 hourly temperature records from Wellington to answer four questions: characterising the data, identifying trends, forecasting the temperature for 31 January 2025, and detecting periodicity using autocorrelation and FFT.

---

## Dataset

| File | Description |
|------|-------------|
| `data/WLGJan2025Temp.csv` | 720 hourly temperature records (°C) for Wellington, 1–30 January 2025 |

---

## Repository Structure

```
wellington-temperature-analysis/
├── data/
│   └── WLGJan2025Temp.csv
├── ProjectMATLAB_NyanTunAye_23198368.m
└── README.md
```

---

## Questions & Methods

### Question 1 — Data Characteristics
- Computed mean, median, range, min, max, standard deviation, and average daily range
- Plotted a histogram of hourly temperatures (bin width = 1°C)

**Key results:**

| Statistic | Value |
|-----------|-------|
| Mean | 16.11°C |
| Median | 16°C |
| Min | 10°C |
| Max | 26°C |
| Std Dev | 2.62°C |
| Avg Daily Range | 5.15°C |

### Question 2 — Trend Analysis
- Applied a **48-hour moving average** to smooth hourly fluctuations
- Fitted **linear regression** on both hourly data and daily averages
- Computed R² for both fits

**Key results:**

| Model | R² |
|-------|----|
| Linear regression (hourly) | 0.2151 |
| Linear regression (daily averages) | 0.4041 |

A gradual upward trend was identified, with temperatures rising from ~14°C early in January to ~18°C by the end of the month.

### Question 3 — Forecasting 31 January 2025
- Fitted **polynomial models (orders 1–7)** to the 720-hour dataset and extrapolated to hours 721–744
- Applied **exponential smoothing** (α = 0.1) and projected forward

**Key results:**

| Method | Estimated Daily Average (31 Jan) | R² |
|--------|-----------------------------------|----|
| 4th-order polynomial | 14.89°C | 0.3201 |
| Exponential smoothing | 16.59°C | 0.6054 |

The 4th-order polynomial was selected as the best polynomial model (balanced R² and stability; higher-order models triggered MATLAB conditioning warnings).

### Question 4 — Periodicity
- Computed **autocorrelation** for lags up to 24 hours and 168 hours
- Computed **FFT power spectrum** and plotted power vs hours-per-cycle (up to 100 hours)
- Plotted **Fourier coefficients** (real vs imaginary)

A dominant **24-hour cycle** was confirmed in both the autocorrelation and FFT analyses, consistent with daily solar heating patterns.

---

## How to Run

1. Clone the repository
2. Place `WLGJan2025Temp.csv` inside the `data/` folder
3. Open `ProjectMATLAB_NyanTunAye_23198368.m` in MATLAB (R2024b recommended)
4. Run the script — all 10 figures will be generated sequentially

> To reproduce the submitted report, open the `.mlx` LiveScript version in MATLAB and export to PDF.

---

## Requirements

- MATLAB R2024b (or later)
- Statistics and Machine Learning Toolbox (for `autocorr`)
- Signal Processing Toolbox (for `fft`)
