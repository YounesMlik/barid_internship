#import "@preview/mmdr:0.2.2": mermaid
#import "@preview/zebraw:0.6.3": *
#show: zebraw


This section presents the results obtained from the rolling-origin cross-validation procedure described in Section 2.7. The objective is to compare the forecasting performance of the different candidate models under realistic operational conditions and identify the approaches best suited for predicting outgoing international mail flows.

All models are evaluated using the same cross-validation configuration and the same transformed training data. Predictions are inverse-transformed before metric computation to ensure that evaluation is performed on the original scale of the series.

The metrics considered are:

- Mean Absolute Scaled Error (MASE);
- Relative Mean Absolute Error (RMAE);
- Scaled Pinball Score (SPIS);
- Normalized Deviation (ND).

These metrics provide complementary information regarding forecast accuracy, robustness, and improvement over baseline methods.

=== Cross-Validation Configuration

The evaluation framework is based on rolling-origin cross-validation. Successive training windows are created by progressively extending the available history while preserving a fixed forecasting horizon.

The configuration adopted in this study is summarized in @tbl-cv-config.

#figure(
table(
columns: (2fr,1fr),

table.header(
[Parameter],
[Value]
),

[Forecast horizon],
[4 weeks],

[Number of windows],
[10],

[Step size],
[10 weeks],

[Frequency],
[Weekly],

[Baseline model],
[Seasonal Naive]
),
caption: [Cross-validation configuration.]
) <tbl-cv-config>

@tbl-cv-config presents the experimental protocol used for all forecasting models. Using an identical configuration ensures that performance differences can be attributed to the models themselves rather than to differences in the evaluation procedure.

=== Global Model Comparison

Forecasting performance was first analyzed by averaging evaluation metrics over all cross-validation windows.

The results are presented in @tbl-global-results.

#figure(
table(
columns: (2fr,1fr,1fr,1fr,1fr),

table.header(
[Model],
[MASE],
[RMAE],
[SPIS],
[ND]
),

// Fill with actual results

),
caption:[Average forecasting performance over all cross-validation windows.]
) <tbl-global-results>

@tbl-global-results summarizes the overall ranking of candidate models. The final interpretation of these results will depend on the values obtained during experimentation.

Particular attention is given to improvements over the Seasonal Naive baseline, as this model provides a strong reference for highly seasonal postal demand.

=== Performance Evolution Across Training History

In addition to average metrics, model performance was analyzed as a function of the cutoff date used during cross-validation.

This analysis makes it possible to observe how models benefit from the gradual accumulation of historical data.

The evolution of forecasting accuracy is illustrated in @fig-rmae-cutoff.

#figure(
image("../../images/rmae_by_cutoff.svg"),
caption: [Evolution of forecasting accuracy over successive cross-validation windows.]
) <fig-rmae-cutoff>

@fig-rmae-cutoff shows the evolution of model performance as additional observations become available. A noticeable trend observed during experimentation is that simpler models often perform competitively during the earliest windows, when limited training data is available.

As the amount of historical information increases, more complex approaches, particularly machine learning and neural models, tend to improve their relative performance. This behavior suggests that these models require a sufficiently long historical context to effectively exploit nonlinear temporal patterns.

This observation partly explains the coexistence of statistical, machine learning, and deep learning approaches within the proposed forecasting framework.

=== Discussion of Results

The evaluation demonstrates that no single forecasting paradigm dominates under all conditions.

Statistical models provide robust and interpretable baselines, especially in low-data scenarios. Machine learning models leverage engineered lag features to capture nonlinear relationships, while neural architectures offer increased modeling capacity when enough training observations are available.

The hierarchical reconciliation stage does not aim to improve point accuracy directly. Its purpose is to guarantee coherence between forecasts generated at different aggregation levels, thereby increasing their operational usability.

The next section presents examples of generated forecasts and discusses their practical interpretation.