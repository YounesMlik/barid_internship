#heading(level: 2, numbering: none)[Context]

The postal sector has undergone significant changes over the last decade. The rapid growth of electronic commerce, the increasing expectations of customers regarding delivery times, and the widespread adoption of digital technologies have considerably transformed postal activities worldwide. Postal operators are now required to handle larger and more volatile parcel volumes while maintaining high levels of service quality and operational efficiency.

In Morocco, Barid Al-Maghrib (BAM) is the public operator responsible for providing postal services throughout the national territory and ensuring exchanges with international postal networks. In addition to traditional mail services, BAM manages a large volume of domestic and international parcels through its operational and logistics infrastructure. Among these activities, outgoing international mail represents an important segment due to its direct dependence on customer demand, commercial exchanges, seasonal events, and the mobility of the Moroccan diaspora.

The management of these flows relies on several information systems that support operational activities such as shipment registration, tracking, routing, and reporting. Although these systems contain a significant amount of historical information, they were primarily designed to facilitate day-to-day operations and not to support analytical studies or forecasting tasks. Consequently, exploiting these data for decision-making purposes requires substantial efforts in terms of extraction, cleaning, and transformation.

It is within this context that this internship was carried out at Barid Al-Maghrib, with a particular focus on the analysis and forecasting of Morocco's outgoing international mail flows.


#heading(level: 2, numbering: none)[Motivation]

This internship was chosen because it provides an opportunity to apply concepts acquired during the academic curriculum in a real industrial environment while addressing a practical problem faced by a national public institution.

The project combines several areas covered during the training program, including data engineering, automation, statistical analysis, machine learning, time series forecasting, and web application development. It also offers the possibility of working with large operational datasets, understanding the constraints associated with legacy information systems, and developing solutions that may support operational decision-making.

Furthermore, conducting the internship within Barid Al-Maghrib allowed for gaining insight into the functioning of postal logistics processes and understanding the challenges related to the digital transformation initiatives currently undertaken by the institution.


#heading(level: 2, numbering: none)[Problem Statement]

Anticipating future international mail volumes is important for improving transportation planning, optimizing resource allocation, and ensuring the continuity of postal services. However, producing reliable forecasts requires access to historical operational data that accurately describe the evolution of postal activity over time.

At Barid Al-Maghrib, obtaining such data presents several difficulties. The operational information systems do not provide documented programming interfaces, some reporting modules become unstable when queried over extended periods, and shipment tracking information is only accessible through interfaces intended for individual consultations. As a result, collecting and consolidating the information necessary for forecasting cannot be achieved using conventional analytical workflows.

The problem addressed during this internship can therefore be formulated as follows:

How can the operational data available within Barid Al-Maghrib be automatically collected, processed, and exploited to build reliable forecasting models capable of predicting Morocco's outgoing international mail activity and providing useful indicators for operational planning?

Addressing this question involves not only selecting appropriate forecasting techniques but also overcoming the challenges associated with data acquisition, preparation, and validation.


#heading(level: 2, numbering: none)[Objectives]

The main objective of this internship is to develop a data-driven framework for analyzing and forecasting Morocco's outgoing international mail flows.

More specifically, the work aims to:

- Study the organizational environment of Barid Al-Maghrib and its international postal activities.
- Identify the data sources relevant to the forecasting task.
- Design automated procedures for extracting information from existing information systems.
- Build analytical datasets by cleaning, validating, and consolidating the collected data.
- Explore historical trends and identify the main characteristics of outgoing international mail traffic.
- Implement and compare several time series forecasting methods.
Evaluate forecasting performance using rolling cross-validation techniques and suitable accuracy metrics.
- Estimate forecast uncertainty through prediction intervals.
- Develop a lightweight web-based interface to facilitate the consultation of historical data, forecasts, and selected performance indicators.
Report Outline

This report is organized into three chapters.

The first chapter presents the host institution and the context of the internship. It introduces Barid Al-Maghrib, describes its international mail activities and information systems, and formulates the problem addressed during the internship.

The second chapter details the methodology adopted throughout the study. It presents the data collection strategy, preprocessing procedures, exploratory analyses, forecasting methods, model evaluation techniques, and the design choices associated with the proposed decision-support interface.

The third chapter focuses on the realization of the project. It describes the implementation of the automated data acquisition pipeline, the construction of forecasting datasets, the obtained forecasting results, and the development of the web application intended to visualize historical trends, future estimates, and operational indicators.
