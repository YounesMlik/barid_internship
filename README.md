# International Mail Volume Forecasting for Barid Al-Maghrib

Forecasting weekly outgoing international mail volumes using statistical, machine learning, and deep learning models.

This repository contains the implementation developed during my engineering internship at **Barid Al-Maghrib (BAM)**. The project focuses on building an end-to-end forecasting pipeline, from automated data acquisition to model evaluation and interactive visualization.

---

## Project Report
The project report can be found at [report/report.pdf](report/report.pdf)

---

## Project Overview

International mail volumes exhibit strong seasonality, calendar effects, and changing trends. Accurate forecasts can help postal operators anticipate workload, allocate transportation capacity, and improve operational planning.

This project implements a complete forecasting workflow including:

* Automated data collection from BAM operational systems
* Data cleaning and preprocessing
* Feature engineering
* Time-series forecasting
* Hierarchical forecast reconciliation
* Interactive dashboard for forecast exploration

The forecasting pipeline compares multiple families of models under a common evaluation framework.

---

## Features

* Automated extraction of historical operational data
* Data validation and preprocessing
* Weekly aggregation of international shipment volumes
* Statistical forecasting models
* Machine learning forecasting models
* Deep learning forecasting models
* Ensemble forecasting
* Rolling-origin cross-validation
* Hierarchical forecasting and reconciliation
* Interactive dashboard for exploring forecasts

---

## Repository Structure

```text
.
├── data/                # Raw and processed datasets (not included)
├── notebooks/           # Exploratory notebooks
├── src/
│   ├── extraction/      # Data acquisition scripts
│   ├── preprocessing/   # Cleaning and feature engineering
│   ├── forecasting/      # Model implementations
│   ├── evaluation/       # Metrics and benchmarking
│   └── dashboard/        # Interactive dashboard
├── reports/
│   └── thesis/          # Engineering internship report
├── figures/
└── README.md
```

---

## Forecasting Models

### Baseline

* Seasonal Naive

### Statistical Models

**State-space models**

* AutoETS
* CES

**ARIMA family**

* AutoARIMA

**Decomposition methods**

* AutoTheta

**Multiple seasonality**

* AutoTBATS

**Smoothing and ensemble methods**

* AutoMFLES

### Machine Learning Models

* Linear Regression
* Ridge Regression
* Lasso
* Elastic Net
* ARD Regression
* Tweedie Regression
* HistGradientBoostingRegressor
* XGBoost
* LightGBM
* CatBoost

### Deep Learning Models

* NHITS
* BiTCN

### Ensemble Models

* Statistical Ensemble
* Machine Learning Ensemble
* Neural Ensemble

---

## Evaluation

Models are evaluated using rolling-origin cross-validation.

Performance metrics include:

* MASE
* Normalized Deviation (ND)
* Relative MAE (Seasonal Naive baseline)
* Scaled Pinball Interval Score (SPIS)

---

## Results

The deep learning models achieved the best overall forecasting accuracy.

| Model           | Relative MAE |
| --------------- | -----------: |
| BiTCN           |    **0.108** |
| Neural Ensemble |    **0.112** |
| NHITS           |    **0.137** |
| ML Ensemble     |        0.385 |
| Ridge           |        0.404 |
| Seasonal Naive  |        1.000 |

An important observation is that neural models produced outstanding short-term forecasts but their accuracy deteriorated noticeably for longer forecasting horizons. Classical machine learning models were generally more stable over extended horizons despite lower overall accuracy.

---

## Technologies

* Python
* Polars
* NumPy
* scikit-learn
* StatsForecast
* MLForecast
* NeuralForecast
* HierarchicalForecast
* CatBoost
* XGBoost
* LightGBM
* Playwright
* Apache Parquet

---

## Dashboard

The project includes an interactive dashboard allowing users to:

* Select any forecasting model
* Compare forecasts with historical observations
* Explore prediction intervals
* Analyze hierarchical forecasts
* Visualize cross-validation results

---

## Data

The original datasets are proprietary and belong to **Barid Al-Maghrib**. They are therefore **not included** in this repository.

The repository only contains the source code required to reproduce the processing pipeline.

---

## Engineering Report

A complete description of the methodology, experiments, and results is available in the accompanying engineering internship report.

The report covers:

* Data engineering pipeline
* Exploratory data analysis
* Feature engineering
* Forecasting methodology
* Model comparison
* Hierarchical forecasting
* Operational dashboard
* Conclusions and future work

---

## License

This repository is provided for academic and research purposes.

Operational data and extracted datasets remain the property of **Barid Al-Maghrib**.
