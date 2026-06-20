#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node, shapes

== 2.4 Data Engineering Pipeline (ETL)

The data engineering pipeline constitutes the transformation layer between raw extracted operational data and structured datasets used for analytical modeling. In the context of this internship, the pipeline is responsible for integrating heterogeneous sources, cleaning inconsistent records, and producing time-consistent datasets suitable for forecasting.

Given the complexity and fragmentation of the source systems (SMI, tracking interfaces, and reporting modules), a robust Extract–Transform–Load (ETL) architecture was implemented to ensure data reliability, scalability, and reproducibility.

=== 2.4.1 ETL Architecture Overview

The ETL pipeline is composed of three main stages:

- Extract: retrieval of raw data from web interfaces and exported files;
- Transform: cleaning, normalization, and feature engineering;
- Load: storage into optimized analytical formats.

This structure ensures a clear separation between raw data acquisition and analytical processing, improving maintainability and traceability @kimball_dw.

=== 2.4.2 Extract Phase

The extraction phase has been detailed in previous sections (SMI, tracking, and reporting systems). In summary, it includes:

- Web automation via Playwright;
- Chunked temporal extraction (daily or weekly windows);
- HTML parsing of tracking events;
- Export of structured reports from SMI interfaces.

All extracted data is stored in raw form to ensure traceability and reproducibility.

The guiding principle of this phase is to preserve the original structure of the data as much as possible before transformation.

=== 2.4.3 Transform Phase

The transformation phase is the most critical component of the pipeline. It involves converting raw, heterogeneous, and often inconsistent data into structured analytical datasets.

==== Data Cleaning

The following cleaning operations were applied:

- Removal of duplicate records using unique identifiers (e.g., `codeenvoi_`, `cab`);
- Filtering of invalid or corrupted status values;
- Standardization of categorical variables (status codes, service types);
- Handling of missing values in numerical attributes;
- Filtering of inconsistent historical records.

==== Schema Standardization

Due to differences between systems, a unified schema was defined. This includes:

- Standardized date formats (ISO 8601);
- Consistent naming conventions for variables;
- Harmonized identifiers across systems;
- Unified representation of shipment status codes.

==== Feature Engineering

Additional variables were constructed to support time series analysis:

- Weekly aggregation of parcel counts;
- Total shipped weight per time unit;
- Average parcel weight;
- Seasonal indicators (e.g., Ramadan period flags);
- Log-transformed variables for variance stabilization.

These transformations improve the suitability of the dataset for statistical modeling and forecasting methods.

==== Temporal Aggregation

Since forecasting is performed at a weekly level, raw transactional data was aggregated using:

- Grouping by week of deposit;
- Summation of counts and weights;
- Computation of summary statistics.

This step ensures consistency between operational granularity and forecasting resolution.

=== 2.4.4 Load Phase

The final stage of the pipeline consists of storing transformed datasets into efficient analytical formats.

The chosen format is Apache Parquet due to its advantages:

- Columnar storage optimized for analytical queries;
- High compression ratios;
- Efficient I/O performance;
- Compatibility with Python data science ecosystem.

Storing intermediate and final datasets in Parquet format ensures:

- Fast loading during model training;
- Reduced storage footprint;
- Long-term reproducibility of results.

=== 2.4.5 Pipeline Automation and Orchestration

The ETL pipeline is fully automated using Python scripts orchestrating sequential tasks:

- Scheduled execution of extraction modules;
- Batch processing of transformation steps;
- Automatic validation of outputs;
- Logging of pipeline execution stages.

A modular design is used to ensure that each component can be executed independently or as part of a full pipeline run.

=== 2.4.6 Data Validation and Quality Control

To ensure data integrity, several validation rules were implemented:

- Referential integrity checks across datasets;
- Range validation for numerical variables (e.g., weight > 0);
- Consistency checks between tracking and deposit data;
- Detection of missing temporal periods;
- Outlier detection using statistical thresholds.

Records failing validation are either corrected when possible or excluded from the final dataset.

=== 2.4.7 Storage Optimization

Given the large volume of data (millions of operational records), storage optimization techniques were applied:

- Columnar compression using Parquet;
- Removal of redundant raw HTML after parsing;
- Deduplication of intermediate datasets;
- Partitioning by year and dataset type.

These optimizations significantly reduce storage requirements while maintaining analytical fidelity.

=== 2.4.8 ETL Pipeline Architecture

The overall ETL architecture is illustrated below.

#figure(
  diagram(
    node-stroke: 1pt,

    node((0, 4), name: <extract>)[Extract Layer],
    node((2, 4), name: <raw>)[Raw Data Storage],

    edge(<extract>, <raw>),

    node((2, 3), name: <transform>)[Transform Layer (Cleaning + Feature Engineering)],
    edge(<raw>, <transform>),

    node((2, 2), name: <validate>)[Validation & Quality Control],
    edge(<transform>, <validate>),

    node((2, 1), name: <load>)[Load Layer (Parquet Storage)],
    edge(<validate>, <load>),

    node((2, 0), name: <analytics>)[Forecasting & Analysis],
    edge(<load>, <analytics>),
  ),
  caption: [End-to-end ETL pipeline for postal data processing]
)

=== 2.4.9 Challenges in Data Engineering

Several challenges were encountered during ETL implementation:

- Heterogeneity of source systems;
- Inconsistent historical records across platforms;
- Large-scale data volume (millions of records);
- Performance limitations during transformation;
- Dependence on previously extracted raw data integrity.

These challenges required iterative refinement of both extraction and transformation logic.

=== 2.4.10 Summary

The ETL pipeline provides a structured framework for transforming raw operational data into clean, consistent, and analysis-ready datasets. By combining automated extraction, robust transformation logic, and optimized storage formats, the system ensures that downstream forecasting models operate on high-quality data.

This pipeline represents the core data engineering contribution of this internship project.