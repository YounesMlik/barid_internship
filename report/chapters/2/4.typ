#import "@preview/mmdr:0.2.2": mermaid


The operational data extracted from Barid Al-Maghrib's information systems cannot be directly used for forecasting purposes. The available records correspond to individual shipment transactions and are primarily intended to support operational processes such as acceptance, routing, and tracking. Consequently, several preprocessing steps were necessary to obtain coherent time series adapted to the forecasting task.

The preparation process implemented during this internship is summarized in @fig-data-preparation-pipeline.

#figure(
  placement: auto,
  mermaid(
    "
flowchart TB

A[Operational Sources]

B[Extraction and ETL]

C[Deduplication]

D[Temporal Filtering]

E[Weekly Aggregation]

F[Hierarchy Construction]

G[Feature Engineering]

H[Transformations]

I[Prepared Forecasting Datasets]


A --> B
B --> C
C --> D
D --> E
E --> F
F --> G
G --> H
H --> I

",
  ),
  caption: [
    Data preparation pipeline implemented for international mail forecasting.
  ],
)<fig-data-preparation-pipeline>

@fig-data-preparation-pipeline presents the preprocessing workflow adopted during the internship. Data extracted from operational systems first underwent cleaning, deduplication, and temporal filtering procedures to remove inconsistent observations and retain periods with sufficient historical coverage. Shipment-level records were then aggregated into weekly series, organized according to the hierarchical structures considered in this study, enriched with explanatory features, and transformed into representations compatible with statistical, machine learning, and neural forecasting models.

=== Weekly Aggregation

The original data is available at the shipment level, where each observation corresponds to a deposited international item. Since the objective of the internship is to forecast aggregated mail flows, the transactional data was resampled into weekly periods.

The choice of a weekly aggregation level was motivated by several considerations. First, weekly aggregation reduces the noise associated with day-to-day operational variability. Second, it better aligns with medium-term planning activities such as transport scheduling and capacity allocation. Finally, it allows the capture of annual seasonal effects while maintaining a sufficiently large number of observations for model estimation.

For each week, several aggregated indicators were computed, including:

- Total shipped weight;
- Number of shipments;
- Mean shipment weight;
- Standard deviation of shipment weight.

The total shipped weight was selected as the primary forecasting target, while the remaining indicators were retained for exploratory analyses and potential future extensions.


=== Hierarchical Structure Construction <section_methodology_hierarchical>

One characteristic of international mail flows is their natural hierarchical organization. The same observations can be analyzed at different levels of aggregation, ranging from a national overview to detailed flows associated with specific deposit centers and destination countries.

In this study, a two-dimensional hierarchy was defined using:

- Deposit center (*Centre_Agence_depot*);
- Destination country (*Destination*).

An additional aggregation level corresponding to the national total was introduced to represent the root node of the hierarchy.

The hierarchy considered in this work is illustrated in @fig-hierarchy-structure.

#figure(
  mermaid(
    "graph TD

A[Total]

A --> B1[Agency 1]
A --> B2[Agency 2]
A --> B3[Agency N]

B1 --> C1[France]
B1 --> C2[Belgium]
B1 --> C3[Other]

B2 --> C4[France]
B2 --> C5[Spain]

B3 --> C6[USA]",
  ),
  caption: [Hierarchical organization adopted for international mail forecasting.],
) <fig-hierarchy-structure>

@fig-hierarchy-structure presents the aggregation structure retained for forecasting. Forecasts are initially generated at the root level and subsequently reconciled to ensure consistency across all hierarchy levels. This organization enables both global analyses and detailed investigations of specific origin-destination combinations.

The hierarchy was constructed using the aggregation utilities provided by the HierarchicalForecast library @hierarchicalforecast. This process produces three essential objects:

- A dataset containing observations for all hierarchy levels;
- A summation matrix describing aggregation relationships;
- Metadata identifying each hierarchical level.

These structures are later used during the reconciliation stage described in @section_methodology_operationalization.


=== Feature Engineering <section_methodology_feature_engineering>
Feature engineering plays a central role for machine learning and deep learning forecasting models. Unlike traditional statistical methods, these approaches generally require explicit explanatory variables to capture temporal dependencies.

Two categories of features were considered in this study: shared features used by multiple model families and model-specific features.

==== Shared Features
A deterministic trend component was generated using utilities from the UtilsForecast package @utilsforecast. This variable was incorporated into both machine learning and neural forecasting models.

The trend feature allows models to account for gradual changes in international mail demand that may not be fully captured through lagged observations alone.

==== Features for Machine Learning Models
Machine learning models were trained using lag-based supervised learning representations.

The following lag variables were considered:

- Lag 1;
- Lag 2;
- Lag 3;
- Lag 4;
- Seasonal lag corresponding to an approximate Hijri year.

The inclusion of a seasonal lag was motivated by preliminary analyses suggesting that international mail flows exhibit recurring patterns associated with religious events and seasonal demand cycles.

==== Features for Machine Learning Models

Machine learning models were trained using lag-based supervised learning representations.

The following lag variables were considered:

- Lag 1;
- Lag 2;
- Lag 3;
- Lag 4;
- Seasonal lag corresponding to an approximate Hijri year.

The inclusion of a seasonal lag was motivated by preliminary analyses suggesting that international mail flows exhibit recurring patterns associated with religious events and seasonal demand cycles.


=== Transformations

Several forecasting models benefit from target transformations that stabilize variance and reduce the influence of extreme observations.

In this internship, a logarithmic transformation based on the function $\ln(1+x)$ was applied to the target variable before model fitting.

The transformed variable is defined as:

$
  y'_t = \ln(1+y_t)
$

where $y_t$ denotes the observed mail flow at time $t$.

Predictions produced in the transformed space were subsequently mapped back to the original scale using the inverse transformation.

This approach improves numerical stability and mitigates the effect of exceptionally large shipment volumes observed during peak periods.
