#import "@preview/mmdr:0.2.2": mermaid


The forecasting system is implemented as an end-to-end pipeline that connects raw operational postal data to final analytical outputs, including forecasts and interactive visualizations.

The architecture follows a layered design separating data ingestion, transformation, modeling, and presentation.

=== End-to-End Pipeline

The complete pipeline implemented during this internship is illustrated in @fig-end-to-end-pipeline.

#figure(
  placement: auto,
  mermaid(
    "
%%{ init: { 'flowchart': { 'curve': 'stepAfter' } } }%%
flowchart TD

A[Operational Data Sources (SMI / Tracking / Reports)]
B[Data Extraction Layer (Playwright / ETL)]
C[Data Cleaning & Aggregation (Polars)]
D[Hierarchical Time Series Construction]
E[Feature Engineering Layer]
F[Model Training (Stats / ML / Neural)]
G[Forecast Generation]
H[Hierarchical Reconciliation]
I[Structured Forecast Dataset]
J[Evaluation & Cross-Validation]
K[Altair Visualization Layer]

A --> B --> C

C --> E --> F --> G --> H
C --> D --> H

H --> I --> J --> K
",
  ),
  caption: [End-to-end forecasting pipeline implemented during the internship.],
) <fig-end-to-end-pipeline>

@fig-end-to-end-pipeline summarizes the full operational workflow implemented in this internship. Raw operational data is progressively transformed into structured hierarchical time series, enriched with engineered features, and processed by multiple forecasting families. The resulting predictions are reconciled and then evaluated and visualized.

This design ensures traceability between raw operational events and final forecasting outputs, which is essential in a production-constrained environment where data is not directly available in analytical form.

=== Technology Stack

The system was implemented using a combination of data engineering, machine learning, and visualization tools.

The main technologies used are summarized in @tbl-tech-stack.

#figure(
  placement: auto,
  table(
    columns: (2fr, 4fr),

    table.header([Component], [Tools / Libraries]),

    [Data processing], [Python, Polars, Pandas],

    [Data extraction], [Playwright],

    [Statistical forecasting], [StatsForecast],

    [Machine learning forecasting], [MLForecast, scikit-learn, XGBoost, LightGBM, CatBoost],

    [Deep learning forecasting], [NeuralForecast (NHITS, BiTCN)],

    [Hierarchical forecasting], [HierarchicalForecast],

    [Visualization], [Altair, VegaFusion],

    [Evaluation], [utilsforecast, statsmodels metrics],
  ),
  caption: [Technology stack used in the forecasting system.],
) <tbl-tech-stack>

@tbl-tech-stack shows that the implementation relies on a modular ecosystem where each library addresses a specific layer of the pipeline. This separation of concerns allowed independent development of data engineering, modeling, and visualization components while maintaining interoperability through standardized data structures.
