#import "@preview/mmdr:0.2.2": mermaid

The methodology adopted in this internship is structured according to the CRISP-DM (Cross-Industry Standard Process for Data Mining) framework @crispdm, which remains one of the most widely used reference models for data science and machine learning projects in industrial contexts.

CRISP-DM defines a cyclical process composed of six phases: Business Understanding, Data Understanding, Data Preparation, Modeling, Evaluation, and Deployment. While this structure is general-purpose, it is particularly well suited for projects involving heterogeneous data sources and iterative model development, which is the case for hierarchical forecasting of postal flows at Barid Al-Maghrib.

However, in this internship, CRISP-DM is not applied in a strictly sequential manner. Instead, it is adapted into a more engineering-oriented pipeline that reflects the operational constraints of postal information systems and the iterative nature of model development. In particular, the separation between modeling and evaluation is iterative, as multiple forecasting paradigms are tested and compared continuously.


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
) <fig-pipeline-overview>

@fig-pipeline-overview illustrates the global architecture of the forecasting system implemented in this internship. The pipeline begins with raw operational data extracted from Barid Al-Maghrib’s information systems and proceeds through a structured transformation process.

The first stage corresponds to data preparation, where weekly aggregation and hierarchical structuring are performed. This step is essential because the original data is not directly available in an analytical format and must be reconstructed into consistent time series.

The second stage introduces feature engineering, where both shared and model-specific features are generated. A key element is the trend component, which is consistently used across machine learning and neural forecasting models, ensuring comparability between different model families.

The third stage represents the modeling layer, where three distinct paradigms are applied: statistical models (StatsForecast), machine learning models (MLForecast), and deep learning models (NeuralForecast). This multi-paradigm design allows the comparison of fundamentally different forecasting approaches under a unified framework.

Finally, the pipeline includes a reconciliation step ensuring coherence across hierarchical levels, followed by evaluation and visualization. The presence of the visualization layer highlights that the system is not limited to offline modeling but also supports interactive analysis through an Altair-based interface, which is used for exploratory validation and operational interpretation of results.