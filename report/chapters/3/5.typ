#import "@preview/mmdr:0.2.2": mermaid
#import "@preview/zebraw:0.6.3": *
#show: zebraw


This section describes the implementation of the hierarchical forecasting layer used to ensure consistency between forecasts produced at different aggregation levels. The system follows a structured pipeline combining bottom-level prediction generation and top-down reconciliation.

=== Hierarchical Structure in the Data

The forecasting problem is defined over a hierarchical structure composed of multiple aggregation levels:

- total international outgoing mail flow;
- center-level series (Centre_Agence_depot);
- destination-level series (Destination);
- cross-level combinations (center × destination).

Each level represents a different granularity of the same underlying process, which introduces coherence constraints between forecasts.

This structure is explicitly encoded through composite identifiers of the form:

$
  "unique_id" = "Centre_Agence_depot" times "Destination"
$

The hierarchical structure is summarized in @fig-hierarchy.

#figure(
  mermaid(
    "
flowchart TD

A[Total Series]
B[Center Level]
C[Destination Level]
D[Center × Destination Level]

A --> B
A --> C
B --> D
C --> D
",
  ),
  caption: [Hierarchical structure of international mail time series.],
) <fig-hierarchy>

@fig-hierarchy illustrates the aggregation relationships between different levels of the forecasting hierarchy. The bottom level contains the most granular information, while higher levels represent aggregated views.

=== Bottom-Level Forecast Generation

All forecasting models (statistical, machine learning, and neural) are initially trained at the most granular level of the hierarchy.

Let:

$
  hat(y)_(i,t+h)
$

represent the forecast for series $i$ at horizon $h$.

Each bottom-level forecast is later aggregated to higher levels before reconciliation.


=== Forecast Completion and Alignment

Before reconciliation, forecast outputs must be aligned with the hierarchical structure expected by the reconciliation procedure.

Some forecasting models only produce predictions for the aggregate international series, whereas reconciliation requires forecasts to be available for all nodes of the hierarchy and for every forecast horizon. Consequently, an intermediate completion step was implemented.

This procedure generates the full set of required identifier--timestamp combinations and aligns model outputs accordingly. Missing values are initialized to zero, since the subsequent Top-Down reconciliation step redistributes the aggregate forecasts using historical proportions.

The process is summarized in @fig-completion-step.

#figure(
  placement: auto,
  mermaid(
    "
flowchart TD

A[Model Forecasts]
B[Generation of Full Hierarchical Grid]
C[Forecast Alignment]
D[Completed Forecast Dataset]
E[Top-Down Reconciliation]

A --> B
B --> C
C --> D
D --> E
",
  ),
  caption: [Forecast completion and alignment performed before reconciliation.],
) <fig-completion-step>

As illustrated in @fig-completion-step, the objective of this step is not to estimate additional forecasts, but simply to ensure that the forecast dataset conforms to the structure required by the reconciliation algorithm.

=== Top-Down Reconciliation Strategy

Forecasts are reconciled using a Top-Down proportional allocation strategy implemented through the HierarchicalForecast library.

The core idea is to distribute forecasts from the top level to lower levels based on historical proportions.

Formally:

$
  hat(y)_(i,t+h) = p_i dot hat(y)_("Total", t+h)
$

where:

- $p_i$ is the historical proportion of series $i$;
- $hat(y)_("Total", t+h)$ is the forecast at the root level.

The reconciliation process is illustrated in @fig-reconciliation.

#figure(
  mermaid(
    "
flowchart TD

A[Bottom-Level Forecasts]
B[Top-Level Aggregation]
C[Proportion Computation]
D[Top-Down Allocation]
E[Reconciled Hierarchical Forecasts]

A --> B --> C --> D --> E
",
  ),
  caption: [Top-down hierarchical reconciliation process.],
) <fig-reconciliation>

@fig-reconciliation shows how bottom-level forecasts are adjusted to ensure coherence with higher aggregation levels. This step enforces structural consistency across the hierarchy.

=== Implementation Details

The reconciliation is implemented using the `HierarchicalForecast`@hierarchicalforecast library with a TopDown method based on historical average proportions@top_down_paper.

Key steps include:

- construction of summing matrix $S$;
- definition of hierarchical tags for each series;
- application of reconciliation to model forecasts.

The implementation integrates directly into the pipeline:

#zebraw(```python
recon = HierarchicalReconciliation(
  reconcilers = [TopDown("proportion_averages")]
)
```)

#figure(
  mermaid(
    "
flowchart TD

A[Raw Forecasts (Root Model Output)]
B[Hierarchy Tags]
C[Summing Matrix S]
D[TopDown Reconciler]
E[Final Coherent Forecasts]

A --> D
B --> D
C --> D
D --> E
",
  ),
  caption: [Implementation of hierarchical reconciliation in the forecasting pipeline.],
) <fig-code-recon>

@fig-code-recon illustrates the integration of hierarchical metadata (tags and summing matrix) with model outputs to produce coherent forecasts.

The hierarchical forecasting layer ensures consistency between different aggregation levels of international mail flows. Without this step, independently generated forecasts would violate aggregation constraints and produce incoherent totals.

The combination of bottom-up generation and top-down reconciliation provides a practical compromise between model flexibility and structural correctness.

The next section presents the evaluation methodology used to assess forecasting performance across all model families.
