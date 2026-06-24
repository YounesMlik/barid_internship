#import "@preview/headcount:0.1.1": *

#let IMAGE_BOX_MAX_WIDTH = 120pt
#let IMAGE_BOX_MAX_HEIGHT = 50pt

#let supported-langs = ("en", "fr", "ar")


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
  block[
    #box(height: IMAGE_BOX_MAX_HEIGHT, width: IMAGE_BOX_MAX_WIDTH)[
      #align(start + horizon)[
        #if school-logo == none {
          image("images/ENSIAS.svg")
        } else {
          school-logo
        }
      ]
    ]
    #h(1fr)
    #box(height: IMAGE_BOX_MAX_HEIGHT, width: IMAGE_BOX_MAX_WIDTH)[
      #align(end + horizon)[
        #company-logo
      ]
    ]
  ]

  // Title box
  align(center + horizon)[
    #if subtitle != none {
      text(size: 14pt, tracking: 2pt)[
        #smallcaps[
          #subtitle
        ]
      ]
    }
    #line(length: 100%, stroke: 0.5pt)
    #text(size: 20pt, weight: "bold")[#title]
    #line(length: 100%, stroke: 0.5pt)
  ]

  // Credits
  box()
  h(1fr)
  grid(
    columns: (auto, 1fr, auto),
    [
      // Authors
      #if authors.len() > 0 {
        [
          #text(weight: "bold")[
            #if authors.len() > 1 {
              dict.author_plural
            } else {
              dict.author
            }
            #linebreak()
          ]
          #for author in authors {
            [#author #linebreak()]
          }
        ]
      }
    ],
    [
      // Mentor
      #if mentors != none and mentors.len() > 0 {
        align(end)[
          #text(weight: "bold")[
            #if mentors.len() > 1 {
              dict.mentor_plural
            } else {
              dict.mentor
            }
            #linebreak()
          ]
          #for mentor in mentors {
            mentor
            linebreak()
          }
        ]
      }
      // Jury
      #if defense-date == none and jury != none and jury.len() > 0 {
        align(end)[
          *#dict.jury* #linebreak()
          #for prof in jury {
            [#prof #linebreak()]
          }
        ]
      }
    ],
  )

  align(center + bottom)[
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
      [#dict.academic_year: #academic-year]
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
    let current-page-headings = query(heading.where(level: 1).after(here())).filter(h => (
      h.location().page() == here().page()
    ))
    if headings == () {
      []
    } else {
      let current-chapter = headings.last()
      if current-chapter.level == 1 and current-chapter.numbering != none {
        let in-page-heading = if current-page-headings.len() > 0 { current-page-headings.first() } else { none }
        if in-page-heading == none or in-page-heading.level != 1 or in-page-heading.numbering == none {
          let count = counter(heading).at(current-chapter.location()).at(0)
          align(end)[
            #text(accent-color, weight: "bold")[
              #dict.chapter #count:
            ]
            #current-chapter.body
            #line(length: 100%)
          ]
        }
      }
    }
  }) if features.contains("header-chapter-name")

  set text(lang: lang, size: 12pt)
  set par(justify: true)
  set heading(numbering: heading-numbering)

  set figure(numbering: dependent-numbering("1.1")) // chapter dependant numbering
  set figure.caption(separator: " - ")
  show figure.where(kind: image): set figure.caption(position: bottom)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): it => {
    show figure.caption: strong
    it
  }

  show heading: it => {
    if it.level == 1 {
      pagebreak(weak: true)
    }
    if it.level == 1 and it.numbering != none {
      if features.contains("full-page-chapter-title") {
        set page(footer: none)

        align(horizon)[
          #text(weight: "regular", size: 30pt)[
            #dict.chapter #counter(heading).display()
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
        text(size: 30pt)[#dict.chapter #counter(heading).display() #linebreak() #it.body ]
        v(60pt)
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

  pagebreak()
  pagebreak()

  counter(page).update(1)

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
  outline(depth: 3, indent: auto)

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

  counter(page).update(1)
  set page(numbering: "1")

  // Main body.
  body
}

