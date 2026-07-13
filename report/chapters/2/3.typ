#import "@preview/mmdr:0.2.2": mermaid


According to the CRISP-DM methodology @crispdm, the Data Understanding phase aims to identify available data sources, assess their suitability for the forecasting task, and characterize the statistical properties of the target variable before any transformation or modeling step is undertaken.

In this internship, the forecasting task relies on operational data originating from Barid Al-Maghrib's information systems. More specifically, the study focuses on historical records associated with outgoing international shipments deposited in Morocco and processed through the Système de Messagerie Intégré (SMI).

The available data is transactional in nature, with each observation describing an individual shipment and containing operational information recorded during the acceptance process. Among the attributes used in this study are shipment identifiers, deposit dates, destination countries, originating agencies, and shipment weights.

As the objective is to forecast aggregate international mail flows rather than individual shipments, the raw observations are transformed into weekly time series through aggregation procedures described in the following section. The forecasting target considered in this work corresponds primarily to the total weight of outgoing shipments aggregated over one-week periods. Shipment counts are also retained as complementary indicators for exploratory analyses and consistency checks.

The historical data available for this internship covers shipments deposited from January 2023 onwards. Prior to any modeling effort, an exploratory analysis was conducted to understand the temporal behavior of international mail flows and to identify potential sources of variability.

#figure(
  mermaid(
"
flowchart TB

A[Operational Information Systems]

A --> B[Dataset Exploration]

B --> C[Coverage Assessment]
B --> D[Cardinality Analysis]
B --> E[Temporal Analysis]

C --> F[Selection of Reliable Period]

F --> G[Weekly Aggregation]

G --> H[Trend Analysis]
G --> I[Seasonality Analysis]
G --> J[Distribution Analysis]
G --> K[Hierarchy Exploration]

"
),
caption:[
Data understanding workflow implemented during the internship.
]
)<fig-data-understanding-workflow>

@fig-data-understanding-workflow summarizes the activities carried out during the data understanding phase. Since the available information systems were primarily designed for operational purposes, an initial investigation was required to assess dataset coverage, data quality, and temporal consistency. This phase included the analysis of feature cardinalities, the identification of reliable observation periods, and the exploration of hierarchical structures before aggregating shipment records into weekly time series suitable for exploratory analyses and forecasting.

The exploratory analysis highlighted several characteristics of the dataset that influenced subsequent methodological choices.

First, the series exhibits a clear long-term trend associated with the increasing importance of parcel logistics and international exchanges. Second, recurrent seasonal patterns can be observed, particularly around religious and vacation periods. Preliminary analyses also suggested that the seasonality of international flows may be better represented using a Hijri annual cycle than a conventional Gregorian yearly seasonality. This observation motivated the use of a seasonal period of approximately fifty-one weeks in several forecasting models.

Finally, the exploratory analysis confirmed the existence of a natural hierarchical structure within the data. Shipments can be analyzed at multiple aggregation levels, including the national total, deposit centers, destination countries, or combinations of both dimensions. This characteristic makes hierarchical forecasting techniques particularly relevant for the present study.
