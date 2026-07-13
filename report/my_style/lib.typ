#import "@preview/headcount:0.1.1": *

#let IMAGE_BOX_MAX_WIDTH = 120pt
#let IMAGE_BOX_MAX_HEIGHT = 4cm

#let supported-langs = ("en", "fr", "ar")

#let current-heading-numbering = state("heading-numbering", none)


#let cover-page(
  title,
  subtitle,
  school-logo,
  company-logo,
  authors,
  mentors,
  jury,
  branch,
  academic-year,
  defense-date,
  dict,
) = {
  grid(
    gutter: 0em,
    inset: -1.5cm,
    align: center + horizon,
    columns: (1fr, 4fr, 1fr),
    box(height: IMAGE_BOX_MAX_HEIGHT, width: 1fr)[
      #align(start + horizon)[
        #school-logo
      ]
    ],
    align(center + horizon)[
      #text(size: 18pt)[Université Sultan Moulay Slimane\
        Ecole Supérieure de Technologie – FBS]
    ],
    box(height: IMAGE_BOX_MAX_HEIGHT, width: 1fr)[
      #align(end + horizon)[
        #company-logo
      ]
    ],
  )

  // Title box
  align(center + horizon)[
    #if subtitle != none {
      subtitle
    }
    #line(length: 100%, stroke: 3pt)
    #text(size: 25pt, weight: "bold")[#title]
    #line(length: 100%, stroke: 3pt)
  ]

  align(
    center + horizon,
    text(size: 15pt)[
      Soutenu le 19/06/2026 devant la commission d’examen composée de :

    ],
  )
  align(
    center + horizon,
    box(width: 1fr, height: 25%, stroke: 1pt, inset: 1em)[
      #align(left + horizon)[
        #text(size: 15pt)[
          #grid(
            row-gutter: 2em,
            column-gutter: 2em,
            columns: 2,
            [Pr. Younes Regragui], [Président/Rapporteur],
            [Pr. Khalid Qbouche], [Encadrant],
          )
          #h(2em)
        ]
      ]
    ],
  )
  // grid(
  //   columns: (auto, 1fr, auto),
  //   [
  //     // Authors
  //     #if authors.len() > 0 {
  //       [
  //         #text(weight: "bold")[
  //           #if authors.len() > 1 {
  //             dict.author_plural
  //           } else {
  //             dict.author
  //           }
  //           #linebreak()
  //         ]
  //         #for author in authors {
  //           [#author #linebreak()]
  //         }
  //       ]
  //     }
  //   ],
  //   [
  //     // Mentor
  //     #if mentors != none and mentors.len() > 0 {
  //       align(end)[
  //         #text(weight: "bold")[
  //           #if mentors.len() > 1 {
  //             dict.mentor_plural
  //           } else {
  //             dict.mentor
  //           }
  //           #linebreak()
  //         ]
  //         #for mentor in mentors {
  //           mentor
  //           linebreak()
  //         }
  //       ]
  //     }
  //     // Jury
  //     #if defense-date == none and jury != none and jury.len() > 0 {
  //       align(end)[
  //         *#dict.jury* #linebreak()
  //         #for prof in jury {
  //           [#prof #linebreak()]
  //         }
  //       ]
  //     }
  //   ],
  // )

  align(right + bottom)[
    #if defense-date != none and jury != none and jury.len() > 0 {
      [*#dict.defended_on_pre_date #defense-date #dict.defended_on_post_date:*]
      // Jury
      align(center)[
        #for prof in jury {
          [#prof #linebreak()]
        }
      ]
      v(60pt)
    }
    #if branch != none {
      branch
      linebreak()
    }
    #if academic-year != none {
      [Année universitaire: #academic-year]
    }
  ]
}


#let project(
  title: "",
  subtitle: none,
  header: none,
  school-logo: none,
  company-logo: none,
  authors: (),
  mentors: (),
  jury: (),
  branch: none,
  academic-year: none,
  french: false,
  lang: none,
  footer-text: "ENSIAS",
  features: (),
  heading-numbering: "1.1",
  accent-color: rgb("#ff4136"),
  defense-date: none,

  dedication: none,
  acknowledgments: none,
  abstract-fr: none,
  abstract-en: none,
  abbreviations: none,

  body,
) = {
  if lang == none {
    // Fallback by the time the param gets removed after deprecation
    if french {
      lang = "fr"
    } else {
      lang = "en"
    }
  }

  if not supported-langs.contains(lang) {
    panic("Unsupported `lang` value. Supported languages: " + supported-langs.join(","))
  }

  let dict = json("resources/i18n/" + lang + ".json")

  // Set the document's basic properties.
  set document(author: authors, title: title)

  set page(header: context {
    let headings = query(heading.where(level: 1).before(here()))

    if headings == () {
      return []
    }

    let current-page-headings = query(heading.where(level: 1).after(here())).filter(h => (
      h.location().page() == here().page()
    ))

    let current-chapter = headings.last()

    if current-chapter.numbering != none {
      let in-page-heading = current-page-headings.first(default: none)

      if in-page-heading == none or in-page-heading.numbering == none {
        let count = numbering(
          current-chapter.numbering,
          ..counter(heading).at(current-chapter.location()),
        )

        align(end)[
          *#current-chapter.supplement #count:* #current-chapter.body
          #line(length: 100%)
        ]
      }
    }
  }) if features.contains("header-chapter-name")

  set text(lang: lang, size: 12pt)
  set par(justify: true)

  set heading(numbering: heading-numbering, supplement: h => {
    let depth = h.at("depth", default: 1)
    if depth == 1 {
      dict.chapter
    } else {
      dict.section
    }
  })
  current-heading-numbering.update(heading-numbering)

  set figure(
    numbering: nums => {
      dependent-numbering(current-heading-numbering.get())(nums)
    },
  ) // chapter dependant numbering

  set figure.caption(separator: " - ")
  show figure.where(kind: image): set figure.caption(position: bottom)

  show figure.where(kind: table): it => {
    set block(breakable: true)
    set figure.caption(position: top)
    show figure.caption: strong
    it
  }
  show table.cell.where(y: 0): strong

  show heading: it => {
    if it.level == 1 {
      pagebreak(weak: true)
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      if it.numbering != none {
        if features.contains("full-page-chapter-title") {
          set page(footer: none)

          align(horizon)[
            #text(weight: "regular", size: 30pt)[
              #it.supplement #counter(heading).display()
            ]
            #linebreak()
            #text(weight: "bold", size: 36pt)[
              #it.body
            ]
            #line(start: (0%, -1%), end: (15%, -1%), stroke: 2pt + accent-color)
          ]

          pagebreak()
        } else {
          v(40pt)
          text(size: 30pt)[#it.supplement #counter(heading).display() #linebreak() #it.body ]
          v(60pt)
        }
      } else {
        v(5pt)
        text(size: 30pt)[#it]
        v(12pt)
      }
    } else {
      v(5pt)
      [#it]
      v(12pt)
    }
  }

  if header != none {
    h(1fr)
    box(width: 60%)[
      #align(center)[
        #text(weight: "medium")[
          #header
        ]
      ]
    ]
    h(1fr)
  }

  set page(numbering: none)

  cover-page(
    title,
    subtitle,
    school-logo,
    company-logo,
    authors,
    mentors,
    jury,
    branch,
    academic-year,
    defense-date,
    dict,
  )

  // pagebreak()
  // pagebreak()

  set page(
    numbering: "i",
    number-align: center,
    footer: context {
      let page-number = counter(page).display()
      line(length: 100%, stroke: 0.5pt)
      v(-2pt)
      text(size: 12pt, weight: "regular")[
        #footer-text
        #h(1fr)
        #page-number
        #h(1fr)
        #academic-year
      ]
    },
  )

  counter(page).update(1)

  // Dedication (i)
  if dedication != none {
    align(center + horizon)[
      #heading(level: 1, numbering: none, outlined: false)[#dict.dedication]
      #v(2em)
      #dedication
    ]
  }

  // Acknowledgments (ii)
  if acknowledgments != none {
    heading(level: 1, numbering: none, outlined: false)[#dict.acknowledgments]
    v(2em)
    acknowledgments
  }

  // Abstract EN (iv)
  if abstract-en != none {
    heading(level: 1, numbering: none, outlined: false)[#dict.abstract]
    v(2em)
    abstract-en
  }

  // Abstract FR (iii)
  if abstract-fr != none {
    heading(level: 1, numbering: none, outlined: false)[#dict.abstract (FR)]
    v(2em)
    abstract-fr
  }

  // Table of contents (v)
  outline(
    depth: 3,
    indent: 1.5em,
  )

  // List of abbreviations (vi)
  if abbreviations != none {
    heading(level: 1, numbering: none)[#dict.abbreviations]
    abbreviations
  }

  // List of figures (vii)
  heading(level: 1, numbering: none)[#dict.figures_table]
  outline(
    title: none,
    target: figure.where(kind: image),
  )

  // List of tables (viii)
  heading(level: 1, numbering: none)[#dict.tables_table]
  outline(
    title: none,
    target: figure.where(kind: table),
  )

  pagebreak()

  set page(numbering: "1")
  counter(page).update(1)

  // Main body.
  body
}

#let appendices = body => {
  counter(heading).update(0)

  set heading(
    numbering: (..nums) => {
      let levels = nums.pos()
      if levels.len() == 1 {
        "Appendix " + numbering("A", ..nums)
      } else {
        numbering("A.1", ..nums)
      }
    },
    supplement: [],
  )

  current-heading-numbering.update("A.1")

  body
}
