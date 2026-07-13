The `smi_envoisbyproduitintern` dataset constituted the primary source of information used to reconstruct historical shipment deposits. In particular, it provided the *Date_depot* variable, which was subsequently employed to build weekly aggregated time series.

No programmatic interface was available to access this data. Furthermore, the underlying web application exhibited significant performance limitations and frequently failed when requesting periods longer than six months. Consequently, a fully automated extraction workflow was developed using the Playwright library. The extraction process iterated over successive time intervals from January 2023 to May 2026, automatically interacting with date pickers, dropdown menus and CSV export functionalities exposed by the web portal.

Duplicate observations were removed using the `codeenvoi_` identifier, which acts as a shipment-level unique key. After the deduplication step, the dataset contained 195,858 observations.

@tab-smi-cardinality summarizes the cardinality of the main variables. The number of distinct values associated with `codeenvoi_` is very close to the total number of observations, indicating that only a limited number of duplicate records were present in the raw exports.

#figure(
  table(
    columns: 2,

    table.header([*Feature*], [*Unique values*]),

    [`codeenvoi_`], [195844],
    [`datedepot`], [117202],
    [`origine`], [2],
    [`destination_`], [184],
    [`site_depot_`], [800],
    [`pouds_reel_`], [13354],
    [`longueur_`], [187],
    [`largeur_`], [218],
    [`hauteur_`], [114],
    [`poids_volume_`], [4272],
  ),
  caption: [Cardinality summary for the `smi_envoisbyproduitintern` dataset],
)<tab-smi-cardinality>

@tab-smi-stats presents descriptive statistics for the numerical and temporal variables available in the extracted data. Several dimensional attributes exhibit substantial missingness, whereas the shipment weight variable remains complete. These observations motivated the later decision to focus primarily on shipment counts and aggregate weights for forecasting purposes.

#figure(
  table(
    columns: 7,

    table.header(
      [*Statistic*],
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
  ),
  caption: [Descriptive statistics for the `smi_envoisbyproduitintern` dataset],
)<tab-smi-stats>


The `smi_envoisbyproduitintern` dataset played a central role in the data acquisition process. Besides providing an initial view of shipment activity, it constituted the source from which all shipment identifiers (`codeenvoi_`) were extracted.

These identifiers were subsequently used to automate requests to the shipment tracking webpage. Since no bulk export mechanism or public API was available, each shipment had to be queried individually. The resulting HTML responses were archived and later transformed into structured parquet datasets used throughout the remainder of this work.

Consequently, `smi_envoisbyproduitintern` should be considered as the entry point of the complete data acquisition pipeline rather than merely an exploratory dataset.
