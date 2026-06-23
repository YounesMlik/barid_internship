#import "@preview/touying:0.7.4": *
#import themes.university: *
#import "@preview/numbly:0.1.0": *
#import "@preview/fletcher:0.5.8" as fletcher: node, edge
#import "@preview/cetz:0.5.2"
#import "@preview/theorion:0.6.0": *


#show: show-theorion

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Analysis and Forecasting of Morocco's Outgoing International Mail Flows],
    subtitle: [Operational pipeline + forecasting study],
    author: [Younes MLIK],
    date: datetime.today(),
    institution: [Barid Al-Maghrib Internship],
    logo: emoji.mailbox,
  ),
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

== Outline
#outline(depth: 1)


= Context

== Problem context

- Outgoing international mail must be forecasted for operational planning  
- Horizon: 4 weeks ahead  
- Targets:
  - package count  
  - total weight  

Key constraint:
- data exists but is not directly usable for analytics  

== Operational environment

Work done at:
- Barid Al Maghrib 

Constraints:
- no API access  
- legacy reporting system (SMI)  
- HTML-based tracking interface  
- unstable long-range queries  


= Data acquisition

== Main challenge

- no structured API  
- reports fail beyond ~6 months  
- tracking only per parcel ID  
- output = HTML, not CSV  

Result:
- manual extraction impossible at scale  

== Extraction approach

Solution:

- Playwright automation (Python)
- chunked queries (daily / short range)
- retry + resume mechanism
- session recovery on failure

Goal:
- simulate human interaction reliably at scale  

== Storage transformation

Tracking dataset:

#table(
  columns: 2,
  table.header([Stage], [Size]),

  [Raw HTML], [10.2 GB],
  [Processed Parquet], [35 MB],
)

Key step:
- HTML → structured parsing → Parquet compression  

= data preparation

== Key cleaning steps

- remove invalid records (`Etat`, `is_valid`)
- remove duplicates (CAB / `codeenvoi_`)
- filter pre-2023 sparse data
- keep outgoing flows only

Decision:
- focus on deposit date (most reliable timestamp)

== Target variables

- package count  
- total weight  

Excluded:
- volume (incomplete before 2026)


= exploratory insights

== Seasonality pattern

- strong peak before Ramadan  
- recurring yearly structure  

Interpretation:
- diaspora shipment behavior  

== Trend behavior

- gradual decrease in volume  
- stable weekly structure  

Interpretation:
- increased competition

= forecasting setup

== Problem definition

- horizon: 4 weeks ahead  
- rolling evaluation  
- time series forecasting setup  

== Transformation

- logarithmic transform applied  
- reason:
  - stabilize variance  
  - improve model stability  

Forecasts later converted back via exponential transform  


= models

== Model groups

#table(
  columns: 2,
  table.header([Linear], [Models]),

  [Linear Stochastic], [ARIMA],
  [State-space], [ETS, CES, TBATS],
  [Decomposition], [Theta], 
  [Ensemble], [MFLES],
)

== Baseline
  
- Mean Average Error used for relative evaluation  
- Seasonal Naive used as reference

= uncertainty

== Conformal prediction

Used only for MFLES:

- model-agnostic method  
- based on past residuals
- does not assume normal distribution 

= evaluation

== Methodology

- rolling-origin cross-validation  
- 10 evaluation windows  
- 4-week forecast horizon  

== Metric
$ "MAE" = 1/n sum_(i=1)^n |y_i - hat(y)_i| $

$ "RMAE" = "MAE"_"model" / "MAE"_"baseline" $

Interpretation:
- < 1: better than baseline  
- > 1: worse than baseline  


= results

== Model performance

#table(
  columns: 2,
  table.header([Model], [RMAE]),

  [AutoARIMA], [0.397],
  [CES], [0.426],
  [AutoTBATS], [0.522],
  [AutoTheta], [0.557],
  [AutoMFLES], [0.596],
  [AutoETS], [0.875],
  [SeasonalNaive], [1.000],
)

== Key observation

- ARIMA and CES perform best overall  
- complex models improve with more data  
- baseline remains strong but consistently outperformed  


= conclusion

== Summary

- full pipeline built from unstable systems  
- raw HTML → structured dataset  
- forecasting models evaluated consistently  

== Final insight

Main difficulty was not modeling:

- it was data acquisition and reconstruction 