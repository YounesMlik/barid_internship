#import "@preview/mmdr:0.2.2": mermaid
#import "@preview/zebraw:0.6.3": *
#show: zebraw


This section presents the implementation of the forecasting models used in this internship. The system follows a multi-paradigm strategy combining statistical, machine learning, and neural forecasting approaches.

All models are trained on the same hierarchical dataset and evaluated under a unified cross-validation framework to ensure comparability. The implementation is designed to reflect the modeling strategy defined in @section_methodology_modeling_strategy.

=== Statistical Models

Statistical models are used as interpretable baselines and as robust references for comparison against more complex approaches. They rely on explicit assumptions about temporal structure such as seasonality, trend, and autocorrelation.

The statistical modeling family used in this study is summarized in @fig-stat-models.

#figure(
  mermaid(
    "
flowchart TD

A[Time Series Input]
B[Statistical Models]

B1[Seasonal Naive]
B2[ETS / AutoETS]
B3[ARIMA / AutoARIMA]
B4[CES]
B5[Theta]
B6[TBATS]
B7[MFLES]

A --> B
B --> B1
B --> B2
B --> B3
B --> B4
B --> B5
B --> B6
B --> B7
",
  ),
  caption: [Statistical forecasting model family used in StatsForecast.],
) <fig-stat-models>

@fig-stat-models shows the diversity of statistical models used in the system, ranging from simple seasonal baselines to more advanced decomposition-based approaches. These models serve as strong benchmarks for evaluating the added value of machine learning and neural methods.

The implementation is based on the StatsForecast framework:

#zebraw(```python
sf = StatsForecast(
  freq = "1w",
  n_jobs = -1,
  models = [
    SeasonalNaive(season_length = hijri_year_weeks),
    AutoETS(model = "AAA", damped = true),
    AutoARIMA(season_length = hijri_year_weeks),
    AutoCES(season_length = hijri_year_weeks),
    AutoMFLES(season_length = hijri_year_weeks),
    AutoTBATS(season_length = hijri_year_weeks),
    AutoTheta(season_length = hijri_year_weeks)
  ]
)
```)

The models are trained on the full historical dataset and used both for forecasting and cross-validation evaluation.

The inclusion of multiple statistical models is motivated by their strong performance on structured seasonal data. In particular, models such as ETS and seasonal naive often remain competitive in short-horizon forecasting tasks, especially when data is noisy or limited.

In the observed results (@section_realization_eval_results), statistical models typically provide a stable baseline but are gradually outperformed by machine learning and neural approaches as more historical data becomes available and feature richness increases. This behavior is particularly visible when comparing cross-validation scores across cutoff dates.

=== Machine Learning Models

Machine learning models reformulate forecasting as a supervised regression problem using lagged features and engineered predictors. These models are implemented using the MLForecast framework.

The machine learning model family is summarized in @fig-ml-models.

#figure(
  mermaid(
    "
flowchart TD

A[Lagged Feature Matrix]
B[Linear Models]
C[Tree-Based Models]

B1[Linear Regression]
B2[Ridge / Lasso / ElasticNet]
B3[ARD / Tweedie]

C1[HistGradientBoosting]
C2[XGBoost]
C3[LightGBM]
C4[CatBoost]

A --> B
A --> C
B --> B1
B --> B2
B --> B3
C --> C1
C --> C2
C --> C3
C --> C4
",
  ),
  caption: [Machine learning forecasting models implemented via MLForecast.],
) <fig-ml-models>

@fig-ml-models illustrates the separation between linear and non-linear model families. Linear models provide interpretability and stability, while gradient-boosted trees capture nonlinear interactions between lag features and seasonal patterns.

The implemented configuration is:

#zebraw(```python
fcst = MLForecast(
  models = [
    LinearRegression(),
    ElasticNet(),
    ARDRegression(),
    TweedieRegressor(),
    Lasso(),
    Ridge(),
    HistGradientBoostingRegressor(),
    LGBMRegressor(random_state = 1),
    XGBRegressor(random_state = 1),
    CatBoostRegressor(random_state = 1)
  ],
  freq = "weekly",
  lags = [1, 2, 3, 4, seasonality]
)
```)

All models share the same feature set, including lag variables and a deterministic trend component. This ensures that performance differences reflect model capacity rather than feature availability.


=== Neural Models

Neural forecasting models are used to capture nonlinear temporal dependencies directly from sequential input windows. In the final implementation of this internship, only two architectures are retained: BiTCN and NHITS, both implemented using the NeuralForecast framework.

This choice was motivated by empirical stability during training and consistent performance under cross-validation compared to alternative neural architectures (e.g., LSTM or generic MLP), which were evaluated but not retained in the final pipeline.
The retained neural architectures are summarized in @fig-neural-models.

#figure(
  mermaid(
    "
flowchart TD

A[Input Windows (Time Series)]

B[Neural Forecasting Models]

B1[BiTCN]
B2[NHITS]

A --> B
B --> B1
B --> B2
",
  ),
  caption: [Final neural forecasting models used in the internship (BiTCN and NHITS).],
) <fig-neural-models>

@fig-neural-models shows that the final neural layer of the system is intentionally reduced to two architectures. This simplification improves interpretability of results and reduces variance introduced by unstable training runs.


The final neural configuration is:

#zebraw(```python
nf = NeuralForecast(
  models = [
    AutoBiTCN(h = 4),
    AutoNHITS(h = 4),
  ],
  freq = "W"
)
```)

Both models operate on the same preprocessed time series representation and share the same forecasting horizon and evaluation protocol as all other model families.
In practice, the restricted neural configuration provides a better trade-off between complexity and robustness.

BiTCN captures local temporal dependencies through convolutional filters, while NHITS provides a hierarchical decomposition of the signal across multiple temporal resolutions. This complementarity was sufficient to cover the nonlinear patterns observed in international mail flows without introducing unnecessary model redundancy.