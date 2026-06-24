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
  This report presents the work carried out during an internship at Barid Al-Maghrib as part of the requirements for the completion of the academic year.

  The objective of this internship was to study and forecast Morocco's outgoing international mail flows in order to better understand their evolution and provide estimates that can support operational planning activities.

  The work started with the collection of data from the Système de Messagerie Intégré (SMI) and shipment tracking services. Since the available systems do not provide programming interfaces and some reports could not be exported over long periods, an automated collection process was developed to extract and archive the required information. The collected data were then cleaned, transformed, and consolidated into datasets suitable for analysis.

  Several time series forecasting methods were evaluated, including ETS, ARIMA, CES, TBATS, Theta, MFLES, and Seasonal Naive models. Their performance was assessed using a rolling cross-validation procedure and compared using forecasting accuracy measures. Prediction intervals were also generated to quantify uncertainty.

  In addition, a simple web interface was developed to visualize historical trends, forecasts, and selected indicators in an interactive manner.

  The results obtained show that statistical forecasting techniques can provide useful information for anticipating fluctuations in international postal traffic and may contribute to improving planning and resource management activities within Barid Al-Maghrib.

  Keywords: Time series forecasting, international mail, postal logistics, data engineering, web automation, decision support.
]


#let abstract-fr = [
  Ce rapport présente les travaux réalisés dans le cadre d'un stage effectué au sein de Barid Al-Maghrib durant l'année universitaire 2025-2026.

  L'objectif principal de ce stage était d'étudier et de prévoir l'évolution des flux de courrier international sortant du Maroc afin de disposer d'estimations pouvant contribuer à la planification des activités opérationnelles et à une meilleure gestion des ressources.

  La première étape du travail a consisté à collecter les données nécessaires à partir du Système de Messagerie Intégré (SMI) et des services de suivi des envois. L'absence d'interfaces de programmation ainsi que certaines limitations des outils de reporting existants ont nécessité le développement d'un processus automatisé permettant d'extraire, d'archiver et de consolider les données disponibles. Ces données ont ensuite été nettoyées, transformées et organisées sous une forme adaptée à l'analyse.

  Plusieurs méthodes de prévision de séries temporelles ont été étudiées et comparées, notamment les modèles ETS, ARIMA, CES, TBATS, Theta, MFLES ainsi que le modèle Seasonal Naive utilisé comme référence. L'évaluation des performances a été réalisée à l'aide d'une procédure de validation croisée adaptée aux séries temporelles et de mesures d'erreur permettant de comparer les différentes approches. Des intervalles de prédiction ont également été construits afin de tenir compte de l'incertitude associée aux prévisions.

  Enfin, une interface web simple a été développée afin de faciliter la visualisation des données historiques, des prévisions produites ainsi que de quelques indicateurs utiles au suivi de l'activité.

  Les résultats obtenus montrent que les méthodes de prévision statistique peuvent constituer un outil intéressant pour anticiper les variations du trafic postal international et fournir des éléments d'aide à la planification des activités au sein de Barid Al-Maghrib.

  Mots-clés : prévision de séries temporelles, courrier international, logistique postale, ingénierie des données, automatisation web, aide à la décision.
]

#let abbreviations = [
  - BAM: Barid Al Maghrib
  - ABB: Al Barid Bank
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
]
