#import "@preview/mmdr:0.2.2": mermaid


The final stage of the modeling phase in CRISP-DM consists of assessing the predictive performance of the candidate models and selecting the approaches that are the most suitable for the target application @crispdm. In the context of time-series forecasting, model evaluation requires methodologies that preserve the temporal ordering of observations and mimic realistic forecasting scenarios.

This section presents the validation strategy adopted during the internship, the forecasting horizon considered, and the evaluation metrics used to compare candidate models.


=== Forecasting Horizon

The forecasting horizon adopted in this study is four weeks.

The choice of a short-term horizon was motivated by operational considerations. Discussions with the internship supervisors indicated that forecasts covering approximately one month are sufficiently long to support transportation planning, workload anticipation, and resource allocation decisions, while remaining within a time range where forecasting uncertainty is still manageable.

Consequently,

$
h=4
$

was selected as the prediction horizon for all candidate models.

=== Rolling-Origin Cross-Validation <section_methodology_cv>

Model evaluation was conducted using a rolling-origin cross-validation procedure inspired by the approach described in @hyndman2026forecasting and supported by empirical evidence on the validity of time-series cross-validation for autoregressive forecasting tasks @bergmeir2018note.

#figure(
    image("../../images/time_series_cv_multistep.png"),
    caption: [Rolling-origin cross-validation procedure adopted during model evaluation. (figure adapted from @hyndman2026forecasting)]
) <fig-cross-validation>

@fig-cross-validation illustrates the rolling-origin cross-validation strategy implemented during this internship. Instead of randomly splitting observations into training and testing subsets, successive forecasting exercises are performed by progressively moving the forecasting origin forward through time. This methodology preserves the chronological structure of the data and provides a more realistic assessment of forecasting performance.
For each forecasting exercise, models were trained on the observations available up to a given cutoff date and then used to predict the following four weeks.

The process was repeated over ten evaluation windows.

The main validation parameters are summarized in @tbl-validation-parameters.

#figure(
table(
    columns: (2fr,2fr),

    table.header(
        [Parameter],
        [Value]
    ),

    [Forecast horizon],
    [4 weeks],

    [Number of windows],
    [10],

    [Window step],
    [10 weeks],

    [Evaluation strategy],
    [Rolling-origin cross-validation]
),
caption: [Parameters used for cross-validation.]
) <tbl-validation-parameters>

@tbl-validation-parameters summarizes the configuration adopted for model evaluation. Using multiple validation windows makes it possible to assess model robustness under different demand conditions and reduces the risk of selecting a model that performs well only during a specific period.

=== Evaluation Metrics <section_methodology_eval_metrics>

Several complementary performance indicators were used to compare candidate forecasting models.

Using multiple metrics is recommended because no single indicator can fully characterize forecasting quality @hyndman2026forecasting.

The metrics considered during this internship are described in @tbl-evaluation-metrics.

#figure(
table(
    columns:(1.5fr,3fr),

    table.header(
        [Metric],
        [Interpretation]
    ),

    [MASE],
    [Mean Absolute Scaled Error relative to an in-sample seasonal benchmark],

    [RMAE],
    [Relative Mean Absolute Error compared with the Seasonal Naive model],

    [ND],
    [Normalized Deviation measuring the magnitude of forecast errors],

    [SPIS],
    [Scaled interval score evaluating probabilistic forecasts]
),
caption:[Evaluation metrics used during model comparison.]
) <tbl-evaluation-metrics>

@tbl-evaluation-metrics presents the performance indicators retained in this study. The use of relative metrics such as RMAE facilitates comparisons against the Seasonal Naive baseline, while interval-based measures provide information about forecast uncertainty.

=== Baseline Comparison

The Seasonal Naive model was used as a reference model throughout the evaluation process.

This baseline was selected because preliminary analyses suggested the presence of recurring annual patterns in international mail flows. The seasonal period adopted corresponds approximately to one Hijri year, represented by fifty-one weekly observations.

Relative metrics, particularly RMAE, were computed with respect to this baseline. Values below one indicate an improvement over the Seasonal Naive forecast, whereas values above one suggest inferior predictive performance.

=== Prediction Intervals

In addition to point forecasts, uncertainty estimation was considered whenever supported by the forecasting framework.

For statistical models implemented through StatsForecast, conformal prediction intervals were investigated. In practice, only the MFLES model was able to integrate conformal intervals reliably within the experimental setting adopted during this internship.

The confidence levels considered in preliminary experiments were 80% and 95%.

Although probabilistic forecasting was not the primary objective of the internship, incorporating uncertainty estimates can provide useful information for operational planning, especially during periods characterized by strong demand fluctuations.


=== 2.7.3 Model Comparison Strategy

The objective of the model comparison procedure is to identify forecasting approaches that provide accurate, stable, and operationally relevant predictions for outgoing international mail flows. Since no single performance indicator is sufficient to characterize forecasting quality, candidate models are evaluated according to multiple complementary criteria.

==== Ranking Procedure

Candidate models are evaluated using the rolling-origin cross-validation framework described in @section_methodology_cv. For each validation window, forecasting errors are computed using the metrics presented in @section_methodology_eval_metrics.

Model comparison is primarily based on the average value of each metric over all cross-validation windows. Particular attention is given to the Relative Mean Absolute Error (RMAE), which measures the performance of a model relative to the SeasonalNaive baseline and provides an intuitive interpretation of the forecasting gain obtained by more sophisticated approaches.

The comparison process includes statistical models, machine learning methods, deep learning architectures, and ensemble forecasts. Models are ranked according to their average performance while also considering the consistency of their behavior across validation windows.

==== Ensemble Construction

In addition to evaluating individual models, ensemble forecasts are investigated. Rather than combining all available forecasting approaches, ensembles are constructed within each methodological family by selecting two models exhibiting strong predictive performances and sufficiently different modeling assumptions.

@tbl-ensemble-components summarizes the composition of the ensemble forecasts considered in this study.

#figure(
table(
columns: 2,

table.header(
    [Ensemble], [Components]
),

[stat_ensemble], [AutoARIMA + CES],

[ml_ensemble], [Ridge + CatBoostRegressor],

[neural_ensemble], [BiTCN + NHITS],

),
caption: [Composition of the ensemble forecasting models.]
)
<tbl-ensemble-components>

As shown in @tbl-ensemble-components, ensemble forecasts are generated by averaging the predictions produced by their constituent models. This strategy aims to reduce the influence of individual model biases, improve forecast stability, and exploit complementary forecasting behaviors while maintaining a relatively simple implementation.

==== Final Model Selection Criteria

The selection of the final forecasting approach is not solely based on minimizing a single error metric. Several aspects are jointly considered during the decision process, including:

- Average forecasting accuracy;
- Stability across validation windows;
- Ability to benefit from larger training datasets;
- Compatibility with hierarchical reconciliation procedures;
- Ease of integration into the proposed forecasting pipeline;
- Suitability for operational deployment and visualization.

The combination of these criteria makes it possible to identify models that not only achieve competitive predictive performances but also satisfy the practical constraints associated with operational use within Barid Al-Maghrib.


The evaluation framework described in this section was applied consistently to all forecasting approaches. The resulting performance comparisons and model selection process are presented in @chapter_realization.