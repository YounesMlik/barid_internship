#import "@preview/mmdr:0.2.2": mermaid


This section details the implementation of the data engineering layer responsible for transforming raw operational postal data into structured datasets suitable for forecasting. It corresponds to the execution of the data preparation strategy described in @section_methodology_data_prep.

The implementation addresses two main constraints:

- absence of a dedicated analytical database;
- reliance on operational interfaces designed for manual consultation rather than bulk extraction.

As a result, the data pipeline is built around automated extraction, intermediate storage, and repeated aggregation steps.

=== Data Extraction Layer

The raw data used in this internship originates from operational systems related to international mail processing (SMI and tracking interfaces). Since these systems do not provide a stable analytical API, data extraction was implemented using browser automation.

The extraction workflow is based on Playwright and simulates user interactions with internal web interfaces.

The process can be summarized as follows:

- authentication into operational interfaces;
- navigation to reporting or tracking pages;
- query execution over selected time ranges;
- extraction of tabular HTML content;
- conversion into structured formats.

The extraction mechanism is summarized in @fig-extraction-pipeline.

#figure(
  placement: auto,
  mermaid(
"
flowchart TD

A[Operational Web Interfaces]
B[Playwright Automation Layer]
C[Authenticated Session]
D[Report / Tracking Pages]
E[HTML Tables]
F[Parsed Structured Data]
G[Intermediate Storage]

A --> B --> C --> D --> E --> F --> G
"
  ),
  caption: [Automated data extraction pipeline from operational systems.]
) <fig-extraction-pipeline>

@fig-extraction-pipeline illustrates the transformation of operational web interfaces into structured datasets. The use of browser automation ensures reproducibility of data extraction while compensating for the absence of a formal API.

=== Aggregation and Time-Series Construction

After extraction, raw transactional records are aggregated into weekly time series suitable for forecasting.

The aggregation process groups observations by:

- deposit center;
- destination country;
- time index (weekly frequency).

Additional transformations are applied to compute:

- total shipment counts;
- aggregated weight metrics;
- descriptive statistics (mean, standard deviation).

The aggregation logic is illustrated in @fig-aggregation-pipeline.

#figure(
  mermaid(
"
flowchart LR

A[Raw Shipment Records]
B[Filtering & Cleaning]
C[Grouping by Date (7D)]
D[Grouping by Center & Destination]
E[Aggregation Functions (count, sum, mean)]
F[Weekly Time Series Dataset]

A --> B --> C --> D --> E --> F
"
  ),
  caption: [Aggregation process used to construct weekly time series.]
) <fig-aggregation-pipeline>

@fig-aggregation-pipeline shows how transactional postal records are transformed into structured weekly time series. This step is critical because forecasting models require consistent temporal spacing and homogeneous series definitions.

=== Hierarchical Dataset Construction

The dataset is structured as a hierarchical time series, where multiple aggregation levels coexist within a unified representation.

The hierarchy includes:

- total outgoing international mail flow;
- deposit centers;
- destination countries;
- deposit center × destination combinations.

The hierarchical structure is constructed as shown in @fig-hierarchy-build.

#figure(
  mermaid(
"
flowchart TD

A[Base Time Series (Center × Destination)]
B[Grouped Aggregations]
C[Center-Level Series]
D[Destination-Level Series]
E[Global Total Series]

A --> B
B --> C
B --> D
B --> E
"
  ),
  caption: [Construction of hierarchical time series structure.]
) <fig-hierarchy-build>

@fig-hierarchy-build illustrates how multiple aggregation levels are derived from a single base dataset. This structure enables later application of hierarchical forecasting and reconciliation methods.

=== Data Quality and Storage Layer

To ensure reproducibility and efficiency, intermediate datasets are stored in compressed columnar formats (Parquet).

This choice is motivated by:

- reduced storage size;
- faster read/write performance;
- compatibility with Polars and Pandas workflows.

The data pipeline also includes validation steps to ensure consistency, including:

- removal of null or corrupted records;
- verification of temporal continuity;
- enforcement of unique identifiers for hierarchical series.

The data engineering layer provides the foundation of the forecasting system. It ensures that raw operational data is transformed into a structured, consistent, and hierarchical dataset suitable for modeling.

Without this layer, forecasting models would not be able to operate reliably due to inconsistencies in source systems and the absence of analytical data infrastructure.

The next section presents the implementation of feature engineering procedures applied on top of this dataset.