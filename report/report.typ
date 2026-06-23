// #import "@preview/red-agora:0.2.0": project
#import "my_style/lib.typ": project
#import "@preview/ilm:2.0.0": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node, shapes
#import "@preview/zebraw:0.6.3": *
#show: zebraw

#set text(lang: "en")

// #show: ilm.with(
//   title: align(center)[Analysis and Forecasting of Morocco's Outgoing International Mail Flows],
//   authors: ("Younes MLIK", "Supervised by: EDDYA Moulay Lahcen"),
//   date: datetime(year: 2026, month: 04, day: 27),
//   abstract: [
//     Report for an end of year internship at Barid Al-Maghrib
//   ],
//   preface: [],
//   // ],
//   bibliography: bibliography("refs.bib"),
//   figure-index: (enabled: true),
//   table-index: (enabled: true),
//   listing-index: (enabled: true),
// )
#set page(numbering: "i")

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
    "EDDYA Moulay Lahcen (External)"
  ),
  jury: (
    "Pr. Younes Regragui",
  ),
  branch: "Infrastructures, Traitement Et Analyse de Données Massives (Big Data)",
  academic-year: "2025-2026",
  footer-text: "EST FBS", // Text used in left side of the footer
  features: ("full-page-chapter-title", "header-chapter-name"),
)
#set page(numbering: none)
#pagebreak() 

#counter(page).update(1)     // restart page count at 1
   // lowercase Roman style

Dedication
Acknowledgments


= Host Institution and Internship Context
#include "chapters/1/1.typ"
// #include "chapters/1/2.typ"
// #include "chapters/1/3.typ"
// #include "chapters/1/4.typ"
// #include "chapters/1/5.typ"

= Methodology
#include "chapters/2/1.typ"
// #include "chapters/2/2.typ"
// #include "chapters/2/3.typ"
// #include "chapters/2/4.typ"
// #include "chapters/2/5.typ"

#bibliography("refs.bib")


// == \d\.\d+(\.\d+)?

// == 