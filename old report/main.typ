#import "@preview/ilm:2.0.0": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes
#import "@preview/zebraw:0.6.3": *
#show: zebraw

#set text(lang: "en")

#show: ilm.with(
  title: align(center)[Analysis and Forecasting of Morocco's Outgoing International Mail Flows],
  authors: ("Younes MLIK", "Supervised by: EDDYA Moulay Lahcen"),
  date: datetime(year: 2026, month: 04, day: 27),
  abstract: [
    Report for an end of year internship at Barid Al-Maghrib
  ],
  preface:[],
  // preface: [
  //   #align(center + horizon)[
  //     Thank you for using this template #emoji.heart,\ I hope you like it #emoji.face.smile
  //   ]
  // ],
  bibliography: bibliography("refs.bib"),
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true),
)

= Abstract
This internship was carried out at Barid Al-Maghrib as part of the completion requirements for the academic year. The project focused on the analysis and forecasting of Morocco's outgoing international mail flows, with the objective of supporting operational planning and improving decision-making processes within the postal network.

The study involved the collection, cleaning, and exploration of historical postal data to identify trends, seasonal patterns, and key factors influencing international mail volumes. Several statistical and time-series forecasting techniques were applied and evaluated to model the evolution of outgoing international mail flows and generate reliable future estimates. Model performance was assessed using appropriate forecasting accuracy metrics, allowing for the selection of the most suitable approach for operational use.

The results provide valuable insights into the dynamics of Morocco's international postal traffic and demonstrate the potential of data-driven forecasting methods to enhance resource allocation, capacity planning, and service quality. This work contributes to the ongoing digital transformation and performance optimization efforts at Barid Al-Maghrib by providing a framework for anticipating future demand and supporting strategic planning.


= Data

The integrity of this forecasting study relies on the quality and granularity of the underlying postal data. However, the data acquisition phase presented significant technical challenges due to the legacy nature of the internal systems at Barid Al-Maghrib (BAM). This section details the custom data engineering pipeline developed to extract, clean, and optimize the dataset.


== Data Acquisition Challenges

The data used throughout this study were obtained from the Système de Messagerie Intégré (SMI), the operational information system used by Barid Al-Maghrib to manage parcel and mail activities. Although SMI exposes a large number of reports through a web interface, it was not designed to support large-scale analytical workflows or automated data extraction.

Several technical constraints complicated the collection process. First, no documented application programming interface (API) was available for any of the datasets considered in this study. Consequently, all data had to be collected through the graphical user interface exposed by the SMI web portal.

Second, some reporting interfaces exhibited performance limitations when queried over long periods. In particular, the report used to retrieve outgoing international shipments frequently became unresponsive or failed when requesting periods exceeding approximately six months. This limitation prevented direct extraction of the complete historical period required for the analysis and necessitated the use of iterative collection procedures.

Another challenge arose from the shipment tracking interface. Unlike conventional reporting modules that support exporting tabular data, the tracking system only allows users to query shipment histories individually by entering a parcel identifier. The corresponding information is returned as dynamically generated HTML pages intended for interactive consultation rather than bulk processing. Since the analysis required access to historical operational events for hundreds of thousands of parcels, manual retrieval was clearly infeasible.

The collection process was also expected to run for extended periods of time, increasing the likelihood of transient failures such as session expiration, network interruptions, browser crashes, or incomplete downloads. To ensure reproducibility and minimize manual intervention, a custom extraction framework was developed to automate data acquisition while providing mechanisms for retrying failed operations, resuming interrupted downloads, and incrementally building the final analytical datasets.

The following sections describe the extraction procedures employed for each data source, together with the resulting datasets and the preprocessing operations applied prior to analysis.



== Data Acquisition Methodology

The primary obstacle was the absence of a structured API. The internal portal, while rich in information, is optimized for individual queries rather than bulk exports. Initial attempts to pull multi-month reports resulted in server-side timeouts and backend crashes. 

To overcome these constraints, a Robotic Process Automation (RPA) approach was implemented using *Playwright* for Python. This allowed for the simulation of human interaction with the web portal at scale.

=== Robustness and Resiliency
Given the instability of the backend when under load, a "fail-soft" architecture was designed. The core logic utilizes a custom `with_retry` decorator and a resource management wrapper to ensure that transient network errors or session timeouts do not terminate the entire collection process.

#block(fill: luma(245), inset: 12pt, radius: 4pt)[
  *Technical Implementation: Retry Logic* \
  The pipeline uses a `retry_with_resource` pattern. If a page action fails, the system automatically:
  1. Closes the corrupted browser context.
  2. Re-authenticates via the `login()` routine.
  3. Re-navigates to the last known state to resume the task.
]

=== State-aware Extraction
Because the number of parcels exceeds 200,000, the scraper was designed to be *idempotent*. Before attempting a download, the script calls `build_download_index()`, which scans the local directory to map existing files. The index is cached to reduce redundant computation.

#zebraw[
```python
def all_downloads_exist(cab: str, download_path: str) -> bool:
    index = build_download_index(download_path)
    entry = index.get(cab)
    if not entry or entry.max_total == 0:
        return False
    expected = set(range(1, entry.max_total + 1))
    return entry.indices == expected
```
]

This logic allows the scraper to resume exactly where it left off after a crash, avoiding redundant requests and minimizing load on BAM servers.
=== Chunked Acquisition
To prevent server crashes, the system implements a "chunking" strategy via a `date_range` generator. Instead of requesting large temporal blocks, the scraper requests data in 24-hour increments. This ensures that the resulting CSV payloads remain small enough for the backend to process and serve reliably.

== Envois by produit international (smi_envoisbyproduitintern)

This dataset serves as the primary source for the "Date of Deposit" variable. The extraction was automated via the `etats.py` module, which handles the complex selection of dropdown menus and date pickers.

*Data Volume:* 195,858 rows. \
*Extraction Strategy:* Daily iteration from 2023 to 2026. \
*Cleaning:* Duplicate removal was performed using the `codeenvoi_` unique identifier. As shown in Table 1, the cardinality of `codeenvoi_` is nearly equal to the row count, confirming high data uniqueness after cleaning.

== Envois by produit international (smi_envoisbyproduitintern)
The backend is very slow, and crashes if I request more than a 6 month period. And there is no available API so I had to use use the Playwright library to automate exporting CSV files from the web portal.

I removed duplicate using `codeenvoi_`.

Number of rows: 195858

#figure(table(
  columns: 2,
  align: (left, center),
  stroke: 0.5pt,
  table.header([Feature], [Unique values]),

  `codeenvoi_`, [195844],
  `datedepot`, [117202],
  `origine`, [2],
  `destination_`, [184],
  `site_depot_`, [800],
  `pouds_reel_`, [13354],
  `longueur_`, [187],
  `largeur_`, [218],
  `hauteur_`, [114],
  `poids_volume_`, [4272],
 ), caption: [Cardinality summary])
 
#figure(table(
  columns: 7,
  align: (left, center, center, center, center, center, center),

  table.header(
    [Statistic],
    rotate(90deg, reflow: true)[`datedepot`],
    rotate(90deg, reflow: true)[`pouds_reel_`],
    rotate(90deg, reflow: true)[`longueur_`],
    rotate(90deg, reflow: true)[`largeur_`],
    rotate(90deg, reflow: true)[`hauteur_`],
    rotate(90deg, reflow: true)[`poids_volume_`],
  ),

  [Null Count], [0], [0], [62073], [62216], [74233], [0],

  [Mean], [2024-06-25 19:10:14], [5.54], [38.64], [26.38], [16.97], [0.95],
  [Std], [-], [6.02], [30.07], [24.78], [10.82], [10.15],

  [Min], [2023-01-02 00:00:00], [0.008], [0.0], [0.0], [0.0], [0.0],
  [25%], [2023-09-05 10:18:00], [1.25], [26.0], [20.0], [10.0], [0.0],
  [50% (Median)], [2024-05-17 09:06:00], [3.3], [36.0], [23.0], [14.0], [0.0],
  [75%], [2025-03-17 13:57:00], [7.74], [50.0], [30.0], [22.0], [0.0],
  [Max], [2026-05-18 15:51:00], [67.58], [7055.0], [3715.0], [1200.0], [3084.585],
), caption: [Descriptive statistics])

== Parcels passing by Laayoune (smi_suiviexpedition)
This data was not used during the analysis

Number of rows: 244147

#figure(table(
  columns: 2,
  align: (left, center),
  stroke: 0.5pt,
  table.header([Feature], [Unique values]),

  `CAB`, [244147],
  `CLIENT`, [4830],
  `SERVICES_OPTIONNELS`, [165],
  `SITE_EXPEDITEUR`, [107],
  `RECEPTION`, [2],
  `DERNIER_STATUT`, [9],
  `DATE_DERNIER_STATUT`, [111994],
  `SITE_DERNIER_STATUT`, [8],
  `DESTINATION`, [568],
), caption: [Cardinality summary])
#figure(table(
  columns: 2,
  align: (left, center),
  table.header(
    [Statistic],
    `DATE_DERNIER_STATUT`,
  ),

  [Null Count], [0],

  [Mean], [2024-08-21 21:07],

  [Std], [—],

  [Min], [2022-01-05 00:00:00],

  [25%], [2023-10-25 12:16:00],

  [50% (Median)], [2024-09-03 09:20:54],

  [75%], [2025-07-03 15:38:41],

  [Max], [2026-04-28 14:42:43],

), caption: [Descriptive statistics])


== Parcel tracking data
While the Global Envois tell us when a package was sent, the tracking data tells us how it moved through the network. 

I couldn't find any API to get the parcel tracking data in bulk, so I had to rely on a webpage where you enter the parcel ID and it gives you information in HTML format. I got all the IDs from smi_envoisbyproduitintern, then I downloaded all the HTML files for later processing, then I extracted the information into 4 parquet files, one for general information, one for additional services associated with the package, one for tracking and one for delivery information.
- *The HTML Archival Challenge:* Tracking data is not available as a CSV export. It is presented as an interactive HTML table for individual parcels.
- *Storage Optimization:* To maintain a "Source of Truth," the raw HTML for 234,000 parcels was saved. This initially consumed *10.2 GB* of disk space.
- *Conversion to Parquet:* An ETL script was developed to parse these HTML files using `lxml`. The data was then converted into the *Apache Parquet* format. Parquet’s dictionary encoding and Snappy compression reduced the storage footprint from *10.2 GB to 35 MB* (a 99.6% reduction) while significantly speeding up query times for the analysis phase.

=== Handling Temporal Irregularities
The data showed extreme sparsity before 2023. As noted in the investigation, historical data was too sporadic for reliable time-series training. Consequently, a hard filter was applied to only include data from January 1, 2023, onwards.

=== fields:
I filtered out invalid data with `Etat`.

Number of rows: 234718

#figure(table(
  columns: 2,
  align: (left, center),
  stroke: 0.5pt,
  table.header([Feature], [Unique values]),

  `Cab`, [234716],
  `Id`, [234718],
  `Date_depot`, [1041],
  `Type_cab`, [4],
  `Dernier_statut`, [10],
  `Regime`, [3],
  `Contrat`, [4843],
  `Etat`, [1],
  `Poids_global_en_KG`, [12435],
  `Centre_Agence_depot`, [1484],
  `Destination`, [563],
  `Client`, [6892],
  `Produit_Niveau_Service`, [16],
  `Mode_paiement`, [7],
  `Taxe_DTQ_Dhs`, [3],
  `Canal_de_livraison_1`, [3],
  `Canal_de_livraison_2`, [442],
  `Longueur`, [296],
  `Hauteur`, [114],
  `Largeur`, [191],
  `Poids_Volumetrique`, [39],
 ), caption: [Cardinality summary])
 #figure(table(
  columns: 8,
  align: (left, center, center, center, center, center, center, center),
  table.header(
    [Statistic],
    rotate(90deg, reflow: true)[`Date_depot`],
    rotate(90deg, reflow: true)[`Poids_global_en_KG`],
    rotate(90deg, reflow: true)[`Taxe_DTQ_Dhs`],
    rotate(90deg, reflow: true)[`Longueur`],
    rotate(90deg, reflow: true)[`Hauteur`],
    rotate(90deg, reflow: true)[`Largeur`],
    rotate(90deg, reflow: true)[`Poids_Volumetrique`],
  ),

  [Null Count], [0], [0], [44484], [202002], [203394], [202933], [47777],

  [Mean], [2024-09-12], [3.71], [0.025], [33.53], [14.41], [26.69], [0.0003],

  [Std], [---], [7.26], [0.157], [47.30], [35.24], [56.57], [0.0424],

  [Min], [2023-01-02], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0],
  [25%], [2023-11-22], [0.12], [0.0], [20.0], [7.0], [14.0], [0.0],
  [50% (Median)], [2024-09-24], [0.76], [0.0], [25.0], [10.0], [20.0], [0.0],
  [75%], [2025-07-08], [4.04], [0.0], [30.0], [12.0], [20.0], [0.0],
  [Max], [2026-04-28], [1757.0], [1.0], [913.0], [665.0], [750.0], [15.125],
), caption: [Descriptive statistics])

=== operations:
I extracted `status_code` and `is_valid` from `Etat` using regex. For example, the value `[ depot ] VALIDE (V)` was parsed into `status_code` = `depot` and `is_valid` = `V`

I filtered out invalid data with `is_valid`. Then I filtered for only outgoing deliveries using `status_code`, since the number of incoming deliveries is negligible.

Number of rows: 2077161

#figure(table(
  columns: 2,
  align: (left, center),
  stroke: 0.5pt,
  table.header([Feature], [Unique values]),

  `cab`, [244091],
  `id`, [257828],
  `Date_operation`, [1546],
  `Heure_Syst_Oper`, [438442],
  `Statut`, [29],
  `Agence`, [1574],
  `Agent_oper`, [5475],
  `Etat`, [14],
  `Date_Etat`, [1359],
  `Agent_maj`, [2],
  `ORIGINE`, [5],
  `status_code`, [14],
  `is_valid`, [1],
), caption: [Cardinality summary])

#figure(table(
  columns: 3,
  align: (left, center, center),
  table.header(
    [Statistic],
    `Date_operation`,
    `Heure_Syst_Oper`,
  ),

  [Null Count], [0], [0],

  [Mean], [2024-08-09], [2024-08-10 03:50],

  [Std], [---], [---],

  [Min], [2022-01-03], [2022-01-03 09:09],

  [25%], [2023-10-23], [2023-10-23 10:09],

  [50% (Median)], [2024-08-09], [2024-08-09 16:26],

  [75%], [2025-06-14], [2025-06-14 09:19],

  [Max], [2026-05-11], [2026-05-11 15:28],

), caption: [Descriptive statistics])

=== delivery:

Number of rows: 241781

#figure(table(
  columns: 2,
  align: (left, right),
  stroke: 0.5pt,
  table.header([Feature], [Unique values]),

  `cab`, [241431],
  `id`, [241431],
  `agence_liv`, [222],
  `date_liv`, [1287],
  `date_transf_ccp`, [1016],
  `montant`, [6335],
  `beneficiaire`, [14481],
  `n_pid`, [2526],
  `statut`, [13],
  `origine`, [6],
  `etat`, [3],
  `N_compte_Infos`, [4738],
  `N_cheque_N_reçu_TPE`, [7],
), caption: [Cardinality summary])

#figure(table(
  columns: 4,
  align: (left, center, center, center),
  table.header(
    [Statistic],
    `date_liv`,
    `date_transf_ccp`,
    `montant`,
  ),

  [Null Count], [1], [1], [1],

  [Mean], [2024-08-21], [0355-06-11], [282.97],

  [Std], [---], [---], [1743.92],

  [Min], [2022-01-05], [0001-01-01], [0.0],

  [25%], [2023-10-25], [0001-01-01], [0.0],

  [50% (Median)], [2024-09-03], [0001-01-01], [0.0],

  [75%], [2025-07-03], [0001-01-01], [0.0],

  [Max], [2026-05-11], [2026-05-09], [102800.0],

), caption: [Descriptive statistics])

=== services:

Number of rows: 205931

#figure(table(
  columns: 2,
  align: (left, right),
  stroke: 0.5pt,
  table.header([Feature], [Unique values]),

  `cab`, [134293],
  `id`, [134295],
  `Libelle_service`, [19],
  `Num_compte`, [4939],
  `Mnt_a_percevoir`, [7002],
  `Adr/compte service`, [2168],
  `Gsm`, [20952],
  `Taxe_TTC`, [166],
  `ORIGINE`, [3],
), caption: [Cardinality summary])

#figure(table(
  columns: 3,
  align: (left, center, center),
  table.header(
    [Statistic],
    `Mnt_a_percevoir`,
    `Taxe_TTC`,
  ),

  [Null Count], [2], [3],

  [Mean], [482.14], [14.80],

  [Std], [2199.64], [27.09],

  [Min], [0.0], [0.0],

  [25%], [0.0], [0.0],

  [50% (Median)], [0.0], [0.0],

  [75%], [300.0], [35.0],

  [Max], [102800.0], [999.0],

), caption: [Descriptive statistics])


= Analysis
This study focuses on two operational variables: the number of deposited packages and their total weight. Both quantities directly influence international mail processing, transportation capacity planning, and resource allocation. Package volume was excluded from the analysis because it was not reported consistently prior to 2026, which would introduce unnecessary missingness and potentially bias model estimation.

Unless stated otherwise, all analyses are conducted using the date of deposit. This choice is motivated by the absence of reliable tracking information once shipments leave Morocco, making the deposit date the earliest and most consistently observed event available throughout the study period.

The forecasting task is defined as a four-week-ahead prediction problem. A forecasting horizon of four weeks was selected to provide operationally relevant estimates for short- to medium-term planning while allowing sufficient lead time for anticipating fluctuations in shipping demand. Consequently, all models were trained and evaluated based on their ability to predict package activity during the four weeks immediately following each forecasting origin.
 
== Visualizations

== Visualizations and Insights

Initial exploratory data analysis (EDA) of the aggregated weekly series reveals two dominant characteristics:

1. *Ramadan Seasonality:* As shown in Figure 1 and 2, a significant spike in both volume and weight occurs in the month preceding Ramadan. This is attributed to the cultural practice of sending parcels (often food and gifts) to the Moroccan diaspora.
2. *Structural Trend:* A gradual downward trend is visible. This may reflect shifts in global e-commerce logistics or changes in consumer behavior post-pandemic.


#figure(image("Weekly Total Count.svg"), caption: [Weekly Total Count])
#figure(image("Weekly Total Weight.svg"), caption: [Weekly Total Weight])
#figure(image("Weekly Mean Weight.svg"), caption: [Weekly Mean Weight])

== Transformation

A logarithmic transformation was applied to the time series prior to model fitting. The primary motivation for this transformation was to ensure that forecasts remain strictly positive when transformed back to the original scale. Many real-world time series, particularly those involving demand, sales, prices, or counts, exhibit increasing variability as their magnitude grows. Applying the logarithm reduces this heteroscedasticity and often makes the series more amenable to statistical modeling. This is particularly beneficial for methods such as ETS, ARIMA, and Theta, whose assumptions are often better satisfied when the variance of the series is approximately constant over time.

Forecasting models are trained on the transformed series, and the resulting forecasts are subsequently converted back to the original scale using the exponential function before evaluation.

== Models
=== Naive Seasonal

The Seasonal Naive (SNaive) model is a benchmark forecasting method that assumes future values will be equal to the most recently observed value from the corresponding seasonal period. Formally, for a seasonal period (m), the forecast at horizon (h) is given by:

$ hat(y)_(t+h) = y_(t+h-m) $

where $y_(t+h-m)$ is the observation from the same season in the previous cycle. The model does not estimate parameters or attempt to model trend and noise components explicitly. Instead, it relies entirely on the persistence of seasonal patterns.

Although simplistic, the Seasonal Naive model is difficult to outperform on strongly seasonal datasets and is therefore widely used as a baseline in forecasting competitions and empirical studies. Its performance provides a useful reference point for assessing whether more complex models deliver meaningful improvements in forecast accuracy.

=== ETS (Exponential Smoothing)

ETS models form a state-space framework based on exponential smoothing principles. The acronym ETS refers to the three core components of the model: Error, Trend, and Seasonality. Different ETS specifications combine additive or multiplicative forms of these components, resulting in a large family of models capable of representing diverse time series behaviors.

The model updates its state variables recursively by assigning exponentially decreasing weights to past observations. More recent data receive greater influence, allowing the model to adapt to changes in level, trend, and seasonal structure over time. The general forecasting equations consist of a measurement equation and one or more state transition equations governing the evolution of latent components.

ETS models are particularly effective when the underlying time series exhibits stable trend and seasonal patterns. Their probabilistic state-space formulation also enables the construction of prediction intervals and likelihood-based model selection.

=== ARIMA (AutoRegressive Integrated Moving Average)

ARIMA is a class of stochastic time series models that combines autoregressive (AR), differencing (I), and moving average (MA) components. An ARIMA((p,d,q)) model can be expressed as:

$ phi(B) dot (1 - B)^d dot y_t = theta(B) dot epsilon_t $

where (B) is the backshift operator, (p) is the autoregressive order, (d) is the degree of differencing, (q) is the moving average order, and (\varepsilon_t) represents white noise errors.

The autoregressive component captures dependencies between current and past observations, while differencing removes non-stationarity by eliminating trends. The moving average component models serial correlation in forecast errors. Model parameters are typically estimated using maximum likelihood methods after identifying suitable orders through information criteria such as AIC or BIC.

ARIMA models are highly interpretable and remain among the most widely used statistical forecasting methods. Seasonal variants, such as SARIMA, extend the framework by incorporating seasonal autoregressive and moving average terms.

=== CES (Complex Exponential Smoothing)

Complex Exponential Smoothing (CES) extends traditional exponential smoothing by introducing complex-valued state representations. This formulation allows the model to capture cyclical and quasi-periodic behavior through oscillatory state dynamics rather than explicit seasonal decomposition.

Unlike standard ETS models, which represent seasonality using deterministic seasonal factors, CES models cyclical patterns through complex-number transformations that simultaneously account for amplitude and phase variations. This makes the method particularly effective for series exhibiting recurrent cycles whose timing or magnitude changes over time.

CES maintains the computational efficiency associated with exponential smoothing methods while providing additional flexibility for modeling dynamic periodic structures. It has shown strong performance in forecasting applications involving business cycles, demand fluctuations, and other non-standard recurring patterns.

=== MFLES (Median, Fourier, Linear, Exponential Smoothing)

MFLES is a hybrid forecasting framework that integrates robust statistical estimation with multiple signal decomposition techniques. The method combines median-based smoothing, Fourier series representations, linear trend estimation, and exponential smoothing components to capture different characteristics of the time series simultaneously.

Fourier terms are used to model seasonal patterns through trigonometric functions, allowing complex seasonal structures to be represented with a relatively small number of parameters. Median-based estimation improves robustness against outliers, while linear trend components account for long-term directional movement. Exponential smoothing mechanisms enable rapid adaptation to recent observations.

The combination of these techniques allows MFLES to handle noisy datasets, multiple seasonalities, structural changes, and irregular fluctuations more effectively than many single-method approaches. As a result, it has emerged as a competitive forecasting method in modern automated forecasting frameworks.

=== TBATS

TBATS is a state-space forecasting model developed specifically for complex seasonal time series. The acronym represents its key components: Trigonometric seasonality, Box-Cox transformation, ARMA errors, Trend, and Seasonal components.

A distinguishing feature of TBATS is its use of Fourier-based trigonometric representations to model seasonality. This approach enables the model to accommodate multiple seasonal periods, including non-integer and high-frequency seasonal cycles. The Box-Cox transformation stabilizes variance, while ARMA error processes capture residual autocorrelation not explained by trend and seasonal components.

TBATS is particularly valuable for datasets containing multiple overlapping seasonal patterns, such as hourly electricity demand, web traffic, or retail sales data. Traditional methods often struggle in such situations because the number of seasonal parameters becomes excessively large. TBATS addresses this limitation through a parsimonious state-space representation that remains computationally tractable even for complex seasonal structures.

=== Theta

The Theta method is a decomposition-based forecasting approach that modifies the curvature of a time series through a parameter known as the theta coefficient. The original series is decomposed into one or more theta lines, each emphasizing different aspects of the underlying signal. Forecasts generated from these transformed series are subsequently combined to obtain the final prediction.

In its standard implementation, the method effectively combines a long-term trend component with an exponential smoothing forecast. This decomposition enables the model to balance trend extrapolation and local adaptation, contributing to its strong empirical forecasting performance.

The Theta method gained prominence after ranking among the top-performing approaches in the M3 forecasting competition. Subsequent studies have shown that its effectiveness stems from its ability to approximate more complex forecasting models while maintaining low computational complexity and strong robustness across diverse datasets. Consequently, it remains a common benchmark and a core component of many forecasting ensembles.

== Prediction Intervals
=== Conformal Prediction
Forecasting models typically produce point forecasts, which provide a single estimate for each future observation. However, point forecasts alone do not quantify uncertainty. Prediction intervals address this limitation by providing a range of plausible future values that are expected to contain the true observations with a specified confidence level.

Conformal Prediction is a model-agnostic framework for constructing prediction intervals with finite-sample coverage guarantees. Rather than relying on distributional assumptions regarding forecast errors, conformal methods estimate uncertainty directly from historical forecast residuals. This makes them particularly useful when the underlying error distribution is unknown, non-Gaussian, or difficult to model analytically.

Given a set of calibration residuals,

$ r_i = abs(y_i - hat(y)_i) $

the conformal interval for a future forecast $hat(y)_(t+h)$ is constructed by selecting an appropriate quantile $q_alpha$ of the residual distribution and defining the interval

$ [hat(y)_(t+h) - q_alpha, hat(y)_(t+h) + q_alpha] $

where $q_alpha$ corresponds to the desired coverage level. For example, a 95% prediction interval uses a residual quantile such that approximately 95% of future observations are expected to fall within the resulting bounds.

In this study, conformal prediction intervals were only required for the MFLES model. Several benchmark models used in the evaluation provide their own mechanisms for estimating forecast uncertainty or generating prediction intervals. MFLES, however, produces point forecasts without an intrinsic error estimation procedure. Consequently, conformal prediction was applied as a post-processing step to quantify forecast uncertainty.

The intervals were generated using a rolling-window calibration approach. Let $h$ denote the forecast horizon and $n_"windows"$ the number of calibration windows. The number of windows was defined as

$ n_"windows" = min(10, floor(N / h)) $

where $N$ is the number of observations in the training dataset. This configuration uses up to ten historical forecasting windows while adapting to the amount of available data.

For each calibration window, forecasts were generated and the resulting residuals were collected to estimate the empirical error distribution. Prediction intervals for future forecasts were then constructed using the corresponding residual quantiles. This approach allows interval estimates to be derived directly from observed forecasting performance rather than from strong parametric assumptions.

By leveraging historical forecast errors, conformal prediction provides a robust and flexible framework for uncertainty quantification. The resulting intervals enable MFLES forecasts to be evaluated alongside competing models that natively provide prediction interval estimates.


== Evaluation
Model performance was assessed using rolling-origin cross-validation, a procedure that repeatedly evaluates forecasts on unseen observations while preserving the temporal ordering of the data. Unlike conventional cross-validation methods, which randomly partition observations, rolling-origin evaluation respects the sequential structure of time series data and therefore provides a more realistic estimate of out-of-sample forecasting performance.

At each evaluation window, models were trained using all observations available up to a given cutoff date and subsequently used to generate forecasts for the next four weeks. The forecasting origin was then advanced by a fixed step size, and the process was repeated across ten rolling evaluation windows spanning the dataset. This approach allows model performance to be assessed under a variety of historical forecasting scenarios while reducing the risk that results are dependent on a particular train-test split.

The number of evaluation windows was determined dynamically based on the available sample size, forecast horizon, seasonal period, and step size, yielding ten valid evaluation windows in the present study. This ensured that each model was evaluated on the maximum number of valid forecasting windows while maintaining sufficient observations for model training.

Forecast accuracy was measured using the Relative Mean Absolute Error (RMAE). RMAE compares the absolute forecasting error of a model against that of a reference benchmark and is defined as

$ "RMAE" = ("MAE"_"model") / ("MAE"_"baseline") $

where $"MAE"_"model"$ is the mean absolute error of the evaluated model and $"MAE"_"baseline"$ is the mean absolute error of the benchmark model.

The Seasonal Naive model was selected as the baseline because it provides a strong and widely accepted benchmark for seasonal time series forecasting. An RMAE value below 1 indicates that a model outperforms the Seasonal Naive benchmark, whereas a value above 1 indicates inferior performance. This relative formulation facilitates direct comparison across models and highlights whether additional model complexity translates into meaningful forecasting improvements.

= Results

#figure(image("RMAE over Cross-validation windows by model.svg"), caption: [RMAE over Cross-validation windows by model]) <fig-rmae>

@fig-rmae indicates that model performance varies across evaluation windows. In general, more sophisticated forecasting models exhibit lower RMAE values in later cross-validation cutoffs, where larger training sets are available. This trend suggests that complex models benefit from additional historical information, enabling them to learn recurring temporal patterns more effectively than simpler benchmark methods. While simpler models remain competitive when data are limited, the performance advantage of more advanced models becomes increasingly apparent as the amount of training data grows.

#figure(
  table(
    columns: 2,
    align: (left, center),

    table.header(
      [Model], [RMAE]
    ),

    [AutoARIMA], [0.397],
    [CES], [0.426],
    [AutoTBATS], [0.522],
    [AutoTheta], [0.557],
    [AutoMFLES], [0.596],
    [AutoETS], [0.875],
    [SeasonalNaive], [1.000],
  ),
  caption: [Mean aggregated RMAE obtained from rolling cross-validation.]
)


= Conclusion

This internship at Barid Al-Maghrib provided an end-to-end implementation of a forecasting pipeline for Morocco’s outgoing international mail flows, from raw data extraction to model evaluation and interpretation of results.

The work demonstrated that reliable forecasting is achievable despite significant constraints in data infrastructure, including the absence of APIs, unstable reporting systems, and heterogeneous data sources. A robust data engineering pipeline based on automated web scraping, HTML archival, and Parquet conversion was necessary to construct a consistent analytical dataset.

From a modeling perspective, classical statistical forecasting methods remain highly competitive for this type of operational time series. In particular, ARIMA, CES, and TBATS showed strong performance under rolling-origin evaluation, while simpler baselines such as Seasonal Naive remained difficult to outperform under limited training windows. The results confirm that model performance improves significantly as additional historical data becomes available.

The application of conformal prediction enabled uncertainty quantification for models that do not natively provide prediction intervals, ensuring a consistent evaluation framework across all approaches.

Overall, this work highlights the value of combining domain knowledge, robust data engineering, and established forecasting techniques to support operational decision-making. The resulting framework can be extended to other postal flows and adapted to evolving business requirements within Barid Al-Maghrib.

= Appendix

/*
== Suivi des expéditions par site destination:
The backend is very slow, and crashes if I request more than a 6 month period. And there is no available API so I had to use use the Playwright library to automate exporting CSV files from the web portal.

There were some duplicate rows, so I filtered by unique CAB.
#figure(table(
  columns: 2,
  align: (left, right),
  stroke: 0.5pt,
  table.header([Column], [Unique values]),

  [CAB], [235799],
  [CLIENT], [4787],
  [SERVICES_OPTIONNELS], [163],
  [SITE_EXPEDITEUR], [106],
  [RECEPTION], [2],
  [DERNIER_STATUT], [9],
  [DATE_DERNIER_STATUT], [108900],
  [SITE_DERNIER_STATUT], [8],
  [DESTINATION], [565],
))
*/
/*
== Situation journalière de distribution
I could only get daily data, so I, again, had to use Playwright to automate the collection of data.
#figure(zebraw(
  ```csv
centre,nbr1,nbr3,nbr6,nbr8,nbr10,nbrreexp1,nbranoma1,rnbraffg,Textbox17
CENTRE COURRIER COLIS LAAYOUNE,201,171,24,3,1,0,0,82,1

centre1,nbraff,nbr_affecomm,nbr_affautre,nbrliv,nbr_ecommerce,nbr_autres
CENTRE COURRIER COLIS LAAYOUNE,200,12,188,171,6,165
```
),caption: [Example csv file for 2024-9-20])

The top half refers to the current state. The bottom half refers to the sate 1 day after 2024-9-20.

+ collect all the data from 2024-1-1 to 2026-5-6
+ split the data by current / d-one
+ add a timestamp
+ concatenate the data

the output is a dataframe by 

I collect all the data from 2024-1-1 to 2026-5-6. Then I split the data by current / d-one. Then I add a timestamp, then I concatenate all the data.
*/
/*
=== Visualizations
#figure(image("package_count_by_status_from_2024_to_2026_by_year_CENTRE COURRIER COLIS LAAYOUNE.png"),caption: [package count from 2024 to 2026 by year and by last status at CENTRE COURRIER COLIS LAAYOUNE])
#figure(image("package_count_2026_by_month_CENTRE COURRIER COLIS LAAYOUNE.png"),caption: [package count during 2026 by month and by last status at CENTRE COURRIER COLIS LAAYOUNE])
#figure(image("Screenshot_8-5-2026_143319_.jpeg"),caption: [standalone html interactive seasonal plot of package count by Month and Year. The blue line is the mean.])
*/
/*
== Filter for stale packages
some packages get received by the site but they don't get delivered, we'll call these stale packages 

+ import CSV from the "SUIVI DE EXPEDITIONS EN INSTANCE PAR SITE" view 
+ filter out sites outside the Laayoune region (using a publically available dataset of BAM sites by region from data.gov.ma)
+ filter out already delivered packages
+ filter out recently received packages

deployed as a standalone executable using `PyInstaller`

== Visualize stale Packages
`liv` and `liv_ret` don't matter because they're already delivered

// #figure(image("1f934023-d2f3-441e-8a93-87c968bac040.png"), caption: [Sites by the count of their last status])

#figure(image("4ba7ba49-7c21-4380-8f6d-15f3e81fcc13.png"), caption: [Sites by the ratio of the last status of the packages they received during month 4,  at the end of month 4])
*/


== History of Barid Al-Maghrib (BAM)
In 1892, the first postal service in Morocco was established by royal decree.

In 1911, Compagnie Marocaine du Télégraphe was tasked with organizing the national postal service. The new postal service was based on a European model and began operations on  1912 under the name Administration Chérifienne des Postes des Télégraphes et des Téléphones. It issued its first stamp on May 22, 1912.

In 1956, the year of Morocco's independence, postal and telecommunications services were placed under the supervision of the ministry of Post, Telegraph and Telephone.

In 1984, The Office National des Postes et des Télécommunications (ONPT) was created 

In 1998, Barid Al-Maghrib became a Moroccan public institution following the entry into force of Law 24-96 and the separation of the postal and telecommunications sectors. 

In 2010 Barid Al-Maghrib was privatized as a public limited company (société anonyme).

== Interesting visualizations

#figure(image("Ratio of outgoing international deliveries by deposit agency.svg"), caption: [Ratio of outgoing international deliveries by deposit agency

32% of outgoing international deliveries start from `AGENCE AM MARRAKECH GUELIZ`])

#figure(image("Ratio of outgoing international deliveries by last forwarded agency.svg"),caption: [Ratio of outgoing international deliveries by last forwarded agency

97% of outgoing international deliveries goes out through `CENTRE NATIONAL DEDOUANEMENT POSTAL`])

== Abbreviations
- SMI: Système de Messagerie Intégré
- PR: Poste Restante
- PoD: Pay on Delivery
- CRBT: Contre-Remboursement
- CEC: Client On Compte
- CCP / CCABB: Compte Courant Poste /  Compte Courant Al Barid Bank
- MEI: Mise On Instance
- MED: Mise En Distribution
- BC: Barid Cash
- PP: Petits Paquets

== Status meaning
=== French
- `depot`: depot
- `lev`: Levée envoi
- `recpt`: Reçu par
- `aexp`: Expédié vers
- `aff`: 	Mis en distribution
- `affg`: En instance au guichet
- `chrgctr`: Deuxième tentative pour complément d'adresse/ ou livraison
- `recg`: Avisé au guichet
- `nrcl`: Non réclamé
- `liv`: Livré
- `liv_ret`: Livraison retour
-	`anoma`: Mis en rebus


=== English
- `depot`: the sender deposits the package at a site
- `lev`: the package is collected from sender by the postal service
- `recpt`: the package is received by site
- `aexp`: the package is forwarded to site
- `affg`: the package is being held at the post office awaiting pickup by the recipient
- `aff`: the package is put into distribution
- `chrgctr`: Second attempt for additional address information/or delivery
- `recg`: the recipient has been notified that the item is available for pickup at the counter
- `nrcl`: the package is not claimed, these packages stay in storage at the site for a defined period before being returned to sender. If the sender also doesn't claim it, it's moved to long-term storage
- `liv`: the package is successfully delivered
- `liv_ret`: the package is successfully returned to sender
-	`anoma`: the package is disposed of


/*
==== The life-cycle of a parcel:
+ Parcel is deposited by the sender 
+ Parcels are grouped into sacs according to their destination
+ Sacs are transported to the destination written on their label
+ When sacs arrive at their destination, they are emptied
+ Parcels are assigned to postmen according to their address, each postman is responsible for a specific region.
+ The postman calls the recipient to ask them to confirm their address and when they'll be available to receive the parcel at home, or when they'll be available to pick it at the counter. The address on the parcel is often not specific enough, so the postman might ask for a more specific address.
*/

/*
This diagram is a simplification, real operations often require more flexibility

#diagram(
  node-stroke: 1pt,

  // --- Nodes ---
  node((0,1), name:<lev>, corner-radius: 2pt, extrude: (0,3))[lev: Collected from sender],
  edge( "-|>", <recpt>),
  node((1,1), name:<depot>, corner-radius: 2pt, extrude: (0,3))[deppt: Deposited by sender],
  edge("-|>"),
  node((0,2), name:<recpt>)[recpt: Received at site],
  edge("-|>"),
  node((0,3), name:<recpt>)[Put in sac according to destination],
  edge("-|>"),
  node((0,4), name:<aexp>)[aexp: Forwarded to destination],
  edge("-|>"),
  node((0,5), name:<recpt>)[Remove from sac and distribute to \
  mailmen according to their address],
  edge("-|>"),
  node((0,6), shape: shapes.diamond, name:<decision_1>)[valid address?],
  edge("-|>", <aff>)[No],
  edge("-|>",)[Yes],
  node((0,7), shape: shapes.diamond, name:<decision_1>)[Preferred delivery method],
  edge("-|>", <recg>)[pickup],
  edge("-|>",)[At home],
  node((1,8))[Attempt to deliver package],
  node((0,8), name:<recg>)[recg: recipient is notified for pickup],
  node((1,6), name:<aff>)[aff: Awaiting recipient instructions],
  edge("-|>"),

  // node((0,8), shape: shapes.diamond, name:<decision_3>)[
  //   Delivery decision:\ 
  //   valid address?\ 
  //   pickup?\ 
  //   retry?
  // ],

  // node((1,7), name:<chrgctr>)[chrgctr: Retry contact],
  // node((0,9), name:<affg>)[affg: Held at post office],
  // node((0,10), name:<nrcl>)[nrcl: Not claimed],

  // node((-1,8), name:<liv>, corner-radius: 2pt, extrude: (0,3))[liv: Delivered],
  // node((1,10), name:<liv_ret>, corner-radius: 2pt, extrude: (0,3))[liv_ret: Returned to sender],
  // node((0,10), name:<anoma>, corner-radius: 2pt, extrude: (0,3))[anoma: Disposed of],

  // --- Main Flow ---

  // // --- Decision Branches ---
  // edge(<decision_3>, <liv>, "-|>", [valid_address_home_delivery]),
  // edge(<decision_3>, <recg>, "-|>", [pickup_selected]),
  // edge(<decision_3>, <chrgctr>, "-|>", [invalid_or_missing_address]),

  // // --- Retry Loop ---
  // edge(<chrgctr>, <aff>, "-|>", [retry_contact]),

  // // --- Pickup Flow ---
  // edge(<recg>, <affg>, "-|>"),
  // edge(<affg>, <liv>, "-|>", [picked_up]),
  // edge(<affg>, <nrcl>, "-|>", [pickup_deadline_exceeded]),

  // // --- Return Flow ---
  // edge(<nrcl>, <liv_ret>, "-|>", [return_to_sender])
)
*/

/*
=== client types:
===== client particulier 
===== CEC
===== e com

=== subsidiaries of Barid Al Maghrib:
===== Al Barid Bank
===== E.M.S [Chronopost](https://fr.wikipedia.org/wiki/Chronopost "Chronopost") International Maroc
===== Société Marocaine de Distribution et Transport de Marchandises et de Messageries (SDTM)
===== Barid Media
= products
== courrier / mail
== AMANA optional services

=== Cash on delivery
==== Contre Remboursement par Courrier (CRCOUR)
==== Contre Remboursement Espèces CCP (CRESPCCP)

=== Proof of Delivery (POD)
==== Accusé de Réception (AR)
Return Receipt. A physical, signed card is mailed back to the sender as legal proof that the recipient received the parcel.
==== Proof of Delivery SMS (PODSMS)

=== Declared Value (VD)
The "declared value" service allows customers to ship valuables safely. By choosing this service, the sender benefits from insurance covering risks, up to a maximum of 50,000 DH per package.

=== Fragile item (FRA)

=== Packaging
Bubble wrap,
Amana plastic envelope with secure closure,
==== Cylindrical packaging in two models
- MOD1CAMA
- MOD2CAMA
==== Cardboard boxes in 5 models
- MOD1AMA
- MOD2AMA
- MOD3AMA
- MOD4AMA
- MOD5AMA


==== Distribution à Domicile (DAD)
==== Droit de Timbre de Quittance (DTQ) 
0.25% tax on cash transactions above 10000DH per day
==== Enveloppe Amana (ENVAMA)
Standard prepaid Amana cardboard envelope.
==== Enveloppe Bulle Amana (ENVBAMA)
Padded Amana envelope (with bubble wrap inside) for small, fragile items.

==== Modèle Plastique (MODPL)
==== NDPSMS
==== Pochette Amana (POCAMA)
Amana plastic shipping pouch
==== TRS
==== TRSNAT




courrier recommandé
courrier prioritaire
e-barki@ pro
boite postale
=== fiabilisation d’adresse
==== RNVP 
checking if an address is valid
==== GéoAdresse
linking addresses to geographic data
==== CodAdresse
standardizing addresses
== Parcels
Through the Amana brand
All packages up to 30 kg

*/