
This chapter presented the methodological framework adopted in this internship following a CRISP-DM-oriented structure adapted to the specific constraints of postal data forecasting.

The business understanding phase clarified the operational context of outgoing international mail flows and highlighted the need for short-term forecasting to support capacity planning and logistics optimization. The problem was formalized as a multi-step time-series forecasting task with a fixed horizon of four weeks.

The data understanding and preparation phases detailed the construction of a structured dataset from heterogeneous operational sources. Particular attention was given to the hierarchical nature of the data, requiring aggregation across multiple levels such as deposit centers and destination countries. Due to the absence of a dedicated analytical infrastructure, significant effort was required to reconstruct consistent historical time series from operational systems.

The modeling strategy introduced a multi-paradigm forecasting framework combining statistical models, machine learning approaches, and deep learning architectures. All models were trained under a unified experimental protocol to ensure comparability. Hierarchical reconciliation was introduced to guarantee coherence between forecasts at different aggregation levels.

The evaluation methodology was based on rolling-origin cross-validation, ensuring a realistic simulation of operational forecasting conditions. Multiple complementary metrics were used to assess both accuracy and robustness of the candidate models.

Finally, the operationalization layer defined how forecasts are generated, reconciled, and structured into a unified output format. An interactive visualization system based on Altair was also designed to enable exploratory analysis and support interpretation of results.

The following chapter presents the implementation details of the system, including data engineering pipelines, model training procedures, and the integration of hierarchical forecasting and visualization components into a complete end-to-end workflow.