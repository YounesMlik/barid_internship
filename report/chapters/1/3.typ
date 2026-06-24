The information systems used by Barid Al-Maghrib constitute the primary source of operational data exploited during this internship. They support the management of postal activities, shipment tracking, and the consultation of statistical reports used by operational teams.

For the purposes of this work, particular attention was given to the systems involved in managing international mail flows and providing access to historical shipment information. The availability and structure of these data sources directly influenced the methodology adopted for data extraction and forecasting.

=== Digital Transformation Context

Like many postal operators, Barid Al-Maghrib is progressively modernizing its information systems to support growing parcel volumes, improve shipment traceability, and facilitate operational monitoring.

The increasing importance of e-commerce, customer expectations regarding tracking services, and the need for better planning tools have strengthened the role of data within postal activities. However, some operational applications remain primarily designed for day-to-day processing and consultation purposes, which limits their direct use for analytical studies.

Within the framework of this internship, these constraints motivated the implementation of dedicated data engineering procedures to prepare datasets suitable for time-series analysis.

=== Système de Messagerie Intégré (SMI)

The Système de Messagerie Intégré (SMI) is the main operational application used to manage postal items and record events associated with their processing.

SMI stores information related to shipments, including operational status updates generated during their lifecycle. Among the functionalities observed during the internship are:

- Registration of shipment information;
- Consultation of shipment histories;
- Monitoring of sorting and dispatch activities;
- Access to operational reports;
- Support for shipment tracking requests.

Since SMI was developed primarily to support operational activities, its functionalities for large-scale historical data extraction remain limited. During the internship, several constraints were identified:

- Absence of a public API for automated access;
- Restricted export capabilities;
- Slow response times for extensive queries;
- Interfaces mainly intended for manual consultation.

These limitations influenced the data acquisition strategy adopted for the study.

=== Tracking and Event Management Systems

Shipment tracking services provide visibility over the successive stages of postal processing.

Each shipment is associated with a unique identifier allowing access to events such as:

- Acceptance at a post office;
- Processing in sorting centers;
- Dispatch toward destination countries;
- Arrival at destination facilities;
- Delivery or return status.

Tracking information is recorded as timestamped events that describe the progression of shipments through the postal network.

Although these systems facilitate shipment monitoring, they are not optimized for extracting large historical datasets. Consequently, part of the information required for this study had to be collected through automated interactions with available interfaces.

=== Reporting and Data Extraction

Operational reporting tools are used within Barid Al-Maghrib to monitor postal activities and consult aggregated indicators.

These reports provide information such as:

- Daily shipment volumes;
- Distribution of shipments by destination;
- Agency-level activity indicators;
- Delivery status summaries.

During the internship, it was observed that these interfaces are mainly intended for consultation purposes and offer limited possibilities for automated data retrieval. In particular, some reports become difficult to exploit over long periods, and export functionalities do not always provide data in formats directly suitable for analytical processing.

To address these limitations, an automated extraction pipeline was developed using Playwright for Python @playwright. This approach enabled the collection of historical data while reducing manual interventions.

=== Data Engineering Constraints

Several technical challenges were encountered during the data collection phase, including:

- Lack of direct programmatic access to historical records;
- Session-based authentication mechanisms;
- Variability in export formats;
- Instability when requesting large volumes of data.

To overcome these issues, the extraction process incorporated:

- Browser automation techniques;
- Retry mechanisms in case of failures;
- Incremental collection procedures;
- Intermediate storage of retrieved data.

The processed datasets were subsequently stored in Parquet format to facilitate downstream analytical tasks.

=== Role of Information Systems in This Study

The information systems described above constitute the main source of data used throughout this internship.

Historical records extracted from SMI and associated reporting interfaces were used to reconstruct outgoing international mail flows and prepare datasets for forecasting models.

More specifically, these systems provided:

- Shipment-related operational information;
- Timestamped processing events;
- Aggregated indicators used for validation and exploratory analysis.

The availability and quality of these data sources had a direct impact on the design of the preprocessing pipeline and the forecasting methodology presented in the following chapters.

=== Summary

The information systems used within Barid Al-Maghrib ensure the execution and monitoring of postal activities on a daily basis. From the perspective of this internship, they also represent the primary source of historical information required for forecasting outgoing international mail volumes.

Because these systems were designed mainly for operational use, additional extraction, preprocessing, and automation steps were necessary to build datasets suitable for analytical modeling. The methodology adopted during the internship was therefore intended to bridge the gap between operational data sources and the requirements of time-series forecasting models.
