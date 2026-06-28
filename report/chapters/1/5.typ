The work carried out during this internship addresses the problem of forecasting outgoing international mail volumes using historical operational data from Barid Al-Maghrib.

Although operational information systems provide access to shipment tracking and reporting functionalities, they are primarily designed for transaction processing and operational monitoring. As a result, they offer limited support for historical analysis and almost no direct capabilities for predictive modeling. This creates a gap between available data and its analytical usability.

Bridging this gap requires transforming operational records into structured datasets suitable for time-series analysis. This involves extracting data from heterogeneous systems, cleaning and consolidating it, and reconstructing consistent temporal series that can be used for forecasting models.

=== Operational Need for Forecasting

Outgoing international mail volumes are characterized by strong variability over time. Exploratory analysis conducted during this internship revealed recurring seasonal patterns, particularly increases in activity during periods preceding Ramadan. These variations reflect both cultural and commercial dynamics affecting postal demand.

Several external factors also contribute to fluctuations in shipment volumes:

- Growth of e-commerce and cross-border purchases;
- Variations in international transport capacity;
- Customs processing delays in destination countries;
- Seasonal migration and exchanges with Moroccan communities abroad.

From an operational perspective, these variations directly affect workload planning, transport scheduling, and resource allocation. Being able to anticipate such changes is therefore valuable for improving operational efficiency.

=== Data-Related Constraints

A major difficulty encountered during the internship concerns data accessibility.

The main limitations include:

- Restricted export capabilities from operational systems;
- Absence of direct APIs for historical extraction;
- Dependence on interfaces designed for manual consultation;
- Performance degradation when querying long time periods;
- Inconsistent coverage across different system modules.

Because of these constraints, constructing a usable dataset required significant preprocessing effort. This included automated extraction procedures, consolidation of multiple data sources, and data cleaning operations to ensure consistency and reliability.

=== Analytical Gap

Operational systems provide detailed transactional visibility but do not directly support forecasting tasks. They answer the question of what happened, but not what is likely to happen next.

The analytical gap can be summarized as follows:

- Historical data exists but is fragmented across systems;
- Time series must be reconstructed from event-level records;
- Data quality issues must be addressed before modeling;
- Forecasting requires aggregation and temporal alignment that are not provided natively.

The objective of this work is not to replace operational systems, but to reuse their data for analytical purposes.

=== Problem Formulation

The forecasting problem can be formulated as a univariate time-series prediction task.

Let $y_t$ denote the observed volume of outgoing international mail at time $t$, and let $h$ represent the forecasting horizon. The goal is to estimate future values $y_{t+h}$ based on historical observations.

This can be expressed as:

$
hat(y)_(t+h) = f(y_t, y_(t-1), ..., y_(t-n))
$

where $f$ is a forecasting function learned from past data.

The problem is made more challenging by several characteristics of the data:

- Seasonal patterns and periodic fluctuations;
- Irregularities and missing observations;
- Structural changes in shipment volumes over time;
- Increased uncertainty for longer forecasting horizons.

In this study, emphasis is placed on short-term forecasting, as it is most relevant for operational planning.

=== Objectives of the Study

The objectives of this internship are as follows:

- Construct a consistent historical dataset from operational sources;
- Analyze temporal patterns in outgoing international mail flows;
- Develop and compare forecasting models;
- Evaluate model performance using statistical metrics;
- Assess the operational relevance of forecasting outputs.

These objectives aim to demonstrate how operational postal data can be transformed into actionable analytical information.

=== Expected Outcome

The expected outcome is the development of a complete analytical workflow covering:

- Data extraction and consolidation;
- Data preprocessing and transformation;
- Forecast generation using multiple modeling approaches;
- Evaluation of predictive performance.

Beyond the numerical results, the goal is to establish a reproducible methodology for exploiting operational postal data in a forecasting context.

=== Summary

The problem addressed in this internship arises from the mismatch between operational data systems and analytical requirements.

By combining data engineering and time-series forecasting techniques, this work investigates the feasibility of predicting outgoing international mail volumes and their potential value for supporting operational decision-making within Barid Al-Maghrib.