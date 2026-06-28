#import "@preview/mmdr:0.2.2": mermaid


This section defines the operational context and objectives of the forecasting task addressed in this internship. In accordance with the CRISP-DM methodology @crispdm, the Business Understanding phase aims to translate an industrial need into a formal data science problem that can be addressed using statistical and machine learning methods.

In the context of Barid Al-Maghrib, the main operational objective is the ability to anticipate fluctuations in outgoing international mail flows. These flows are directly influenced by a combination of structural and seasonal factors, including e-commerce activity, diaspora-related demand, and logistics constraints affecting international transport capacity.

Unlike standard prediction problems in controlled environments, postal demand forecasting is constrained by operational realities such as limited storage capacity in sorting centers, variability in international transport schedules, and heterogeneous behavior across destinations. These constraints require forecasts that are not only accurate, but also stable and interpretable from an operational perspective.

The operational scope of international mail forecasting is summarized in @fig-business-scope, which presents the main factors influencing outgoing international mail demand and their impact on planning activities.

#figure(
  mermaid(
    "
    graph TB

    E[E-commerce Activity]
    D[Moroccan Diaspora]
    R[Religious and Seasonal Events]
    T[International Transport Availability]
    C[Competition]
    O[Operational Capacity]

    F[Outgoing International Mail Flows]

    E --> F
    D --> F
    R --> F
    T --> F
    C --> F

    F --> O

    O --> P[Transport Planning]
    O --> W[Workforce Allocation]
    O --> S[Service Quality]"
  ),
  caption: [Main factors influencing outgoing international mail flows and their operational implications.]
) <fig-business-scope>

@fig-business-scope shows that outgoing international mail volumes are affected by both internal and external factors. Demand-side drivers such as e-commerce activity, diaspora-related shipments, and seasonal events contribute to fluctuations in mail volumes, while supply-side constraints including transport availability and customs procedures influence the operator's ability to process these flows efficiently. Anticipating these variations is therefore essential for improving transport planning, workforce allocation, and maintaining service quality.