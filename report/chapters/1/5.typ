== Problem Statement

The objective of this internship is to address a practical operational problem faced within Barid Al-Maghrib: the lack of reliable forecasting tools for outgoing international mail flows.

Despite the existence of operational information systems such as the Système de Messagerie Intégré (SMI), these systems are primarily designed for transaction processing and real-time tracking rather than predictive analytics. As a result, historical data is fragmented across multiple interfaces and is not directly exploitable for statistical modeling or forecasting purposes.

This situation creates a gap between operational data availability and analytical requirements needed for strategic planning.

=== Operational Need for Forecasting

Outgoing international mail flows are subject to strong variability driven by several factors, including:

- Seasonal effects (e.g., Ramadan-related peaks);
- E-commerce demand fluctuations;
- International logistics constraints;
- Customs delays and regulatory differences;
- Behavioral patterns of the Moroccan diaspora.

Without forecasting tools, operational planning relies heavily on historical averages or expert intuition. This limits the ability to anticipate demand peaks and optimize resource allocation in advance.

Accurate forecasting is therefore essential for:

- Transport capacity planning;
- Sorting center workload management;
- Workforce allocation;
- Service quality improvement;
- Cost optimization in international logistics operations @upu_forecasting.

=== Data-Related Constraints

A major challenge identified during this internship is the lack of a unified analytical data infrastructure.

The main constraints include:

- Absence of a dedicated data warehouse for historical postal data;
- Lack of structured APIs for bulk data extraction;
- Reliance on web-based reporting interfaces;
- Performance limitations of legacy systems for large queries;
- Incomplete or inconsistent historical coverage across modules.

As a consequence, building a usable dataset requires extensive data engineering efforts, including:

- Web automation for extraction;
- HTML parsing of tracking information;
- Data cleaning and deduplication;
- Transformation into structured formats suitable for analysis.

These constraints significantly increase the complexity of any forecasting pipeline built on top of operational systems.

=== Analytical Gap

Although BAM systems provide detailed operational tracking, they do not natively support predictive analytics.

The key analytical gap can be summarized as follows:

- Systems provide *descriptive information* (what happened);
- They lack *predictive capabilities* (what will happen);
- Decision-making is therefore reactive rather than proactive.

This gap limits the ability to anticipate demand fluctuations and optimize international logistics flows in advance.

From a data science perspective, this translates into the need for:

- Time-series reconstruction from fragmented sources;
- Robust handling of missing or inconsistent data;
- Selection of appropriate forecasting models adapted to operational constraints.

=== Problem Formulation

The problem addressed in this internship can be formally defined as a time-series forecasting problem.

Given historical observations of outgoing international mail flows, the objective is to predict future values over a fixed horizon.

Let:

- $y_t$ represent the number of outgoing international parcels (or total weight) at time $t$,
- $h$ represent the forecasting horizon.

The goal is to estimate:

$ hat(y)_(t+h) = f(y_t, y_(t-1), ..., y_(t-n)) $

where $f$ is a forecasting function learned from historical data.

The forecasting task is constrained by:

- Noisy and incomplete historical data;
- Strong seasonal patterns;
- Structural changes over time;
- Limited reliability of long-term extrapolation.

The chosen forecasting horizon is four weeks, which corresponds to operational planning cycles within postal logistics.

=== Objectives of the Study

The main objectives of this study are:

- Reconstruct a consistent historical dataset from operational systems;
- Identify key temporal patterns in outgoing international mail flows;
- Develop and compare multiple forecasting models;
- Evaluate forecasting performance using robust statistical metrics;
- Provide actionable insights for operational planning.

These objectives aim to transform raw operational data into a structured analytical framework capable of supporting decision-making.

=== Expected Outcome

The expected outcome of this internship is a complete forecasting pipeline capable of:

- Processing raw operational postal data;
- Generating reliable short-term forecasts;
- Quantifying uncertainty through prediction intervals;
- Supporting planning decisions within Barid Al-Maghrib.

This pipeline is intended to improve visibility over international mail demand and contribute to more efficient resource allocation.

=== Summary

The core problem addressed in this internship lies at the intersection of operational constraints and analytical requirements.

While Barid Al-Maghrib possesses rich operational data, the lack of structured analytical infrastructure prevents its direct use for forecasting purposes. This internship addresses this gap by proposing a complete data engineering and forecasting pipeline capable of transforming raw operational data into actionable predictions.