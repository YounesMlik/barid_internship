
The `smi_suiviexpedition` dataset was extracted during the exploratory phase of the internship to investigate the feasibility of analyzing shipments transiting through specific operational centers, particularly Laayoune.

Although the dataset was ultimately not incorporated into the forecasting pipeline presented in this report, it is documented here for completeness and because it may support future studies related to regional traffic analysis, transit monitoring, or service performance assessment.

After extraction and cleaning, the dataset contained 244,147 observations.

@tab-suivi-cardinality summarizes the cardinality of the principal variables.

#figure(
  table(
    columns: 2,

    table.header([*Feature*], [*Unique values*]),

    [`CAB`], [244147],
    [`CLIENT`], [4830],
    [`SERVICES_OPTIONNELS`], [165],
    [`SITE_EXPEDITEUR`], [107],
    [`RECEPTION`], [2],
    [`DERNIER_STATUT`], [9],
    [`DATE_DERNIER_STATUT`], [111994],
    [`SITE_DERNIER_STATUT`], [8],
    [`DESTINATION`], [568],
  ),
  caption: [Cardinality summary of the `smi_suiviexpedition` dataset],
)<tab-suivi-cardinality>


The dataset exhibits a relatively large number of destinations and customers, suggesting a broad geographical and operational coverage.

@tab-suivi-stats presents descriptive statistics for the available temporal variable.

#figure(
  table(

    columns: 2,

    table.header([*Statistic*], [`DATE_DERNIER_STATUT`]),

    [Null Count], [0],

    [Mean], [2024-08-21 21:07],

    [Std], [---],

    [Min], [2022-01-05 00:00:00],

    [25%], [2023-10-25 12:16:00],

    [50% (Median)], [2024-09-03 09:20:54],

    [75%], [2025-07-03 15:38:41],

    [Max], [2026-04-28 14:42:43],
  ),

  caption: [Descriptive statistics of the `smi_suiviexpedition` dataset],
)<tab-suivi-stats>


As shown in @tab-suivi-stats, the dataset covers a temporal span comparable to the other operational datasets extracted during the internship. However, since it was not directly linked to the forecasting objective defined in @chapter_methodology, it was excluded from the final analytical workflow.

Nevertheless, the dataset could constitute a useful resource for future investigations focused on shipment routing, regional traffic characterization, or the analysis of operational bottlenecks within the postal network.
