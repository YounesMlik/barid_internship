This internship was carried out within Barid Al-Maghrib as part of an engineering degree program. The work focused on the analysis and forecasting of outgoing international mail volumes using historical operational data extracted from internal information systems.

The project sits at the intersection of data engineering and applied forecasting. It required both the construction of usable datasets from operational systems and the development of predictive models adapted to the structure and limitations of the available data.

=== Industrial Context

International mail represents a structurally important activity for Barid Al-Maghrib due to the continuous growth of cross-border exchanges. This growth is mainly driven by e-commerce and the volume of shipments linked to Moroccan communities abroad.

In this context, anticipating shipment volumes becomes relevant for operational planning. Variations in demand directly affect transport organization, sorting capacity, and workforce allocation.

The forecasting problem addressed in this internship is therefore not purely analytical; it is tied to practical operational needs related to planning and resource management.

=== Working Environment

The internship was conducted in an environment strongly centered on operational systems. These systems are designed primarily to support shipment processing and tracking rather than analytical exploration.

Several characteristics of this environment shaped the work:

- Data is distributed across multiple interfaces rather than centralized;
- Historical access is limited and often constrained by performance issues;
- Extraction functionalities are designed for manual consultation;
- Reporting tools are oriented toward operational monitoring rather than analysis.

As a result, a significant portion of the internship was dedicated to making the data usable for analytical purposes before any modeling could be performed.

=== Internship Mission

The main objectives of the internship can be summarized as follows:

- Reconstruct historical datasets from operational systems;
- Develop automated procedures for data extraction;
- Clean and structure raw shipment and tracking data;
- Analyze temporal patterns in outgoing international mail flows;
- Build and evaluate forecasting models;
- Compare statistical, machine learning, and deep learning approaches.

These objectives were pursued in an iterative manner, where data preparation and modeling informed each other.

=== Tools and Technologies

The internship relied on a set of tools chosen to handle both data extraction and time-series analysis tasks:

- Python for data processing and model implementation;
- Playwright for automated extraction from web-based systems @playwright;
- Data manipulation libraries for cleaning and transformation tasks;
- Columnar storage formats (Parquet) for efficient handling of large datasets;
- Standard time-series forecasting frameworks for model evaluation.

No dedicated dashboarding or business intelligence layer was used in the scope of this work, as the focus remained on dataset construction and modeling rather than deployment.

=== Data Context

The datasets used in this internship originate mainly from the Système de Messagerie Intégré (SMI) and related operational reporting interfaces.

They include information such as:

- Shipment acceptance dates;
- Destination countries;
- Processing and tracking events;
- Operational status updates;
- Additional attributes used for exploratory analysis.

Access to these data sources was constrained by several limitations:

- Lack of direct programmatic access;
- Limited export capabilities;
- Performance issues over long time intervals;
- Inconsistent historical coverage across modules.

To address these constraints, an extraction pipeline was developed to progressively collect, consolidate, and structure the data into analyzable formats.

=== Position of the Internship

Within Barid Al-Maghrib, this work is positioned as an exploratory analytical effort aimed at reusing operational data for forecasting purposes.

Rather than modifying existing systems, the internship focuses on extracting value from existing infrastructure by transforming operational records into structured time series.

This approach highlights the potential of internal data for supporting planning activities, even when systems were not originally designed for analytical use.

=== Contribution

The main contribution of the internship lies in the development of a complete workflow that connects operational systems to forecasting models.

This workflow includes:

- Automated extraction of shipment data from operational interfaces;
- Transformation and cleaning of raw records;
- Construction of consistent time series;
- Application of multiple forecasting approaches;
- Evaluation of predictive performance across models.

The resulting pipeline demonstrates how operational postal data can be repurposed for analytical and predictive tasks, despite the constraints of legacy information systems.

=== Summary

This internship is situated in a context where operational information systems impose significant constraints on data access and analysis.

Despite these limitations, it was possible to construct structured datasets and apply forecasting techniques to outgoing international mail volumes, providing a basis for better understanding and anticipating shipment dynamics.
