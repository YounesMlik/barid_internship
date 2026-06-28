// #import "@preview/red-agora:0.2.0": project
#import "my_style/lib.typ": project, appendices
#import "chapters/preliminary.typ": *
#import "@preview/headcount:0.1.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node, shapes
#import "@preview/mmdr:0.2.2": mermaid
#import "@preview/zebraw:0.6.3": *
#show: zebraw



#show: project.with(
  title: "Analysis and Forecasting of Morocco's Outgoing International Mail Flows",
  subtitle: "End of year internship report",
  authors: (
    "Younes MLIK",
  ),
  school-logo: image("images/logo_est.png"),
  company-logo: image("images/logo_barid.png"),
  mentors: (
    "Pr. Khalid Qbouche (Internal)",
    "EDDYA Moulay Lahcen (External)",
  ),
  jury: (
    "Pr. Younes Regragui",
  ),
  branch: "Infrastructures, Traitement Et Analyse de Données Massives (Big Data)",
  academic-year: "2025-2026",
  footer-text: "EST FBS", // Text used in left side of the footer

  dedication: dedication,
  acknowledgments: acknowledgments,
  abstract-fr: abstract-fr,
  abstract-en: abstract-en,
  abbreviations: abbreviations,
  accent-color: color.black,
  features: (
    "full-page-chapter-title",
    "header-chapter-name",
  ),
)

#heading(level: 1, numbering: none)[General Introduction]
#include "chapters/intro.typ"


= Host Institution and Internship Context <chapter_host_institution>

#heading(level: 2, numbering: none)[Introduction]
#include "chapters/1/intro.typ"
== Presentation of Barid Al-Maghrib
// #include "chapters/1/1.typ"
// == International Mail Activities
// #include "chapters/1/2.typ"
// == Information Systems
// #include "chapters/1/3.typ"
// == Internship Context
// #include "chapters/1/4.typ"
// == Problem Statement and Objectives <section_problem_statement>
// #include "chapters/1/5.typ"
#heading(level: 2, numbering: none)[Conclusion]
#include "chapters/1/conclusion.typ"

#counter(figure).update(0)

= Methodology <chapter_methodology>
#heading(level: 2, numbering: none)[Introduction]
// #include "chapters/2/intro.typ"
// == CRISP-DM Framework Adaptation
// #include "chapters/2/1.typ"
// == Business Understanding
// #include "chapters/2/2.typ"
// == Exploratory Data Analysis
// #include "chapters/2/3.typ"
// == Data Preparation <section_methodology_data_prep>
// #include "chapters/2/4.typ"
// == Modeling Strategy <section_methodology_modeling_strategy>
// #include "chapters/2/5.typ"
// == Evaluation Methodology
// #include "chapters/2/6.typ"
// == Operationalization and Forecast Delivery Design <section_methodology_operationalization>
// #include "chapters/2/7.typ"
#heading(level: 2, numbering: none)[Conclusion]
#include "chapters/2/conclusion.typ"

#counter(figure).update(0)

= Realization and Results <chapter_realization>
#heading(level: 2, numbering: none)[Introduction]
#include "chapters/3/intro.typ"
== System Architecture
// #include "chapters/3/1.typ"
// == Data Engineering Implementation <section_realization_data_engineering>
// #include "chapters/3/2.typ"
// == Feature Engineering Implementation
// #include "chapters/3/3.typ"
// == Model Implementation
// #include "chapters/3/4.typ"
// == Hierarchical Forecasting Implementation
// #include "chapters/3/5.typ"
// == Evaluation Results <section_realization_eval_results>
// #include "chapters/3/6.typ"
// == Forecast Outputs
// #include "chapters/3/7.typ"
// == Interactive Visualization System
// #include "chapters/3/8.typ"
// == Discussion
// #include "chapters/3/9.typ"
#heading(level: 2, numbering: none)[Conclusion]
#include "chapters/3/conclusion.typ"

#heading(level: 1, numbering: none)[General Conclusion]
#include "chapters/conclusion.typ"

#bibliography("refs.bib")


#counter(figure).update(0)

#appendices[
  = Data Acquisition and Exploratory Dataset Characterization

  #heading(level: 2, numbering: none)[Introduction]
  #include "appendix/a/intro.typ"

  // == SMI Envois par Produit International (`smi_envoisbyproduitintern`) <appendix_data_smi_envoisbyproduitintern>
  // #include "appendix/a/1.typ"
  // == SMI Suivi Expédition (`smi_suiviexpedition`)
  // #include "appendix/a/2.typ"
  // == Parcel Tracking Data Extraction and Archival Strategy <appendix_data_tracking_extraction>
  // #include "appendix/a/3.typ"
  // == Analytical Datasets
  // #include "appendix/a/4.typ"

  #heading(level: 2, numbering: none)[Conclusion]
  #include "appendix/a/conclusion.typ"
]
// == \d\.\d+(\.\d+)?

// ==
