#import "@preview/mmdr:0.2.2": mermaid


The objective of this chapter is to present the methodological framework used to address the forecasting problem defined in Chapter 1. The work is structured according to the CRISP-DM methodology, adapted to the specific constraints of Barid Al-Maghrib’s operational environment and to the nature of hierarchical time series forecasting.

Unlike classical data science workflows applied in fully controlled environments, the present study operates on top of legacy postal information systems that were not originally designed for analytical exploitation. This constraint directly influences the structure of the pipeline, from data extraction to model evaluation, and justifies the use of a structured methodology to ensure reproducibility and consistency across all stages of the project.

The methodology adopted in this internship covers the full lifecycle of the forecasting system, including data understanding, data preparation, feature engineering, model development across multiple paradigms, hierarchical reconciliation, and evaluation using time-series cross-validation. In addition, a deployment-oriented component is introduced through an interactive visualization layer built with Altair, enabling exploratory analysis and operational interpretation of forecasting results.

The following sections describe each stage of this process in detail, starting with the adaptation of the CRISP-DM framework to the specific context of international postal flow forecasting.

#figure(
  mermaid(
    "flowchart TD

%% =======================
%% CRISP-DM Adapted Pipeline
%% Global Forecasting System
%% =======================

subgraph D[Data Understanding]
A[Raw SMI data]
end

subgraph P[Data Preparation]
B[Weekly aggregation<br/>(Polars pipeline)]
C[Hierarchical structure<br/>(S_df / tags)]
D1[Feature engineering<br/>(trend + lags)]
end

subgraph M[Modeling]
E1[StatsForecast]
E2[MLForecast]
E3[NeuralForecast]
end

subgraph R[Reconciliation]
F[Top-down reconciliation layer]
end

subgraph E[Evaluation]
G[Cross-validation]
H[Metrics computation]
end

subgraph Dp[Deployment]
I[Altair dashboard]
end

%% Flow
A --> B --> C --> D1

D1 --> E1
D1 --> E2
D1 --> E3

E1 --> F
E2 --> F
E3 --> F

F --> G --> H --> I",
  ),
  caption: [Global architecture of the forecasting pipeline adapted from CRISP-DM.],
)
