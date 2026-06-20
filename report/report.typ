#import "@preview/ilm:2.0.0": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node, shapes
#import "@preview/zebraw:0.6.3": *
#show: zebraw

#set text(lang: "en")

#show: ilm.with(
  title: align(center)[Analysis and Forecasting of Morocco's Outgoing International Mail Flows],
  authors: ("Younes MLIK", "Supervised by: EDDYA Moulay Lahcen"),
  date: datetime(year: 2026, month: 04, day: 27),
  abstract: [
    Report for an end of year internship at Barid Al-Maghrib
  ],
  preface: [],
  // preface: [
  //   #align(center + horizon)[
  //     Thank you for using this template #emoji.heart,\ I hope you like it #emoji.face.smile
  //   ]
  // ],
  bibliography: bibliography("refs.bib"),
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true),
)

= Host Institution and Internship Context
#include "chapters/1/1.typ"
#include "chapters/1/2.typ"
#include "chapters/1/3.typ"
#include "chapters/1/4.typ"
#include "chapters/1/5.typ"

= Methodology
#include "chapters/2/1.typ"
#include "chapters/2/2.typ"
#include "chapters/2/3.typ"
#include "chapters/2/4.typ"
#include "chapters/2/5.typ"


// == \d\.\d+(\.\d+)?

// == 