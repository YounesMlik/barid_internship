Barid Al-Maghrib (BAM) is the national postal operator of Morocco and plays a central role in the provision of postal, logistics, financial, and digital services throughout the country. Through its extensive network and international partnerships, the organization manages large volumes of mail and parcel flows whose efficient handling is essential to maintaining service quality and operational performance.

Like many historical postal operators, BAM is currently engaged in a digital transformation process aimed at improving operational efficiency, increasing shipment traceability, and progressively adopting data-driven decision-making practices. Despite the availability of significant amounts of operational data, existing information systems remain primarily designed for transaction processing, shipment tracking, and operational reporting. Consequently, forecasting capabilities are not natively integrated into these systems, limiting the ability to anticipate future demand and support proactive planning activities.

This internship was carried out within BAM as part of the requirements for obtaining an engineering degree. A previous internship experience within the organization provided an initial exposure to its operational environment and information systems. This experience, combined with an interest in data engineering and predictive analytics, motivated the decision to pursue a second internship within the same institution and to address a more technically challenging problem involving large-scale data extraction and forecasting.

The central problem addressed in this internship is the absence of a forecasting framework capable of exploiting historical operational data to anticipate outgoing international mail volumes over short planning horizons. Existing planning activities rely mainly on descriptive reports and historical observations, making it difficult to proactively allocate resources, anticipate workload fluctuations, and optimize logistics operations.

The objective of this work is therefore to design and implement an end-to-end forecasting pipeline adapted to the constraints of BAM's information systems. More specifically, the study aims to:

- reconstruct historical shipment series from operational systems;
- develop a reproducible data preparation workflow;
- investigate statistical, machine learning, and deep learning forecasting approaches;
- evaluate forecasting performance using rolling-origin cross-validation;
- generate coherent forecasts across multiple aggregation levels through hierarchical reconciliation;
- provide an interactive visualization interface enabling users to explore and compare forecasting results.

More broadly, this internship seeks to demonstrate how modern data engineering practices and time-series forecasting techniques can be leveraged to bridge the gap between legacy operational information systems and data-driven decision-support tools.

The remainder of this report is organized as follows. @chapter_host_institution introduces Barid Al-Maghrib, its international mail activities, information systems, and the internship context. @chapter_methodology presents the methodology adopted in this study following an adaptation of the CRISP-DM framework to the postal forecasting problem, covering data preparation, model development, evaluation procedures, and operationalization aspects. @chapter_realization describes the implementation of the proposed solution, discusses the experimental results, and presents the interactive visualization system developed to facilitate forecast exploration and support operational decision-making.
