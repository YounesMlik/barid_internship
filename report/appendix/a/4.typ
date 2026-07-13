The HTML parsing procedure described in @appendix_data_tracking_extraction produced four parquet datasets corresponding to different aspects of shipment information. While all datasets were explored during the internship, only the `fields` dataset was ultimately employed for the forecasting pipeline presented in @chapter_methodology and @chapter_realization.

The remaining datasets are nevertheless documented in this appendix because they may support future investigations related to shipment routing, delivery performance analysis, and customer service studies.

=== `fields.parquet`

The `fields` dataset contains shipment-level attributes extracted from the tracking pages. It combines operational characteristics, customer information, shipment dimensions, and destination data.

For the forecasting study, observations were filtered to retain only valid shipments. More specifically, records whose `Etat` variable indicated an invalid status were discarded. Additionally, only observations with a deposit date greater than or equal to January 1, 2023 were considered, as earlier periods exhibited substantial sparsity and would not provide a sufficiently stable basis for model training.

After preprocessing, the dataset contained 234,718 observations.

@tab-fields-cardinality summarizes the cardinality of the principal variables contained in the dataset.

#figure(
  table(
    columns: 2,

    table.header([*Feature*], [*Unique values*]),

    [`Cab`], [234716],
    [`Id`], [234718],
    [`Date_depot`], [1041],
    [`Type_cab`], [4],
    [`Dernier_statut`], [10],
    [`Regime`], [3],
    [`Contrat`], [4843],
    [`Etat`], [1],
    [`Poids_global_en_KG`], [12435],
    [`Centre_Agence_depot`], [1484],
    [`Destination`], [563],
    [`Client`], [6892],
    [`Produit_Niveau_Service`], [16],
    [`Mode_paiement`], [7],
    [`Taxe_DTQ_Dhs`], [3],
    [`Canal_de_livraison_1`], [3],
    [`Canal_de_livraison_2`], [442],
    [`Longueur`], [296],
    [`Hauteur`], [114],
    [`Largeur`], [191],
    [`Poids_Volumetrique`], [39],
  ),
  caption: [Cardinality summary of the `fields` dataset],
)<tab-fields-cardinality>

The large number of distinct values associated with variables such as `Centre_Agence_depot`, `Destination`, and `Client` highlights the highly heterogeneous nature of international postal activity.

@tab-fields-stats presents descriptive statistics for the principal numerical variables.

#figure(
  table(
    columns: 8,

    table.header(

      [*Statistic*],

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
  ),
  caption: [Descriptive statistics of the `fields` dataset],
)<tab-fields-stats>

Several observations can be made from @tab-fields-stats. First, shipment weights exhibit considerable variability, ranging from very small packets to consignments exceeding one metric ton. Second, volumetric measurements are frequently unavailable, suggesting that these variables may not be systematically recorded during operational processing. Finally, the temporal distribution of deposit dates confirms that the selected study period provides a sufficiently dense and continuous basis for time-series modeling.

The `fields` dataset constitutes the primary analytical source employed throughout the forecasting workflow developed in this internship.


=== `operations.parquet`

The `operations` dataset contains the sequence of operational events recorded throughout the life cycle of each shipment. In contrast to the `fields` dataset, which provides a static description of parcels, this dataset captures the temporal evolution of their processing within the postal network.

The original `Etat` field contained composite textual information describing both the operation type and its validation status. To facilitate subsequent analyses, a preprocessing step based on regular expressions was implemented to extract two normalized variables:

- `status_code`, representing the operation category;
- `is_valid`, indicating whether the operation was validated by the information system.

For example, the value

```text
[ depot ] VALIDE (V)
```

was transformed into

```text
status_code = "depot"
is_valid = "V"
```

Only validated operations were retained for analysis. Furthermore, a filter based on `status_code` was applied to restrict the dataset to outgoing shipment events, as incoming international shipments represented only a negligible fraction of the available observations.

After preprocessing, the dataset contained 2,077,161 records.

@tab-operations-cardinality summarizes the cardinality of the principal variables contained in the dataset.

#figure(
  table(
    columns: 2,

    table.header([*Feature*], [*Unique values*]),

    [`cab`], [244091],
    [`id`], [257828],
    [`Date_operation`], [1546],
    [`Heure_Syst_Oper`], [438442],
    [`Statut`], [29],
    [`Agence`], [1574],
    [`Agent_oper`], [5475],
    [`Etat`], [14],
    [`Date_Etat`], [1359],
    [`Agent_maj`], [2],
    [`ORIGINE`], [5],
    [`status_code`], [14],
    [`is_valid`], [1],
  ),
  caption: [Cardinality summary of the `operations` dataset],
)<tab-operations-cardinality>

The large number of operational records relative to the number of shipments reflects the fact that parcels generally undergo multiple processing stages before reaching their final destination.

@tab-operations-stats presents descriptive statistics for the temporal variables available in the dataset.

#figure(
  table(

    columns: 3,

    table.header(

      [*Statistic*], [`Date_operation`], [`Heure_Syst_Oper`],
    ),

    [Null Count], [0], [0],

    [Mean], [2024-08-09], [2024-08-10 03:50],

    [Std], [---], [---],

    [Min], [2022-01-03], [2022-01-03 09:09],

    [25%], [2023-10-23], [2023-10-23 10:09],

    [50% (Median)], [2024-08-09], [2024-08-09 16:26],

    [75%], [2025-06-14], [2025-06-14 09:19],

    [Max], [2026-05-11], [2026-05-11 15:28],
  ),

  caption: [Descriptive statistics of the `operations` dataset],
)<tab-operations-stats>

@tab-operations-stats confirms that the operational history spans a sufficiently long period to support analyses of processing delays, shipment routing patterns, and service performance indicators.

Although this dataset was not incorporated into the forecasting models developed in this internship, it represents a potentially valuable resource for future studies focused on operational efficiency, bottleneck detection, transit time estimation, or process mining applications.


=== `delivery.parquet`

The `delivery` dataset contains information related to the final delivery stage of shipments, including delivery dates, payment transfers, beneficiary information, and monetary amounts associated with financial services.

After parsing and consolidation, the dataset comprised 241,781 observations.

@tab-delivery-cardinality summarizes the cardinality of the main variables available in the dataset.

#figure(
  table(
    columns: 2,

    table.header([*Feature*], [*Unique values*]),

    [`cab`], [241431],
    [`id`], [241431],
    [`agence_liv`], [222],
    [`date_liv`], [1287],
    [`date_transf_ccp`], [1016],
    [`montant`], [6335],
    [`beneficiaire`], [14481],
    [`n_pid`], [2526],
    [`statut`], [13],
    [`origine`], [6],
    [`etat`], [3],
    [`N_compte_Infos`], [4738],
    [`N_cheque_N_reçu_TPE`], [7],
  ),
  caption: [Cardinality summary of the `delivery` dataset],
)<tab-delivery-cardinality>

The relatively large number of unique beneficiaries and financial accounts suggests that this dataset could support future studies related to customer behavior, payment mechanisms, and delivery service analysis.

@tab-delivery-stats presents descriptive statistics for the principal temporal and numerical variables.

#figure(
  table(

    columns: 4,

    table.header(

      [*Statistic*], [`date_liv`], [`date_transf_ccp`], [`montant`],
    ),

    [Null Count], [1], [1], [1],

    [Mean], [2024-08-21], [0355-06-11], [282.97],

    [Std], [---], [---], [1743.92],

    [Min], [2022-01-05], [0001-01-01], [0.0],

    [25%], [2023-10-25], [0001-01-01], [0.0],

    [50% (Median)], [2024-09-03], [0001-01-01], [0.0],

    [75%], [2025-07-03], [0001-01-01], [0.0],

    [Max], [2026-05-11], [2026-05-09], [102800.0],
  ),

  caption: [Descriptive statistics of the `delivery` dataset],
)<tab-delivery-stats>

As shown in @tab-delivery-stats, the `date_transf_ccp` variable contains placeholder dates corresponding to uninitialized values in the operational system. These observations would require additional preprocessing before being used for analytical purposes.

The highly skewed distribution of `montant` indicates that while most shipments are not associated with financial transactions, a small number involve substantial transferred amounts. Although this dataset was not incorporated into the forecasting workflow developed during the internship, it may provide valuable insights for future studies focusing on cash-on-delivery services, payment processing delays, and customer financial behavior.

=== `services.parquet`

The `services` dataset describes optional services associated with shipments, including cash collection, account-based payment services, and supplementary customer information.

After extraction and transformation, the dataset contained 205,931 observations.

@tab-services-cardinality summarizes the cardinality of the available variables.

#figure(
  table(

    columns: 2,

    table.header([*Feature*], [*Unique values*]),

    [`cab`], [134293],
    [`id`], [134295],
    [`Libelle_service`], [19],
    [`Num_compte`], [4939],
    [`Mnt_a_percevoir`], [7002],
    [`Adr/compte service`], [2168],
    [`Gsm`], [20952],
    [`Taxe_TTC`], [166],
    [`ORIGINE`], [3],
  ),

  caption: [Cardinality summary of the `services` dataset],
)<tab-services-cardinality>

The diversity of service labels reflects the broad range of value-added services offered by BAM, including financial products and account-linked delivery options.

@tab-services-stats presents descriptive statistics for the monetary variables available in the dataset.

#figure(
  table(

    columns: 3,

    table.header(
      [*Statistic*], [`Mnt_a_percevoir`], [`Taxe_TTC`],
    ),

    [Null Count], [2], [3],

    [Mean], [482.14], [14.80],

    [Std], [2199.64], [27.09],

    [Min], [0.0], [0.0],

    [25%], [0.0], [0.0],

    [50% (Median)], [0.0], [0.0],

    [75%], [300.0], [35.0],

    [Max], [102800.0], [999.0],
  ),

  caption: [Descriptive statistics of the `services` dataset],
)<tab-services-stats>

The distributions presented in @tab-services-stats reveal a strong concentration of observations around zero values, indicating that many shipments are not associated with optional paid services. Nevertheless, the existence of high-value transactions suggests that this dataset may support future analyses related to PoD, CRBT, CEC, CCP, and other financial services offered by BAM.

Although the `delivery` and `services` datasets were not employed in the forecasting models developed during this internship, they enrich the analytical data layer and may constitute valuable resources for subsequent studies addressing customer segmentation, service utilization patterns, or financial process optimization.


