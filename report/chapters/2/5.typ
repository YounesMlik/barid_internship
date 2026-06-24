The objective of the forecasting stage is to predict future international postal activity based on historical observations. However, the data collected from operational information systems are recorded at the shipment level and therefore cannot be directly used by forecasting models. A dedicated processing stage was consequently implemented to transform transactional data into regularly spaced time series suitable for statistical analysis.

=== Selection of the Reference Dataset

Several datasets were collected during the extraction phase, including deposit records, parcel tracking events, delivery information and optional service data. Although these datasets provide complementary perspectives on postal operations, not all of them are suitable for demand forecasting.

The *Envois by produit international* dataset was selected as the primary forecasting source because it contains the date of deposit for every outgoing international shipment and exhibits the highest level of completeness over the study period.

Tracking information was not used directly for forecasting purposes. Once parcels leave Morocco, subsequent events are often unavailable or only partially observed. Consequently, the deposit date constitutes the earliest and most reliable indicator of outgoing international demand.

Delivery-related datasets and optional service information were retained for exploratory analyses but were excluded from model training.

=== Temporal Scope of the Study

Preliminary investigations revealed that historical records prior to 2023 are sparse and highly irregular. Large periods contained very few observations, making them unsuitable for robust estimation of seasonal components.

To ensure sufficient temporal consistency, only observations collected between January 2023 and April 2026 were retained.

This filtering step improves the reliability of statistical inference while maintaining an observation window sufficiently long to capture annual seasonal patterns.

=== Definition of Forecast Variables

The forecasting task focuses on two operational variables:

- Number of deposited parcels;
- Total deposited weight.

These variables were selected because they directly influence several operational decisions, including:

- transportation planning;
- workforce allocation;
- international dispatch scheduling;
- storage capacity management.

Parcel dimensions were intentionally excluded from the forecasting process due to their high proportion of missing values, particularly before 2026.

=== Weekly Aggregation

Raw shipment data are available at the individual parcel level. Since postal demand exhibits strong day-to-day fluctuations and operational planning is generally performed over weekly horizons, observations were aggregated by calendar week.

For each week $t$, the following quantities were computed:

$"Count"_t = sum_i 1$

and

$"Weight"_t = sum_i w_i$

where $w_i$ denotes the real weight associated with shipment $i$.

Weekly aggregation presents several advantages:

- reduction of daily noise;
- mitigation of holiday effects;
- improved stability of seasonal estimates;
- compatibility with medium-term planning horizons.

=== Seasonality Investigation

Exploratory analyses revealed a recurrent increase in parcel volumes during the weeks preceding Ramadan.

This phenomenon can be explained by the significant Moroccan diaspora residing abroad, which frequently sends food products, gifts and personal items to relatives before the beginning of Ramadan.

Visual inspection suggests that this effect is stronger than conventional annual seasonality and therefore represents an important characteristic of the studied series.

No explicit Ramadan regressors were introduced in this study. Instead, forecasting models were expected to capture these patterns implicitly through historical observations.

=== Variance Stabilization

Forecasting methods such as ETS and ARIMA often assume approximately constant variance over time.

Visual analysis indicated that fluctuations tend to increase during periods of high postal activity.

A logarithmic transformation was therefore applied:

$z_t = log(y_t)$

where $y_t$ represents either weekly parcel counts or weekly deposited weight.

The transformation offers several advantages:

- reduction of heteroscedasticity;
- improved numerical stability;
- guaranteed positivity after inverse transformation.

Forecasts generated on the transformed scale were converted back to their original units through the exponential function.

=== Forecasting Horizon

The forecasting problem was formulated as a four-week-ahead prediction task.

A forecasting horizon of four weeks was selected because it provides a reasonable compromise between operational usefulness and predictive reliability.

Shorter horizons generally offer limited planning capabilities, whereas longer horizons tend to accumulate uncertainty.

The objective can therefore be written as:

$hat(y)_(t+h)$

for

$h in {1,2,3,4}$

where each forecast corresponds to one future week.

=== Final Dataset Structure

After preprocessing and aggregation, the final analytical dataset contains:

- weekly timestamp;
- parcel count;
- total deposited weight;
- mean parcel weight;
- transformed variables.

The resulting series constitute the input used by all forecasting models evaluated in the following chapter.

=== Summary

The construction of the forecasting dataset transforms heterogeneous shipment-level observations into coherent weekly time series representative of Morocco's outgoing international postal activity.

This stage bridges the gap between operational information systems and statistical forecasting models, ensuring that the subsequent analysis is performed on stable, interpretable and operationally meaningful indicators.