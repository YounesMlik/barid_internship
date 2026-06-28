#import "@preview/mmdr:0.2.2": mermaid


This section describes the implementation of feature engineering procedures applied to the structured dataset produced in @section_realization_data_engineering. The objective of this layer is to enrich the raw time-series information with explanatory variables that improve forecasting performance across statistical, machine learning, and neural models.

The feature engineering design follows the structure defined in @section_methodology_data_prep, with a separation between shared features, machine learning-specific features, and transformations applied uniformly across all models.

=== Shared Features (All Models)

A common set of features is used across all forecasting approaches to ensure comparability between model families.

The main shared feature is the deterministic trend component, constructed from the time index.

This feature is generated using a preprocessing pipeline and is included in both machine learning and neural forecasting models.

In addition, all models operate on a standardized weekly time index (ds) and a target variable representing shipment counts or aggregated weights.

The role of shared features in the modeling pipeline is summarized in @fig-shared-features.

#figure(
  mermaid(
"
flowchart LR

A[Weekly Time Series (ds, y)]
B[Trend Feature]
C[Common Feature Space]
D[All Model Families]

A --> B --> C --> D
"
  ),
  caption: [Shared feature structure used across all forecasting models.]
) <fig-shared-features>

@fig-shared-features illustrates that all forecasting models operate on a unified feature representation. This ensures that performance differences between models are attributable to their learning mechanisms rather than differences in input representation.

=== Machine Learning Feature Set (MLForecast)

Machine learning models reformulate the forecasting problem as supervised learning. As a result, additional lag-based features are required to capture temporal dependencies.

The feature set used for ML models includes:

- lag features (1, 2, 3, 4, seasonal lag);
- deterministic trend feature;
- optional calendar-derived features (not retained in the final configuration).

The lag structure is defined as:

- $y_(t-1)$, $y_(t-2)$, $y_(t-3)$, $y_(t-4)$;
- $y_(t-m)$ where $m$ corresponds to the seasonal period (approximately one Hijri year in weeks).

The ML feature generation process is illustrated in @fig-ml-features.

#figure(
  mermaid(
"
flowchart TD

A[Time Series y(t)]
B[Lag Feature Generator]
C[Trend Feature]
D[Feature Matrix X]
E[ML Models]

A --> B --> D
A --> C --> D
D --> E
"
  ),
  caption: [Feature engineering pipeline for machine learning models.]
) <fig-ml-features>

@fig-ml-features shows how lagged observations and trend information are combined into a supervised learning dataset. This transformation is essential for enabling regression-based forecasting models.

=== Neural Feature Set (NeuralForecast)

Neural forecasting models differ from classical machine learning approaches in that they learn temporal representations directly from sequences of observations.

In this implementation, neural models are provided with:

- historical time windows (input sequences);
- optional trend feature shared with other models;
- no explicit lag feature engineering.

This design is consistent with the requirements of architectures such as NHITS and BiTCN, which internally learn temporal dependencies using convolutional or hierarchical structures.

The trend feature is retained to provide a global signal that improves stability in long-term pattern learning.

The neural input structure is summarized in @fig-neural-features.

#figure(
  mermaid(
"
flowchart LR

A[Time Series Windows]
B[Neural Encoder (BiTCN / NHITS)]
C[Internal Representation Learning]
D[Forecast Output]

A --> B --> C --> D
"
  ),
  caption: [Neural forecasting input-output structure.]
) <fig-neural-features>

@fig-neural-features illustrates that neural models bypass explicit lag construction and instead rely on learned representations of sequential input windows.

=== Time-Series Transformations

To improve model stability, logarithmic transformations are applied to the target variable during training.

The transformation used is:

$
y' = log(1 + y)
$

This transformation reduces the impact of extreme values and stabilizes variance in highly skewed distributions.

After forecasting, an inverse transformation is applied:

$
y = exp(y') - 1
$

The feature engineering layer provides a unified representation of the time series adapted to different modeling paradigms.

By separating shared features, machine learning-specific lag structures, and neural input representations, the system ensures consistency across models while preserving methodological flexibility.

The next section presents the implementation of the forecasting models themselves across statistical, machine learning, and deep learning frameworks.
