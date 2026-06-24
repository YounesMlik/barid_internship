// #import "@preview/red-agora:0.2.0": project
#import "my_style/lib.typ": project
#import "chapters/preliminary.typ": *
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


#heading(level: 1, numbering: none)[Introduction]
#include "chapters/intro.typ"


= Host Institution and Internship Context

#heading(level: 2, numbering: none)[Introduction]
#include "chapters/1/intro.typ"
== Presentation of Barid Al-Maghrib
#include "chapters/1/1.typ"
== International Mail Activities
#include "chapters/1/2.typ"
== Information Systems
#include "chapters/1/3.typ"
== Internship Context
#include "chapters/1/4.typ"
== Problem Statement
#include "chapters/1/5.typ"
#heading(level: 2, numbering: none)[Conclusion]
#include "chapters/1/conclusion.typ"



= Methodology
#heading(level: 2, numbering: none)[Introduction]
#include "chapters/2/intro.typ"
== General Methodological Approach
#include "chapters/2/1.typ"
== Data Collection Strategy
#include "chapters/2/2.typ"
== Web Scraping and Automation Pipeline
#include "chapters/2/3.typ"
== 2.4 Data Engineering Pipeline (ETL)
#include "chapters/2/4.typ"
== Construction of the Forecasting Dataset
#include "chapters/2/5.typ"
#heading(level: 2, numbering: none)[Conclusion]
#include "chapters/2/conclusion.typ"

#heading(level: 1, numbering: none)[Conclusion]
#include "chapters/conclusion.typ"

#bibliography("refs.bib")

// #heading(level: 1, numbering: none)[Appendix]


// == \d\.\d+(\.\d+)?

// ==
