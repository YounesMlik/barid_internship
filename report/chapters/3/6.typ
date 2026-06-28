#import "@preview/mmdr:0.2.2": mermaid
#import "@preview/zebraw:0.6.3": *
#show: zebraw


This section presents the results obtained using the evaluation methodology described in @chapter_methodology. The objective is to compare the forecasting approaches considered in this study under identical experimental conditions and to identify models that provide the most suitable compromise between predictive accuracy, robustness, and operational applicability.

The comparison is based on rolling-origin cross-validation and relies on four complementary evaluation metrics: MASE, RMAE, ND, and SPIS. The analysis is organized by model family in order to facilitate interpretation and highlight the contribution of increasingly sophisticated forecasting techniques.

The presentation begins with statistical approaches, followed by machine learning models, neural architectures, and ensemble methods. Finally, all candidate models are compared jointly to support the selection of the forecasting approach retained for operational use.

=== Statistical Models Evaluation

Statistical forecasting models constitute an important baseline in time series analysis due to their relatively low computational requirements, ease of interpretation, and proven effectiveness in many industrial applications. In this study, seven statistical approaches were evaluated using the rolling-origin cross-validation framework introduced in @section_methodology_cv.

@tbl-stat-results summarizes the average performances obtained by these models across all validation windows.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),

    table.header(
      [Model], [RMAE], [MASE], [ND], [SPIS]
    ),

    [AutoARIMA], [0.462], [643.479], [0.147], [70.211],

    [CES], [0.479], [652.842], [0.143], [71.314],

    [AutoTBATS], [0.590], [814.889], [0.185], [90.608],

    [AutoTheta], [0.698], [948.811], [0.182], [102.857],

    [AutoMFLES], [0.706], [907.191], [0.201], [97.903],

    [AutoETS], [0.933], [1310.279], [0.320], [146.920],

    [SeasonalNaive], [1.000], [1576.432], [0.396], [180.822],
  ),

  caption: [Cross-validation performances of statistical forecasting models.],
)<tbl-stat-results>

As shown in @tbl-stat-results, AutoARIMA achieved the best overall performance among statistical approaches, obtaining an average RMAE of 0.462. CES exhibited very similar behavior, with only a marginal degradation in forecasting accuracy.

These results suggest that the studied series can be effectively modeled using approaches capable of capturing both autoregressive dynamics and seasonal patterns. The relatively good performance of CES also indicates that complex exponential smoothing mechanisms remain relevant for this forecasting problem.

AutoTBATS produced intermediate results despite its ability to model multiple seasonalities. This behavior may be explained by the limited length of the available historical dataset, which reduces the advantages associated with highly flexible decomposition-based methods.

AutoETS yielded the weakest performances among advanced statistical models and remained relatively close to the SeasonalNaive baseline. This observation suggests that the assumptions underlying traditional exponential smoothing are insufficient to adequately represent the variability observed in outgoing international mail flows.

Overall, statistical models provide robust and computationally efficient forecasting solutions. Although they are outperformed by more sophisticated approaches for short forecasting horizons, they remain attractive candidates for applications requiring stable long-term extrapolation.

=== Machine Learning Models Evaluation

Machine learning approaches were introduced to exploit nonlinear relationships and interactions between lagged observations and engineered temporal features. All models were trained using the same feature set described in @section_methodology_feature_engineering and evaluated using the cross-validation strategy presented in @section_methodology_cv.

@tbl-ml-results presents the average performances obtained by machine learning models.

#figure(
  table(

    columns: (auto, auto, auto, auto, auto),

    table.header(
      [Model], [RMAE], [MASE], [ND], [SPIS]
    ),

    [Ridge], [0.404], [576.802], [0.134], [64.322],

    [LinearRegression], [0.415], [600.037], [0.139], [67.025],

    [CatBoostRegressor], [0.436], [597.800], [0.133], [65.581],

    [ARDRegression], [0.484], [756.803], [0.182], [86.264],

    [XGBRegressor], [0.513], [693.310], [0.144], [75.522],

    [HistGradientBoostingRegressor], [0.594], [792.219], [0.174], [85.559],

    [TweedieRegressor], [0.644], [813.827], [0.177], [88.201],

    [ElasticNet], [0.685], [844.689], [0.190], [91.930],

    [LGBMRegressor], [0.596], [879.548], [0.195], [96.972],

    [Lasso], [0.746], [899.170], [0.205], [97.537],
  ),

  caption: [Cross-validation performances of machine learning models.],
)<tbl-ml-results>

According to @tbl-ml-results, Ridge regression achieved the best overall performance among machine learning approaches, with an average RMAE of 0.404. LinearRegression exhibited comparable behavior, suggesting that a significant proportion of the predictive signal can be captured through linear relationships between lagged observations and temporal features.

CatBoostRegressor produced competitive results and achieved the lowest ND value within this family, indicating good point forecasting capabilities. However, its advantage over simpler linear methods remained relatively limited.

Surprisingly, gradient boosting approaches such as XGBoost, HistGradientBoostingRegressor, and LightGBM did not outperform regularized linear models. This may be partially explained by the relatively small number of observations available for training and the strong seasonal structure already captured by engineered lag features.

Regularized models such as ElasticNet and Lasso obtained lower rankings, indicating that aggressive feature shrinkage may remove useful information from the forecasting problem.

Overall, machine learning approaches significantly improved upon purely statistical methods while maintaining moderate computational requirements. They therefore represent an attractive compromise between forecasting accuracy and implementation complexity.


=== Deep Learning Models Evaluation

Deep learning approaches were investigated to determine whether more expressive architectures could better capture the complex temporal dependencies observed in outgoing international mail flows. Unlike machine learning methods relying explicitly on manually engineered lagged features, neural forecasting models learn internal representations directly from the historical sequence.

As described in @section_methodology_modeling_strategy, two neural architectures were retained in this study: BiTCN and NHITS. Both models were trained on the transformed weekly aggregated series and received the same trend-based exogenous features used by the other forecasting approaches.

@tbl-neural-results summarizes the performances obtained by these models over all cross-validation windows.

#figure(
  table(

    columns: (auto, auto, auto, auto, auto),

    table.header(
      [Model], [RMAE], [MASE], [ND], [SPIS]
    ),

    [BiTCN], [0.108], [228.094], [0.115], [33.487],

    [NHITS], [0.137], [289.796], [0.146], [42.546],
  ),

  caption: [Cross-validation performances of neural forecasting models.],
)<tbl-neural-results>

As shown in @tbl-neural-results, neural approaches substantially outperformed all previously evaluated forecasting families. BiTCN achieved the best overall results among all candidate models, obtaining the lowest values for all evaluation metrics considered.

Compared to the SeasonalNaive baseline, BiTCN reduced the average forecasting error by almost 90%, with an RMAE value of only 0.108. NHITS also demonstrated excellent predictive capabilities, ranking among the best-performing models despite slightly higher forecasting errors.

The superior performances of BiTCN may be attributed to its temporal convolutional architecture, which is particularly well suited for learning local temporal dependencies while preserving long-range information through dilated convolutions. This capability appears beneficial for modeling the recurrent seasonal patterns and short-term fluctuations characterizing international mail volumes.

However, it should be emphasized that these results correspond exclusively to the operational forecasting horizon considered in this study (*h = 4 weeks*). Additional experiments performed on longer horizons revealed a significant deterioration in neural forecasting quality. Although deep learning models provide outstanding short-term predictions, their forecasts become increasingly unstable as the prediction horizon grows.

This behavior contrasts with some statistical approaches, particularly AutoARIMA and CES, which tend to maintain more stable long-term trajectories. Consequently, the adoption of BiTCN within this work is motivated by its suitability for short-term operational planning rather than its ability to generate reliable long-range forecasts.


=== Ensemble Models Evaluation

In addition to evaluating individual forecasting models, ensemble approaches were investigated in order to assess whether combining complementary predictors could improve forecasting robustness.

Three ensemble forecasts were constructed following the methodology described in @section_methodology_cv. Each ensemble corresponds to the arithmetic mean of the predictions produced by the two best-performing models within a given methodological family.

@tbl-ensemble-results presents the performances obtained by these ensemble forecasts.

#figure(
  table(

    columns: (auto, auto, auto, auto, auto),

    table.header(
      [Model], [RMAE], [MASE], [ND], [SPIS]
    ),

    [stat_ensemble], [0.431], [604.645], [0.135], [66.234],

    [ml_ensemble], [0.385], [538.302], [0.124], [59.577],

    [neural_ensemble], [0.112], [237.953], [0.120], [34.935],
  ),

  caption: [Cross-validation performances of ensemble forecasting models.],
)<tbl-ensemble-results>

According to @tbl-ensemble-results, ensemble forecasts consistently improved upon most individual models within their respective families.

The statistical ensemble combining AutoARIMA and CES outperformed each of its constituent models individually, suggesting that averaging forecasts helps reduce model-specific errors.

Similarly, the machine learning ensemble constructed from Ridge and CatBoostRegressor achieved better performances than either model considered separately.

The neural ensemble combining BiTCN and NHITS also produced highly competitive results. Nevertheless, its performances remained slightly below those of BiTCN alone. This observation indicates that NHITS introduces a small amount of additional forecasting variance that offsets the potential benefits of model averaging.

Overall, ensemble methods demonstrated their ability to increase forecast robustness. However, in the present study, they did not systematically surpass the best individual models.


=== Final Model Selection

The previous sections evaluated candidate forecasting approaches within their respective methodological families. In order to select a forecasting model suitable for operational deployment, all evaluated approaches were compared jointly using the average cross-validation metrics presented in @chapter_methodology.

Since RMAE directly quantifies forecasting performance relative to the SeasonalNaive baseline, it was adopted as the primary ranking criterion. Secondary metrics (MASE, ND, and SPIS) were used to confirm the consistency of the rankings obtained.

@tbl-global-ranking presents the complete ranking of all evaluated forecasting approaches according to their average RMAE score.

#figure(
  table(
    columns: (auto, auto, auto),

    table.header(
      [Rank], [Model], [RMAE]
    ),

    [1], [BiTCN], [0.108],
    [2], [neural_ensemble], [0.112],
    [3], [NHITS], [0.137],
    [4], [ml_ensemble], [0.385],
    [5], [Ridge], [0.404],
    [6], [LinearRegression], [0.415],
    [7], [stat_ensemble], [0.431],
    [8], [CatBoostRegressor], [0.436],
    [9], [AutoARIMA], [0.462],
    [10], [CES], [0.479],
    [11], [ARDRegression], [0.484],
    [12], [XGBRegressor], [0.513],
    [13], [AutoTBATS], [0.590],
    [14], [HistGradientBoostingRegressor], [0.594],
    [15], [LGBMRegressor], [0.596],
    [16], [TweedieRegressor], [0.644],
    [17], [ElasticNet], [0.685],
    [18], [AutoTheta], [0.698],
    [19], [AutoMFLES], [0.706],
    [20], [Lasso], [0.746],
    [21], [AutoETS], [0.933],
    [22], [SeasonalNaive], [1.000],
  ),

  caption: [Global ranking of forecasting models based on average RMAE.],
)<tbl-global-ranking>


As shown in @tbl-global-ranking, neural forecasting approaches clearly dominate the ranking. BiTCN achieved the best overall performance, closely followed by the neural ensemble and NHITS.

The results also indicate that relatively simple machine learning methods, particularly Ridge regression and ordinary linear regression, remain highly competitive despite their lower modeling complexity. Their performances exceed those of all standalone statistical models.

Among statistical approaches, AutoARIMA and CES constitute the most effective alternatives, obtaining results comparable to those of the best machine learning models while maintaining a lower computational cost and a high degree of interpretability.

The ranking further highlights the limited contribution of highly regularized linear models and some decomposition-based statistical methods for the considered forecasting task.


The average cross-validation metrics presented previously summarize model performances over all validation windows. However, they do not provide information about the evolution of forecasting accuracy as additional historical observations become available.

To analyze this behavior, the forecasting errors obtained for each validation window were visualized as a function of the cutoff date.

@fig-cutoff-rmae illustrates the evolution of RMAE values over successive cross-validation windows for the main forecasting approaches.

#figure(
  image("../../images/rmae_by_cutoff.svg", width: 100%),
  caption: [
    Evolution of RMAE values across rolling cross-validation windows.
  ],
)<fig-cutoff-rmae>

The behavior observed in @fig-cutoff-rmae suggests that forecasting performance depends not only on the choice of model but also on the amount of historical information available during training.

During the earliest validation windows, simpler approaches often remain competitive due to the relatively limited quantity of observations available for model estimation. As the training period expands, more expressive architectures progressively improve their predictive capabilities.

This phenomenon is particularly noticeable for BiTCN, whose forecasting errors decrease steadily over successive validation windows. The model appears to benefit substantially from larger training datasets, eventually becoming the most accurate forecasting approach considered in this study.

This observation is consistent with the greater representational capacity of neural architectures, which generally require a sufficient amount of historical data to fully exploit their modeling capabilities.


From an operational perspective, the objective of this study is to support short-term planning activities within Barid Al-Maghrib. The selected forecasting horizon corresponds to four weeks, which aligns with transport planning and resource allocation cycles.

For this specific use case, BiTCN constitutes the most appropriate forecasting model. It consistently achieved the best performances across all evaluation metrics and demonstrated increasing predictive capabilities as additional historical observations became available.

Nevertheless, complementary experiments conducted using longer forecasting horizons revealed a significant degradation in the quality of neural forecasts. Although BiTCN and NHITS provide outstanding short-term predictions, their forecasts tend to diverge more rapidly when extrapolated over extended periods.

Conversely, statistical approaches such as AutoARIMA and CES exhibit comparatively more stable long-term behavior. Consequently, the choice of BiTCN should not be interpreted as a universally superior forecasting solution, but rather as the model best aligned with the operational requirements of Barid Al-Maghrib, where decision-making primarily relies on short-term forecasts.

Based on these considerations, BiTCN was identified as the most suitable model for the primary operational use case considered in this study, namely four-week forecasting.

However, the forecasting system was designed to remain model-agnostic. Forecasts generated by all evaluated models are preserved, reconciled, and made available through the interactive visualization interface, allowing users to compare alternative forecasting approaches according to their specific analytical needs.
