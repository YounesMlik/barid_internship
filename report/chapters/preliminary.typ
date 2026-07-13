#let dedication = [
  I dedicate this work to my parents for their continuous support, encouragement, and sacrifices throughout my studies.

  To my family and friends, for their patience, motivation, and confidence in me during the completion of this internship.

  To all my teachers, who contributed to my education and helped me acquire the knowledge and skills necessary to reach this stage of my academic journey.

  Finally, I dedicate this modest work to everyone who supported me, directly or indirectly, throughout my studies.
]

#let acknowledgments = [
  First of all, I would like to sincerely thank Barid Al-Maghrib for giving me the opportunity to carry out this internship and for welcoming me into its working environment.

  I would like to express my deepest gratitude to Mr. EDDYA Moulay Lahcen, my internship supervisor, for his guidance, availability, and valuable advice throughout this internship. His support and remarks were of great help in carrying out this work.

  I would also like to thank all the staff members of Barid Al-Maghrib who helped me during my internship, answered my questions, and shared with me their experience and knowledge of postal operations.

  My thanks also go to the professors and administrative staff of my institution for the quality of the education they provided during my studies.

  Finally, I would like to thank everyone who contributed, directly or indirectly, to the completion of this internship report.
]


#let abstract-en = [
  Barid Al-Maghrib manages large volumes of international postal shipments through operational information systems primarily designed for transaction processing and shipment tracking. While these systems provide detailed operational visibility, they offer limited support for predictive analytics and demand forecasting.

  This internship addresses the problem of forecasting outgoing international mail flows in order to improve short-term operational planning. The work involved reconstructing historical time series from heterogeneous operational sources, developing a robust data preparation pipeline, and evaluating multiple forecasting approaches.

  The proposed methodology follows an adaptation of the CRISP-DM framework and encompasses data extraction, preprocessing, feature engineering, model development, evaluation, and operationalization stages. Candidate forecasting models include statistical methods, machine learning algorithms, and deep learning architectures. Model performance was assessed using a rolling-origin cross-validation strategy and several complementary metrics.

  Experimental results indicate that neural approaches, particularly BiTCN, achieve the best forecasting performances for the four-week planning horizon considered in this study. However, statistical models exhibit greater stability for longer forecasting horizons. To ensure coherence across aggregation levels, forecasts were reconciled using hierarchical forecasting techniques.

  Finally, an interactive visualization system based on Altair was developed to enable users to explore historical observations and reconciled forecasts dynamically. The resulting framework constitutes a complete forecasting workflow capable of transforming operational postal data into actionable decision-support information and contributes to ongoing digital transformation initiatives within Barid Al-Maghrib.

  *Keywords:* time series forecasting, hierarchical forecasting, postal logistics, CRISP-DM, BiTCN, NHITS, data engineering, Altair, Barid Al-Maghrib.
]


#let abstract-fr = [
  Barid Al-Maghrib gère d'importants volumes d'envois postaux internationaux à travers des systèmes d'information principalement conçus pour le traitement transactionnel et le suivi des expéditions. Bien que ces systèmes offrent une visibilité opérationnelle détaillée, ils présentent des capacités limitées en matière d'analyse prédictive et de prévision de la demande.

  Ce stage s'intéresse à la problématique de la prévision des flux de courrier international sortant afin d'améliorer la planification opérationnelle à court terme. Les travaux réalisés ont consisté à reconstruire des séries temporelles historiques à partir de sources opérationnelles hétérogènes, à développer une chaîne robuste de préparation des données et à évaluer plusieurs approches de prévision.

  La méthodologie proposée s'appuie sur une adaptation de la démarche CRISP-DM et couvre les étapes d'extraction des données, de prétraitement, d'ingénierie des variables, de développement des modèles, d'évaluation et d'opérationnalisation. Les modèles étudiés comprennent des approches statistiques, des algorithmes d'apprentissage automatique et des architectures d'apprentissage profond. Les performances ont été évaluées à l'aide d'une validation croisée glissante et de plusieurs métriques complémentaires.

  Les résultats expérimentaux montrent que les approches neuronales, notamment BiTCN, obtiennent les meilleures performances pour l'horizon de prévision de quatre semaines retenu dans cette étude. Toutefois, les modèles statistiques présentent une meilleure stabilité pour des horizons de prévision plus étendus. Afin de garantir la cohérence des prévisions entre les différents niveaux d'agrégation, une étape de réconciliation hiérarchique a été mise en œuvre.

  Enfin, un système de visualisation interactif basé sur Altair a été développé afin de permettre l'exploration dynamique des observations historiques et des prévisions réconciliées. La solution proposée constitue ainsi une chaîne complète de prévision capable de transformer des données postales opérationnelles en informations exploitables pour l'aide à la décision, tout en s'inscrivant dans les initiatives de transformation numérique engagées par Barid Al-Maghrib.

  *Mots-clés :* prévision de séries temporelles, prévision hiérarchique, logistique postale, CRISP-DM, BiTCN, NHITS, ingénierie des données, Altair, Barid Al-Maghrib.
]


#let abbreviations-list = (
  ("BAM", "Barid Al-Maghrib"),
  ("ABB", "Al Barid Bank"),

  ("SMI", "Système de Messagerie Intégré"),

  ("CRISP-DM", "Cross-Industry Standard Process for Data Mining"),

  ("RPA", "Robotic Process Automation"),
  ("ETL", "Extract, Transform, Load"),
  ("API", "Application Programming Interface"),
  ("OLTP", "Online Transaction Processing"),

  ("UPU", "Universal Postal Union"),

  ("PoD", "Pay on Delivery"),
  ("CRBT", "Contre-Remboursement"),
  ("CEC", "Client en Compte"),
  ("CCP", "Compte Courant Postal"),
  ("CCABB", "Compte Courant Al Barid Bank"),
  ("BC", "Barid Cash"),

  ("MEI", "Mise en Instance"),
  ("MED", "Mise en Distribution"),

  ("ARIMA", "AutoRegressive Integrated Moving Average"),
  ("ETS", "Error, Trend, Seasonal"),
  ("CES", "Complex Exponential Smoothing"),
  ("TBATS", "Trigonometric, Box-Cox transformation, ARMA errors, Trend, and Seasonal components"),
  ("MFLES", "Multiple Frequency Linear Exponential Smoothing"),

  ("BiTCN", "Bidirectional Temporal Convolutional Network"),
  ("NHITS", "Neural Hierarchical Interpolation for Time Series Forecasting"),

  ("MASE", "Mean Absolute Scaled Error"),
  ("RMAE", "Relative Mean Absolute Error"),
  ("ND", "Normalized Deviation"),
  ("SPIS", "Scaled Pinball Interval Score"),

  ("MinT", "Minimum Trace Reconciliation"),
)


#let abbreviations = [
  #grid(
    columns: (8em, 1fr),
    gutter: 0.65em,

    [*Abbreviation*], [*Definition*],

    ..abbreviations-list.sorted(key: item => item.at(0).at(0)).map(x => ([#x.at(0)], [#x.at(1)])).flatten(),
  )
]
