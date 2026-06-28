#import "@preview/mmdr:0.2.2": mermaid


This chapter presents the methodological framework adopted to address the forecasting problem defined in @chapter_host_institution. The approach is based on the CRISP-DM process model @crispdm, adapted to the constraints of Barid Al-Maghrib’s operational information systems and to the specific requirements of hierarchical time-series forecasting.

In classical data science applications, CRISP-DM assumes the availability of structured and centralized datasets. In the present context, however, the data originates from operational postal systems originally designed for transaction processing rather than analytical use. This leads to fragmented data sources, heterogeneous interfaces, and limited direct access to structured historical datasets.

To address these constraints, the methodology implemented in this internship defines a complete pipeline covering data extraction, hierarchical dataset construction, feature engineering, model development across multiple forecasting paradigms, reconciliation of hierarchical outputs, and evaluation using time-series cross-validation. A final deployment-oriented component is also introduced through an interactive visualization layer built with Altair, enabling exploration and interpretation of forecasting results in an operational context.

The global structure of this pipeline is summarized in @fig-pipeline-overview.
