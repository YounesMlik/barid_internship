The methodological framework adopted in this internship is designed to address the challenges associated with extracting, structuring, and forecasting operational data from legacy postal information systems. Given the absence of a dedicated analytical infrastructure, the approach combines data engineering techniques, web automation, and statistical forecasting methods into a unified pipeline.

The overall methodology follows a structured data-driven process composed of four main stages:

- Data acquisition from heterogeneous operational sources;
- Data preprocessing and transformation;
- Time series modeling and forecasting;
- Model evaluation and validation.

This structured approach ensures traceability, reproducibility, and consistency across all stages of the analysis.

=== Objectives of the Methodological Framework

The primary objective of the methodology is to transform raw operational data into actionable forecasts that can support decision-making in the context of international mail logistics.

More specifically, the methodological framework aims to:

- Extract reliable historical data from operational systems (SMI and tracking interfaces);
- Clean and standardize heterogeneous datasets;
- Construct coherent time series representing postal activity;
- Apply and compare multiple forecasting models;
- Evaluate predictive performance using robust statistical metrics.

This aligns with standard data science pipelines for operational forecasting, where raw transactional data is progressively transformed into structured analytical inputs @hyndman_forecasting.

=== Overall Pipeline Overview

The methodological pipeline adopted in this study can be conceptually described as a sequential transformation process:

Raw Operational Systems → Data Extraction → Data Cleaning → Feature Engineering → Forecasting Models → Evaluation

Each stage plays a distinct role:

- Data Extraction: retrieves raw information from SMI reports, tracking systems, and web interfaces;
- Data Cleaning: removes inconsistencies, duplicates, and invalid records;
- Feature Engineering: constructs aggregated time series and relevant explanatory variables;
- Forecasting Models: generate predictions using statistical and machine learning approaches;
- Evaluation: measures predictive accuracy using rolling-origin validation.

This pipeline ensures that each transformation step is explicitly controlled and reproducible, which is essential when working with legacy and heterogeneous systems @upuprocesses.

=== Design Principles

The methodological design is guided by three main principles:

==== Robustness

Given the instability of legacy systems and web-based interfaces, the data extraction process must be resilient to interruptions such as session expiration, network failures, and server timeouts. Robust retry mechanisms and checkpointing strategies are therefore integrated into the pipeline.

==== Reproducibility

All data processing steps are designed to be reproducible. This includes:

- Deterministic extraction procedures;
- Versioned intermediate datasets;
- Structured storage using columnar formats (Parquet);
- Script-based automation of all transformations.

Reproducibility ensures that results can be independently verified and updated when new data becomes available.

==== Scalability

The volume of data involved (hundreds of thousands of parcels and millions of operational events) requires scalable processing techniques. To address this, the pipeline relies on:

- Batch processing strategies;
- Efficient data formats (Parquet compression);
- Chunked data extraction to avoid system overload;
- Vectorized operations during preprocessing.

These design principles are consistent with best practices in industrial data engineering systems @deeng_principles.

=== Constraints Imposed by Legacy Systems

The methodological approach is strongly influenced by the constraints of Barid Al-Maghrib’s legacy information systems.

The main constraints include:

- Lack of a formal API for structured data access;
- Reliance on HTML-based reporting interfaces;
- Limited performance of long-range queries;
- Absence of a centralized analytical data warehouse;
- Fragmentation of data across multiple operational modules.

These constraints make traditional data extraction methods (such as direct database queries or API consumption) infeasible.

As a result, alternative approaches such as Robotic Process Automation (RPA) and browser automation are required to access and reconstruct historical datasets.

This situation is common in legacy logistics and public-sector information systems, where operational continuity is prioritized over analytical accessibility @oecd_digital.

Consequently, the methodological framework is explicitly designed to operate under partial observability and imperfect data conditions, ensuring that forecasting remains feasible despite system limitations.