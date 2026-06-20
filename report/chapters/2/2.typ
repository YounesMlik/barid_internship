#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node, shapes

== Data Collection Strategy

The data collection strategy constitutes a central component of the methodological pipeline. It defines how raw operational data is extracted from heterogeneous information systems within Barid Al-Maghrib and transformed into structured datasets suitable for analysis.

Given the absence of a unified analytical data warehouse, data must be retrieved from multiple operational systems, each with its own interface, structure, and limitations. The main sources include the Système de Messagerie Intégré (SMI), the tracking system, and operational reporting modules.

=== Data Sources Overview

The data used in this study originates from three main categories of systems:

==== Système de Messagerie Intégré (SMI)

SMI is the core operational system responsible for managing postal and parcel activities. It contains structured information related to:

- Shipment deposits;
- Origin and destination data;
- Weight and dimensional attributes;
- Service types;
- Operational status updates.

However, SMI is primarily designed for transactional processing and manual reporting rather than bulk extraction or analytics. As a result, it does not expose a public API or direct database access for analytical purposes @smibam.

==== Tracking System

The tracking system provides event-level visibility for individual shipments. Each parcel is associated with a sequence of timestamped events representing its lifecycle.

Unlike SMI, the tracking system:

- Requires individual queries per shipment;
- Returns data in HTML format;
- Is optimized for end-user consultation rather than batch extraction;
- Does not support structured export formats.

This makes large-scale extraction computationally expensive and necessitates automation strategies.

==== Reporting Interfaces

Operational reporting modules provide aggregated views of postal activity, including:

- Daily volume reports;
- Agency-level statistics;
- Destination breakdowns;
- Delivery performance indicators.

Although useful for operational monitoring, these reports suffer from:

- Performance degradation for long time ranges;
- Limited export capabilities;
- Lack of structured APIs;
- Inconsistent data granularity.

=== Absence of Analytical Infrastructure

A key constraint in the data collection process is the absence of a dedicated analytical infrastructure.

Unlike modern data ecosystems that rely on centralized data warehouses, BAM’s systems are primarily oriented toward operational execution. Consequently:

- Data is distributed across multiple systems;
- Historical data is not centralized;
- No unified query layer exists;
- Access is limited to graphical interfaces.

This fragmentation significantly increases the complexity of data extraction and integration @deeng_principles.

=== Data Extraction Strategy

To overcome system limitations, a multi-layer extraction strategy was implemented.

The approach combines:

- Web automation using Playwright for structured reports;
- Sequential scraping of tracking HTML pages;
- Iterative extraction of time-bounded data windows;
- Local persistence of intermediate results.

This strategy ensures:

- Fault tolerance in case of system failure;
- Resumability of long extraction tasks;
- Minimization of load on operational systems;
- Incremental dataset construction.

The extraction process is designed to be idempotent, ensuring that repeated executions do not duplicate previously collected data.

=== Chunked Temporal Extraction

Due to performance limitations in SMI reporting tools, large time ranges cannot be queried reliably. To address this, data extraction is performed using a chunked temporal strategy.

Instead of requesting full historical ranges, the system:

- Splits the timeline into daily or weekly intervals;
- Extracts data incrementally per interval;
- Aggregates results into a unified dataset.

This approach significantly improves stability and reduces the risk of server-side timeouts.

=== Data Collection Pipeline Architecture

The overall architecture of the data collection pipeline is illustrated below.

#figure(
  diagram(
    node-stroke: 1pt,

    node((0, 3), name: <smi>)[SMI System],
    node((2, 3), name: <tracking>)[Tracking Web Interface],
    node((4, 3), name: <reporting>)[Reporting Modules],

    edge(<smi>, <extract>),
    node((2, 2), name: <extract>)[Playwright / RPA Extraction Layer],

    edge(<tracking>, <extract>),
    edge(<reporting>, <extract>),

    node((2, 1), name: <clean>)[Cleaning & Parsing Layer],
    edge(<extract>, <clean>),

    node((2, 0), name: <storage>)[Structured Storage (Parquet)],
    edge(<clean>, <storage>),
  ),
  caption: [End-to-end data collection pipeline],
)

This architecture highlights the role of the extraction layer as a unifying interface between heterogeneous operational systems and analytical storage.

=== Data Quality Constraints

Several data quality constraints were encountered during the extraction process:

- Missing values in dimensional attributes;
- Inconsistent status encoding across systems;
- Duplicate records due to repeated exports;
- HTML structure variability in tracking pages;
- Partial or incomplete historical coverage.

To address these issues, multiple validation steps were integrated into the pipeline, including deduplication, schema enforcement, and consistency checks.

=== Summary

The data collection strategy relies on the integration of multiple heterogeneous systems through automated extraction techniques. Due to the absence of a centralized analytical infrastructure, a custom pipeline based on web automation and incremental extraction was necessary.

This strategy ensures the construction of a consistent and reliable dataset despite operational constraints, forming the foundation for subsequent preprocessing and forecasting tasks.
