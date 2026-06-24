The work carried out during this internship addresses the problem of forecasting outgoing international mail volumes using historical data available within Barid Al-Maghrib.

Although operational information systems provide access to shipment information and activity reports, they are mainly designed to support day-to-day postal operations and shipment monitoring. Their functionalities for historical analysis and predictive modeling remain limited, which makes the direct use of operational data for forecasting purposes difficult.

Consequently, an important part of the internship consisted of transforming data extracted from operational systems into datasets suitable for statistical analysis and forecasting.

=== Operational Need for Forecasting

Outgoing international mail volumes exhibit noticeable variations over time. Exploratory analyses performed during the internship highlighted recurring patterns and seasonal effects, including increases in activity observed during periods preceding Ramadan.

Other factors may also influence shipment volumes, such as:

- E-commerce activity;
- International transportation constraints;
- Customs processing delays;
- Variations in demand associated with Moroccan communities residing abroad.

Anticipating these fluctuations can be useful for operational activities related to transportation planning, workload estimation, and resource allocation.

Forecasting tools can therefore provide additional information to support planning decisions and improve visibility over future shipment volumes.

=== Data-Related Constraints

One of the main challenges encountered during the internship was related to data availability and accessibility.

Several constraints were identified:

- Limited possibilities for exporting historical data;
- Absence of direct programmatic access to some sources;
- Dependence on reporting interfaces designed primarily for consultation;
- Performance degradation when querying long time intervals;
- Variations in data completeness across different modules.

As a result, obtaining a usable historical dataset required several preprocessing steps, including:

- Automated extraction procedures;
- Consolidation of data originating from multiple interfaces;
- Cleaning and validation operations;
- Transformation into formats adapted to analytical processing.

These tasks represented a significant component of the work carried out during the internship.

=== Analytical Gap

Operational systems provide detailed information regarding the processing and tracking of shipments. However, they do not directly offer functionalities for estimating future shipment volumes.

Bridging this gap requires:

- Reconstructing historical time series from operational records;
- Managing incomplete or inconsistent observations;
- Selecting forecasting methods appropriate for the characteristics of the data;
- Evaluating the predictive performance of different approaches.

The objective is not to replace existing operational tools but rather to investigate how historical data can be reused to support short-term forecasting activities.

=== Problem Formulation

From a modeling perspective, the problem addressed during this internship can be formulated as a time-series forecasting task.

Let:

- $y_t$ represent the observed volume of outgoing international shipments at time $t$;
- $h$ represent the forecasting horizon.

The objective is to estimate future values according to:

$ hat(y)*(t+h) = f(y_t, y*(t-1), ..., y_(t-n)) $

where $f$ denotes a forecasting model learned from historical observations.

Several characteristics of the data make this task challenging, including:

- Seasonal variations;
- Missing or incomplete observations;
- Changes in shipment volumes over time;
- Uncertainty associated with long-term predictions.

Within the scope of this internship, particular attention was given to short-term forecasts intended to support operational analyses.

=== Objectives of the Study

The objectives pursued during the internship are summarized as follows:

- Build a consistent historical dataset from operational sources;
- Analyze temporal patterns in outgoing international mail volumes;
- Implement and compare forecasting models;
- Evaluate forecasting accuracy using statistical indicators;
- Assess the potential usefulness of forecasting techniques for operational planning.

These objectives aim to demonstrate how historical postal data can be transformed into analytical information that supports decision-making activities.

=== Expected Outcome

The expected outcome of this work is the development of a workflow integrating:

- Automated data collection;
- Data preprocessing procedures;
- Forecast generation;
- Performance evaluation.

Beyond the forecasting results themselves, the study also aims to provide a reproducible methodology for exploiting operational postal data in analytical applications.

=== Summary

The problem addressed during this internship stems from the difficulty of directly using operational postal data for forecasting purposes.

By combining data extraction, preprocessing, exploratory analysis, and time-series modeling, the internship investigates the feasibility of producing short-term forecasts of outgoing international mail volumes and evaluates their potential contribution to operational planning activities within Barid Al-Maghrib.
