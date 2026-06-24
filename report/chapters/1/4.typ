This internship was carried out within Barid Al-Maghrib (BAM) as part of the requirements for completing an engineering degree. The work focused on the analysis and forecasting of outgoing international mail volumes using historical operational data extracted from the information systems used within the institution.

The internship provided an opportunity to apply data engineering, exploratory analysis, and time-series forecasting techniques to a real operational use case while taking into account the constraints imposed by existing information systems.

=== Industrial Context of the Internship

International postal activities represent an important operational domain for Barid Al-Maghrib due to the increasing volume of cross-border exchanges associated with e-commerce and shipments exchanged with Moroccan communities residing abroad.

Efficient management of these flows requires anticipating variations in shipment volumes in order to improve transportation planning, optimize resource allocation, and maintain service quality.

Within this context, forecasting outgoing international mail volumes constitutes a relevant decision-support problem, particularly during periods characterized by significant demand fluctuations.

=== Internship Department and Environment

The internship was conducted in an environment closely related to the management and exploitation of postal operational data.

Several characteristics of the working environment influenced the organization of the project:

- Use of operational information systems initially designed for transaction processing;
- Distribution of information across multiple interfaces;
- Limited availability of analytical tools;
- Dependence on reporting modules for historical consultations;
- Constraints related to data extraction and long query execution times.

A significant part of the internship was therefore dedicated to acquiring, consolidating, and preparing historical data before applying forecasting techniques.

=== Internship Mission

The objectives assigned during the internship can be summarized as follows:

- Study historical outgoing international mail flows;
- Extract and consolidate data from available operational systems;
- Develop an automated collection pipeline;
- Perform exploratory analysis to identify trends, seasonality, and anomalies;
- Implement forecasting models;
- Evaluate forecasting performance using statistical indicators.

The overall objective was to assess the feasibility of predicting shipment volumes from historical observations and to provide tools that could support operational planning activities.

=== Tools and Technologies Used

Several technologies were used during the internship for data extraction, processing, and analysis.

The main tools employed include:

- Python for data processing and model implementation;
- Playwright for browser automation and data extraction @playwright;
- Pandas for data manipulation and preprocessing;
- Apache Parquet for efficient storage of processed datasets;
- Time-series analysis and forecasting libraries;
- Notebook-based environments for experimentation and model evaluation.

These technologies were selected because they allowed the automation of repetitive tasks and facilitated the handling of large historical datasets.

=== Data Context and Availability

The data used during the internship originated primarily from the Système de Messagerie Intégré (SMI) and associated reporting interfaces.

The collected information included:

- Shipment acceptance dates;
- Destination countries;
- Operational status updates;
- Routing information;
- Additional attributes useful for exploratory analysis.

Several constraints were encountered during the data acquisition phase, including:

- Limited export functionalities;
- Absence of direct programmatic access;
- Variability in historical coverage;
- Performance limitations when querying large time intervals.

These constraints required the implementation of preprocessing procedures and automated extraction mechanisms to obtain datasets suitable for time-series modeling.

=== Position of the Internship within BAM Activities

The internship is directly related to the exploitation of operational postal data for analytical purposes.

While existing systems mainly support the execution and monitoring of postal activities, the work carried out during the internship aimed to reuse historical data in order to study shipment dynamics and evaluate forecasting approaches.

The project therefore contributes to:

- Structuring historical operational datasets;
- Facilitating quantitative analysis of international mail flows;
- Providing indicators that may assist planning activities;
- Demonstrating the potential of predictive methods applied to postal operations.

=== Contributions of the Internship

The work performed during the internship resulted in the development of a workflow covering the different stages required for postal flow forecasting.

This workflow includes:

- Automated data collection;
- Data cleaning and preparation;
- Exploratory analysis of historical trends;
- Development and evaluation of forecasting models.

Beyond the forecasting results themselves, the internship also highlighted the importance of data engineering activities when working with operational information systems that were not originally designed for analytical use.

=== Summary

This internship was conducted in an operational environment where information system constraints significantly influenced data availability and accessibility.

Despite these limitations, the project made it possible to apply data engineering and time-series forecasting techniques to real postal data and to assess their potential contribution to improving the analysis and anticipation of outgoing international mail volumes.
