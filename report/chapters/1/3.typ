== Information Systems

The information systems of Barid Al-Maghrib (BAM) constitute the technological backbone supporting postal operations, logistics management, and customer services. These systems are responsible for managing the end-to-end lifecycle of postal items, from acceptance at post offices to final delivery or international exchange.

Over the last decades, BAM has progressively modernized its information systems to accompany the growth of parcel logistics, the diversification of services, and the increasing demand for real-time tracking and operational visibility.

Despite these advancements, several components of the system remain legacy-oriented and primarily designed for operational execution rather than analytical exploitation. This characteristic has a direct impact on data accessibility and the ability to perform large-scale data-driven analysis.

=== Digital Transformation Context

Like many historical postal operators, Barid Al-Maghrib is engaged in a digital transformation process aimed at improving operational efficiency, enhancing customer experience, and enabling data-driven decision-making.

This transformation is driven by several factors:

- Growth of e-commerce and parcel logistics;
- Increasing demand for shipment traceability;
- Need for real-time operational monitoring;
- Expansion of digital financial services;
- Pressure from private logistics competitors.

According to international postal modernization frameworks, digital transformation in postal operators typically involves the integration of advanced information systems, automation of sorting processes, and adoption of analytics platforms for operational optimization @upu_digital.

Within this context, BAM operates multiple internal systems that support different functional domains of postal operations.

=== Système de Messagerie Intégré (SMI)

The Système de Messagerie Intégré (SMI) is the core operational information system used by Barid Al-Maghrib to manage parcel and mail activities.

SMI is primarily designed to:

- Record shipment acceptance data;
- Track operational events;
- Manage sorting and routing operations;
- Provide operational reporting interfaces;
- Support customer service tracking queries.

SMI plays a central role in the lifecycle of postal items, as it stores all key events associated with a shipment, including deposit, transit, sorting, dispatch, and delivery status updates.

However, SMI is fundamentally an operational system (OLTP-oriented) and not designed for large-scale analytical workloads. As a result, data extraction for research or forecasting purposes presents several constraints:

- Absence of a documented public API;
- Limited bulk export capabilities;
- Performance degradation for large queries;
- Interface designed for manual consultation;
- Lack of structured historical datasets for analytics.

These limitations significantly influenced the design of the data acquisition strategy used in this internship.

=== Tracking and Event Management Systems

Tracking systems within BAM provide visibility over the status of shipments throughout their lifecycle.

Each shipment is associated with a unique identifier that allows retrieval of operational events such as:

- Acceptance at post office;
- Sorting center processing;
- Dispatch to destination hub;
- Arrival at destination;
- Delivery or return status.

Tracking data is generated as a sequence of timestamped events stored in operational logs.

While the tracking system enables customer-facing visibility, its backend is optimized for individual queries rather than batch processing. This makes large-scale extraction of historical tracking data technically challenging.

In this study, tracking information was retrieved indirectly through automated interaction with the web interface due to the absence of bulk export mechanisms.

=== Reporting and Data Extraction Layer

SMI provides a set of reporting interfaces used internally for operational monitoring and management decision-making.

These reporting modules allow users to generate aggregated views of:

- Daily shipment volumes;
- Destination breakdowns;
- Agency-level performance;
- Delivery status distributions;
- Service-level statistics.

However, these reporting tools exhibit several structural limitations:

- Query execution time increases significantly for long time ranges;
- Some reports become unstable beyond six months of data;
- Outputs are primarily designed for visualization rather than structured data export;
- No standardized API exists for automated extraction.

As a result, data extraction for analytical purposes requires alternative methods such as browser automation and scraping-based approaches.

This constraint directly motivated the development of a custom Robotic Process Automation (RPA) pipeline using Playwright for Python @playwright.

=== Data Architecture and Operational Flow

The operational data architecture of BAM can be conceptually described as a multi-layer system composed of:

- Operational layer (SMI);
- Tracking layer (event logs);
- Reporting layer (web interfaces);
- External exchange systems (international postal partners).

At the core, SMI acts as the system of record for all postal events. Each operational action performed on a parcel generates a corresponding event entry, which is stored and later aggregated for reporting purposes.

The absence of a unified analytical data warehouse means that historical data reconstruction often requires combining multiple sources, including:

- Web reports;
- Tracking HTML pages;
- Exported CSV files;
- Operational logs.

This fragmented architecture increases the complexity of data engineering tasks and necessitates custom ETL pipelines for analytical use cases.

=== Data Engineering Constraints

During this internship, several technical constraints were identified in the data acquisition process:

- Lack of API access for historical data;
- Rate limiting and system instability for large queries;
- HTML-based tracking pages not designed for structured extraction;
- Session-based authentication requiring automation;
- Inconsistent export formats across modules.

To overcome these constraints, a robust extraction pipeline was implemented using browser automation, retry mechanisms, and incremental data collection strategies.

This pipeline ensured:

- Fault tolerance in case of session expiration;
- Resume capability after interruptions;
- Idempotent data collection;
- Efficient storage of intermediate results.

The final dataset was stored in compressed columnar formats (Parquet) to optimize analytical performance.

=== Role of Information Systems in This Study

The information systems described above play a central role in this internship, as they constitute the primary source of raw operational data.

The forecasting task developed in this study relies entirely on historical data extracted from SMI and associated tracking systems.

In particular:

- SMI provides shipment-level operational events;
- Tracking systems provide lifecycle state transitions;
- Reporting systems provide aggregated validation metrics.

The combination of these sources enables the reconstruction of historical international mail flows, which are then used for time-series modeling and forecasting.

This dependency highlights the importance of understanding legacy information systems when designing data-driven analytical solutions in operational environments.

=== Summary

Barid Al-Maghrib's information systems form a complex ecosystem combining operational processing systems, tracking infrastructures, and reporting tools.

While these systems ensure reliable day-to-day postal operations, their architecture is not fully optimized for analytical exploitation. This creates significant challenges for large-scale data extraction and forecasting applications.

The methodological approach adopted in this internship was therefore designed to bridge the gap between operational systems and analytical requirements through automation, data engineering, and structured preprocessing pipelines.