The information systems used by Barid Al-Maghrib form the main operational backbone for managing postal activities and constitute the primary source of data used in this internship. They support shipment processing, operational monitoring, and the consultation of activity reports used by internal teams for daily decision-making.

Although these systems contain rich historical information, they are primarily designed for operational execution rather than analytical exploitation. This design choice has a direct impact on how data can be accessed, extracted, and reused for forecasting purposes.

=== Digital Transformation Context

Like many postal operators, Barid Al-Maghrib is undergoing gradual digital transformation to handle increasing parcel volumes, improve traceability, and support operational monitoring. The growth of e-commerce and the rising expectations of users regarding shipment tracking have reinforced the importance of reliable and structured data.

However, a large part of the existing information systems still follows an operational logic, where data is optimized for transaction processing rather than large-scale analysis. This creates a gap between available information and its direct usability for statistical modeling.

Within this context, the internship required the development of dedicated data preparation and extraction procedures in order to transform operational records into analytical datasets.

=== Système de Messagerie Intégré (SMI)

The Système de Messagerie Intégré (SMI) is the central application used for managing postal shipments and recording operational events throughout their lifecycle.

It allows users to:

- Register shipment information at acceptance;
- Track processing stages across postal facilities;
- Consult shipment histories;
- Monitor sorting and dispatch operations;
- Access operational reporting interfaces.

While SMI contains the core historical data used in this study, it presents several limitations from an analytical perspective. In particular, it does not provide a dedicated API for bulk extraction, and its export functionalities are limited in scope and performance. Long queries covering extended time periods are also constrained by system responsiveness.

These limitations had a direct influence on the data acquisition strategy used during the internship.

=== Tracking and Event Systems

Shipment tracking is based on event logs associated with each parcel or mail item. Each event corresponds to a timestamped operational action such as acceptance, sorting, dispatch, transit, or delivery.

This event-based structure makes it possible to reconstruct the lifecycle of each shipment. However, accessing these events at scale requires navigating interfaces that are primarily designed for individual shipment queries rather than batch extraction.

As a result, extracting historical tracking data required automated interaction with system interfaces in order to collect large volumes of shipment-level information.

=== Reporting Interfaces

In addition to operational systems, Barid Al-Maghrib provides reporting tools that display aggregated indicators related to postal activity. These include daily volumes, destination distributions, and agency-level statistics.

These reporting interfaces are useful for operational monitoring but remain limited for analytical work. In particular, they do not systematically provide raw historical data in formats directly suitable for modeling or time-series construction.

This constraint made it necessary to rely on automated extraction pipelines to retrieve and structure the required information.

=== Data Extraction Approach

Given the absence of direct programmatic access to historical data, an automated extraction process was implemented using browser automation techniques with Playwright for Python @playwright.

This approach allowed:

- Navigation of reporting and tracking interfaces;
- Automated selection of time intervals and filters;
- Extraction of shipment-level and tracking data;
- Iterative collection over long historical periods.

The extracted data was then consolidated and stored in a structured format suitable for downstream processing and analysis.

=== Data Engineering Constraints

Several technical limitations were encountered during data collection:

- No public API for historical data access;
- Interface-based access requiring manual or automated interaction;
- Performance limitations over large date ranges;
- Heterogeneous export formats depending on the module used.

To address these constraints, the data pipeline included automated retries, incremental extraction over smaller time windows, and intermediate storage to ensure robustness.

Final datasets were stored in columnar format (Parquet) to improve efficiency during analysis and model training.

=== Role of Information Systems in This Internship

The information systems described above constitute both the origin and the main constraint of the analytical work performed in this internship.

They provide detailed operational data on shipment processing, but require significant transformation before being usable for forecasting. This transformation step represents a central part of the methodology developed in this work.

The quality, structure, and accessibility of these systems directly influenced the design of the datasets used in the subsequent modeling phase.
