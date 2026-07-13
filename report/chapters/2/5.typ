#import "@preview/mmdr:0.2.2": mermaid


The forecasting system developed during this internship was designed around a modular architecture allowing several modeling paradigms to be evaluated under comparable conditions. This organization facilitates benchmarking while maintaining a common preprocessing and evaluation pipeline.

The overall structure of the modeling layer is summarized in @fig-modeling-architecture.

#figure(
  mermaid(
    "flowchart LR

A[Prepared Weekly Series]

A --> B[Statistical Models]
A --> C[Machine Learning Models]
A --> D[Deep Learning Models]

B --> E[Forecasts]
C --> E
D --> E

E --> F[Hierarchical Reconciliation]

F --> G[Cross-validation]
F --> H[Operational Forecasts]",
  ),
  caption: [Global architecture of the forecasting layer.],
) <fig-modeling-architecture>

@fig-modeling-architecture illustrates the organization adopted for model development. The prepared time series are provided to three complementary families of forecasting methods. The generated forecasts are subsequently reconciled across hierarchical levels and assessed using a common evaluation framework. This approach allows performance comparisons to focus on differences in modeling assumptions rather than discrepancies introduced during preprocessing.

The forecasting methods evaluated during this internship are summarized in @tbl-model-overview.

#figure(
table(
columns:(2fr,2fr,4fr),

table.header(
[Model],
[Family],
[Description],
),

[Seasonal Naive],
[Baseline],
[Seasonal benchmark based on historical repetition],

[AutoETS],
[State-space],
[Automatic exponential smoothing state-space model],

[AutoCES],
[State-space],
[Complex exponential smoothing model],

[AutoARIMA],
[Autoregressive],
[Automatic seasonal autoregressive integrated moving average model],

[AutoTBATS],
[Autoregressive],
[Trigonometric decomposition model for complex seasonal patterns],

[AutoTheta],
[Decomposition],
[Theta decomposition forecasting approach],

[AutoMFLES],
[Ensemble smoothing],
[Multi-feature local ensemble smoothing model],

[LinearRegression],
[Linear ML],
[Ordinary least squares regression],

[Ridge],
[Linear ML],
[L2-regularized linear regression],

[Lasso],
[Linear ML],
[L1-regularized linear regression],

[ElasticNet],
[Linear ML],
[Combined L1/L2 regularization],

[ARDRegression],
[Bayesian ML],
[Automatic relevance determination regression],

[TweedieRegressor],
[Generalized linear model],
[Tweedie-distributed regression],

[HistGradientBoostingRegressor],
[Boosting ML],
[Histogram-based gradient boosting trees],

[LGBMRegressor],
[Boosting ML],
[Light Gradient Boosting Machine],

[XGBRegressor],
[Boosting ML],
[Extreme Gradient Boosting],

[CatBoostRegressor],
[Boosting ML],
[Gradient boosting with ordered boosting],

[NHITS],
[Deep Learning],
[Neural hierarchical interpolation model],

[BiTCN],
[Deep Learning],
[Bidirectional temporal convolutional network],

),
caption:[Forecasting models evaluated during the internship.]
)<tbl-model-overview>

@tbl-model-overview illustrates the diversity of forecasting paradigms considered in this work. In addition to traditional statistical methods, several machine learning and deep learning approaches were investigated to assess their suitability for modeling international postal flows.

=== Baseline Models

A baseline model is necessary to determine whether more sophisticated approaches provide a meaningful improvement in predictive accuracy. In time-series forecasting, simple benchmarks are often difficult to outperform, particularly when seasonality is present @hyndman2026forecasting.

Among the models summarized in @tbl-model-overview, the Seasonal Naive model was selected as the baseline forecasting approach.

The Seasonal Naive approach assumes that future observations repeat the behavior observed during the previous seasonal cycle. Given the characteristics identified during exploratory analyses, a seasonal period corresponding approximately to one Hijri year was adopted.

Formally, the Seasonal Naive forecast is expressed as:

$
hat(y)_(t+h)=y_(t+h-m)
$

where:

- $m$ denotes the seasonal period;
- $h$ is the forecasting horizon.

This model serves two purposes. First, it establishes a minimum acceptable level of forecasting performance. Second, it is used as a reference in relative evaluation metrics such as Relative Mean Absolute Error (RMAE).

=== Statistical Forecasting Models

Statistical forecasting methods remain widely used in industrial applications due to their robustness, interpretability, and relatively low computational requirements @hyndman2026forecasting.

Several automated statistical models available through the StatsForecast framework @statsforecast were considered in this study.


==== State-space models

State-space methods represent observations through latent components describing the evolution of level, trend, and seasonality. Their recursive estimation procedures allow model parameters to adapt efficiently to changing dynamics while maintaining relatively low computational costs.

===== AutoETS

The Exponential Smoothing State Space (ETS) framework models observations as combinations of error, trend, and seasonal components estimated within a state-space formulation @hyndman2002state. The AutoETS implementation automatically searches among admissible model configurations and selects the most appropriate specification according to information criteria.

ETS models are widely regarded as strong benchmarks in business forecasting applications because they provide interpretable decompositions while remaining computationally efficient. Their ability to accommodate trend and seasonal variations motivated their inclusion in this comparative study.

===== AutoCES

Complex Exponential Smoothing (CES) extends traditional exponential smoothing methods by representing cyclical behavior through complex-valued states @svetunkov2022complex.

Compared with conventional ETS formulations, CES can better accommodate oscillatory dynamics and evolving seasonal structures. Although it remains less widely adopted in industrial forecasting systems, its recent development and promising empirical performance motivated its inclusion as an exploratory statistical model.

==== Autoregressive models

Autoregressive approaches explain future observations as functions of lagged values and previous forecast errors. These methods explicitly characterize temporal dependence structures and remain among the most widely used forecasting techniques.

===== AutoARIMA

AutoARIMA automatically identifies suitable autoregressive, differencing, and moving-average orders through an optimization procedure based on information criteria @box2015time @hyndman2008automatic.

By incorporating seasonal components, AutoARIMA can capture persistent temporal dependencies and recurring patterns observed in historical observations. Due to its strong theoretical foundation and widespread industrial use, it was included as a reference statistical approach.

===== AutoTBATS

TBATS combines trigonometric seasonal representations, Box-Cox transformations, autoregressive error corrections, and damped trend components within a unified framework @delivera2011forecasting.

The method was originally designed to model complex and multiple seasonal structures. Although the present study primarily considered a single annual seasonal pattern approximated by the Hijri calendar, AutoTBATS was retained because of its flexibility in representing non-standard seasonal behaviors.

==== Decomposition models

Decomposition approaches attempt to separate a time series into simpler latent components before extrapolating their future evolution.

===== AutoTheta

The Theta method decomposes a time series into modified versions referred to as Theta lines, which are subsequently extrapolated and recombined to generate forecasts @assimakopoulos2000theta.

The method achieved notable success in forecasting competitions and is often recognized for providing competitive predictive performance despite its conceptual simplicity. AutoTheta was therefore included as a robust decomposition-based benchmark.

==== Ensemble smoothing models

Ensemble smoothing methods attempt to combine the robustness of classical smoothing procedures with greater flexibility in adapting to local changes in the observed dynamics.

===== AutoMFLES

AutoMFLES is a recently proposed forecasting approach that combines smoothing techniques with local feature extraction mechanisms to improve responsiveness to changing patterns @blume2024mfles.

Given its relatively recent introduction and limited evaluation in postal forecasting contexts, AutoMFLES was incorporated primarily as an exploratory candidate aimed at assessing whether more flexible smoothing strategies could provide additional forecasting gains.



=== Machine Learning Forecasting Models

Unlike statistical forecasting methods, machine learning approaches do not rely on explicit assumptions regarding the underlying stochastic process generating the observations. Instead, they learn relationships between engineered explanatory variables and future values directly from historical data.

Machine learning models were implemented using the MLForecast framework @mlforecast, which provides a unified interface for feature generation, model training, and forecasting. All models were trained using the feature engineering pipeline described in @section_methodology_feature_engineering, including lagged observations and trend indicators.

The machine learning models considered in this study can be grouped into linear models, Bayesian regression models, generalized linear models, and gradient boosting approaches.

==== Linear models

Linear models remain attractive forecasting methods because they are computationally efficient, highly interpretable, and often provide surprisingly competitive performance when combined with carefully engineered features.

===== LinearRegression

LinearRegression estimates model parameters using ordinary least squares (OLS), minimizing the residual sum of squares between observed and predicted values. Despite its simplicity, linear regression often constitutes a strong baseline in forecasting problems where temporal dependencies can be effectively represented through lagged variables and rolling statistics.

Its inclusion in this study aimed to assess the predictive value of the engineered features independently of more sophisticated regularization or nonlinear modeling techniques.

===== Ridge

Ridge regression extends ordinary least squares by introducing an L2 regularization penalty that shrinks regression coefficients toward zero, thereby reducing variance and mitigating overfitting. @hoerl1970ridge

This regularization mechanism is particularly useful when explanatory variables exhibit strong collinearity, as is frequently the case in time series forecasting applications involving multiple lagged features and moving averages.

Among the machine learning approaches evaluated during this internship, Ridge regression demonstrated consistently strong predictive performance and emerged as one of the most competitive models within its category.

===== Lasso

Lasso regression incorporates an L1 regularization penalty that encourages sparse solutions by driving some regression coefficients exactly to zero. @tibshirani1996lasso

This property allows Lasso to perform implicit feature selection, potentially improving model interpretability and reducing sensitivity to irrelevant predictors. However, its ability to discard explanatory variables may also limit predictive performance when numerous correlated temporal features contribute useful information.

===== ElasticNet

ElasticNet combines L1 and L2 regularization penalties within a unified framework, seeking to balance the sparsity induced by Lasso with the stability provided by Ridge regression. @zou2005elasticnet

This hybrid formulation can be advantageous when dealing with high-dimensional feature spaces containing groups of correlated variables. Its inclusion in the experimental framework aimed to evaluate whether intermediate regularization strategies could improve forecasting accuracy.

==== Bayesian and generalized linear models

Bayesian and generalized linear approaches provide additional flexibility by introducing probabilistic assumptions regarding parameter estimation or response distributions.

===== ARDRegression

Automatic Relevance Determination (ARD) regression adopts a Bayesian perspective by estimating individual prior distributions for regression coefficients. Through an iterative optimization procedure, irrelevant predictors receive stronger shrinkage, allowing the model to automatically identify informative explanatory variables. @mackay1994bayesian

ARD regression was included to investigate whether Bayesian regularization techniques could improve robustness when handling large collections of engineered temporal features.

===== TweedieRegressor

The TweedieRegressor belongs to the family of generalized linear models and assumes that observations follow a Tweedie distribution.

Such distributions are often appropriate for modeling positive-valued or zero-inflated quantities frequently encountered in insurance, finance, and demand forecasting applications. Since international mail volumes are non-negative by construction, the TweedieRegressor was considered a potentially suitable alternative to classical linear regression approaches.

==== Gradient boosting models

Gradient boosting algorithms construct ensembles of decision trees in a sequential manner, where each newly added tree attempts to correct the residual errors produced by previous iterations.

These methods are capable of capturing complex nonlinear interactions between explanatory variables and have become widely adopted in forecasting competitions and industrial machine learning applications.

===== HistGradientBoostingRegressor

HistGradientBoostingRegressor is a histogram-based implementation of gradient boosting available in Scikit-learn. By discretizing continuous variables into bins prior to tree construction, it significantly reduces computational costs while maintaining competitive predictive performance. @scikit-learn

Its inclusion provided a computationally efficient boosting baseline within the machine learning family.

===== LGBMRegressor

LightGBM is a highly optimized gradient boosting framework designed to improve training speed and scalability through histogram-based learning and leaf-wise tree growth strategies. @ke2017lightgbm

LightGBM has demonstrated strong performance in numerous tabular machine learning tasks and was therefore considered a natural candidate for evaluating nonlinear relationships within the engineered feature space.

===== XGBRegressor

XGBoost is an implementation of gradient boosting that incorporates regularization mechanisms, efficient tree construction algorithms, and parallelized optimization procedures. @chen2016xgboost

Due to its widespread success in predictive analytics and forecasting competitions, XGBoost was included as a representative state-of-the-art boosting algorithm.

===== CatBoostRegressor

CatBoost is a gradient boosting framework originally developed to improve the treatment of categorical variables through ordered boosting procedures. @prokhorenkova2018catboost

Although the forecasting problem considered in this internship primarily relied on numerical features, CatBoost remains highly competitive on structured datasets and demonstrated strong predictive performance among the machine learning models evaluated.



=== Deep Learning Models

Deep learning approaches have recently attracted considerable interest in time-series forecasting due to their ability to learn complex nonlinear relationships directly from historical observations @hyndman2026forecasting. Unlike classical statistical models and most machine learning methods, neural forecasting models can automatically discover hierarchical temporal representations without relying heavily on manually engineered features.

The neural models evaluated in this study were implemented using the NeuralForecast framework @neuralforecast. In contrast to the machine learning models presented previously, only a limited set of covariates was supplied to the neural architectures, as these models are designed to learn temporal dependencies directly from sequential data.

Deep learning models are generally characterized by a larger number of trainable parameters and consequently require substantial amounts of data to reach their full predictive potential. During preliminary experiments, their performance was found to be highly dependent on the amount of training data available. This behavior was particularly evident in the temporal evolution of cross-validation scores, where neural models initially underperformed simpler approaches but progressively became more competitive as additional observations were incorporated into the training windows.

Only two neural architectures were retained for the final experimental evaluation: NHITS and BiTCN.

==== NHITS

NHITS (Neural Hierarchical Interpolation for Time Series Forecasting) is a deep neural architecture specifically designed for long-horizon forecasting problems @challu2022nhits. The model extends the N-BEATS@oreshkin2020nbeatsneuralbasisexpansion family by introducing hierarchical interpolation mechanisms that improve computational efficiency while preserving the ability to model complex temporal dynamics.

NHITS decomposes the forecasting task into several blocks operating at different temporal resolutions. Lower-frequency components capture long-term trends and seasonal patterns, while higher-frequency components focus on short-term fluctuations. The outputs of these blocks are subsequently combined to produce the final forecast.

Its ability to model multiple temporal scales motivated its inclusion in this study, particularly given the coexistence of long-term trends and recurring seasonal effects observed in international postal traffic.

==== BiTCN

BiTCN is a forecasting architecture derived from Temporal Convolutional Networks (TCNs) @bai2018tcn and implemented within the NeuralForecast ecosystem @neuralforecast. The model employs dilated convolutional layers to efficiently capture long-range temporal dependencies while maintaining parallelizable training procedures. @xuan2024bitcn

Unlike recurrent neural networks, convolutional architectures process entire sequences simultaneously, allowing significantly faster training and inference. The bidirectional structure adopted by BiTCN enables information to be extracted from multiple receptive fields, facilitating the representation of complex temporal interactions.

Among all forecasting models evaluated during this internship, BiTCN achieved the best predictive performance for the short forecasting horizon considered in the operational use case ($h=4$ weeks). However, additional experiments conducted on extended horizons revealed a noticeable deterioration in neural forecasting performance, suggesting that the advantages offered by deep architectures may be more pronounced for short-term operational forecasting scenarios than for long-range extrapolation tasks under the available data regime.


=== Hierarchical Forecasting and Forecast Reconciliation
As discussed in @section_methodology_hierarchical, outgoing international mail flows naturally exhibit a hierarchical structure. The same observations can be aggregated at different levels, including the overall international flow, deposit centers, destination countries, or combinations of these dimensions.

Forecasting each series independently generally produces incoherent results. For example, the sum of forecasts generated for individual deposit centers may differ from the forecast obtained directly for the national total. Such inconsistencies complicate operational planning and reduce the interpretability of forecasting outputs.

Hierarchical forecasting addresses this issue by combining forecasting and reconciliation techniques to ensure aggregation coherence across all levels of the hierarchy @hyndman2026forecasting.

#figure(
  mermaid(
    "
flowchart LR

A[Root Time Series]

A --> B[Forecast Generation]

B --> C[National Forecast]

C --> D[Forecast Reconciliation]

D --> E[Agency Forecasts]

D --> F[Destination Forecasts]

D --> G[Agency × Destination Forecasts]

",
  ),
  caption: [Forecast reconciliation process adopted during the internship.],
) <fig-reconciliation-process>

@fig-reconciliation-process presents the strategy implemented in this work. Forecasts are first generated at the aggregate level and subsequently distributed across lower hierarchical levels through a reconciliation procedure. This approach ensures consistency between detailed forecasts and the overall prediction.

The hierarchy considered in this study is composed of two dimensions:

- Deposit center;
- Destination country.

An additional node representing the total international outgoing flow was introduced as the root of the hierarchy.

The aggregation structures required for reconciliation were constructed using the utilities provided by the HierarchicalForecast package @hierarchicalforecast. This process generates three main objects:

- A dataset containing observations for all aggregation levels;
- A summation matrix describing hierarchical relationships;
- Metadata identifying each level of the hierarchy.

The main reconciliation approaches proposed in the literature are summarized in @tbl-reconciliation-methods.

#figure(
table(
    columns: (2fr,4fr),

    table.header(
        [Method],
        [Principle],
    ),

    [Bottom-Up],
    [Aggregates forecasts generated at the most detailed level.],

    [Top-Down],
    [Distributes aggregate forecasts to lower levels using allocation proportions.],

    [MinTrace @wickramasuriya2019mint],
    [Produces coherent forecasts while minimizing reconciliation errors.]
),
caption: [Common hierarchical reconciliation approaches.]
) <tbl-reconciliation-methods>

@tbl-reconciliation-methods shows that several reconciliation strategies can be considered. Their suitability depends on the forecasting context, the availability of historical information, and the reliability of forecasts at different aggregation levels.

In this internship, the Top-Down reconciliation method based on historical average proportions was selected. This approach was considered appropriate because the forecasting models were trained exclusively on the aggregate international series.

The reconciliation process consists of allocating the forecast generated at the root level among subordinate nodes according to proportions estimated from historical observations.

If $ hat(y)_("Total",t+h) $ denotes the aggregate forecast and $p_i$ the historical proportion associated with node $i$, the reconciled forecast is computed as:

$
hat(y)_(i,t+h)=p_i hat(y)_("Total",t+h)
$

where:

- $p_i$ is the average historical contribution of node $i$;
- $hat(y)_("Total",t+h)$ is the forecast produced at the aggregate level.

This strategy allows coherent forecasts to be generated for all combinations of deposit centers and destination countries while avoiding the need to train a separate forecasting model for each individual series.

Although more sophisticated reconciliation techniques such as MinTrace could potentially improve predictive accuracy, the Top-Down method offered a good compromise between implementation complexity, computational cost, and interpretability within the context of this internship.