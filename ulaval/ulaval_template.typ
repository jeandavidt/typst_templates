// ULaval Presentation Template for Typst
// Based on the ULaval PowerPoint template style

// ============================================================================
// CITATIONS WITH ZOTERO
// ============================================================================
// To use Zotero citations in your presentation:
//
// 1. Export your Zotero library as BibTeX (.bib file)
//    - In Zotero: File > Export Library > choose BibTeX
//    - Or use Better BibTeX extension for persistent citation keys
//
// 2. Pass the bibliography path to the template:
//    #show: doc => ulaval-template(
//      bibliography: "references.bib",  // Path to your .bib file
//      ...
//    )
//
// 3. Use citations in your slides:
//    - @key2024        → (Author, 2024)
//    - [@key2024]      → [(Author, 2024)]
//    - [@key2024; p.5] → [(Author, 2024, p.5)]
//
// 4. Add a references slide at the end:
//    #bibliography("references.bib", style: "apa")
//
// ============================================================================
// COLOR SCHEME - ULaval colors
// ============================================================================
#let ulaval-red = rgb("#e90013")        // ULaval official red
#let ulaval-gold = rgb("#fed533")      // ULaval gold
#let ulaval-white = rgb(255, 255, 255)
#let ulaval-black = rgb(0, 0, 0)
#let ulaval-gray = rgb(100, 100, 100)
#let ulaval-light-gray = rgb(245, 245, 245)

// ============================================================================
// FONT DEFINITIONS
// ============================================================================
#let primary-font = "Overpass"
#let secondary-font = "Helvetica"

// ============================================================================
// LOGO PATHS (placeholders - update with actual logo files)
// ============================================================================
#let ulaval-logo-color = "./logos/ulaval_color.png"  // Update with actual logo
#let ulaval-logo-grey = "./logos/ulaval_grey.png"  // Update with actual logo
#let faculty-logo = "./logos/modeleau.png"  // Update with actual logo

// ============================================================================
// LANGUAGE STATE
// Holds "fr" or "en"; set by ulaval-template and read by slide functions.
// ============================================================================
#let ulaval-lang = state("ulaval-lang", "fr")

#let _lang-label(fr, en) = context {
  if ulaval-lang.get() == "en" { en } else { fr }
}

// ============================================================================
// SIMPLE SECTION TRACKING - Using simple variables
// ============================================================================
#let curr-section = ""
#let curr-subsection = ""

// ============================================================================
// ADAPTIVE TEXT HELPER
// Scales content to fill the available layout width.
// body-fn: closure (size) => content — called first to measure, then to render.
// ============================================================================
#let fit-line(body-fn, max-size: 3em, min-size: 0.8em) = layout(avail => context {
  let w = avail.width
  let m = measure(body-fn(max-size))
  let size = if m.width <= w {
    max-size
  } else {
    calc.max(min-size, max-size * (w / m.width))
  }
  body-fn(size)
})

// ============================================================================
// TITLE SLIDE
// ============================================================================
#let rg-bar = grid(
  columns: (80%, 20%),
  rows: 1,
  gutter: 0pt,
  rect(fill: ulaval-red, width: 100%, height: 100%),
  rect(fill: ulaval-gold, width: 100%, height: 100%),
)
#let title-slide(
  title,
  subtitle: none,
  authors: none,
  institute: none,
  date: none,
  venue: none,
  email: none,
  bg-image: none,
) = {
  set page(margin: 0pt, header: none, footer: none)

  // Optional full-slide background image (behind everything except footer)
  if bg-image != none {
    place(top,
      image(bg-image, width: 100%, height: 100%, fit: "cover")
    )
  }

  // Footer: rg-bar then logos, all pinned to the bottom as one block
  place(bottom, {
    box(width: 100%, height: 8pt, rg-bar)
    grid(
      columns: (1fr, auto),
      gutter: 0pt,
      pad(left: 2em, bottom: 0.6em, top: 0.4em,
        image(ulaval-logo-color, height: 3.5em)
      ),
      pad(right: 2em, bottom: 0.4em,
        image(faculty-logo, height: 4em)
      )
    )
  })

  // Light grey background rectangle for text zone
  place(top + left,
    rect(fill: rgb(240, 240, 240).transparentize(20%), width: 80%, height: 72%)
  )

  // Title/authors block — uses top 72% of slide
  box(width: 100%, height: 72%,
    align(left + horizon,
      pad(left: 2.5em, right: 7em, top: 1em, bottom: 1em)[
        #fit-line(s => text(size: s, weight: "extrabold", fill: ulaval-black, upper(title)),
          max-size: 4em, min-size: 1.5em)

        #if subtitle != none {
          v(0.5em)
          fit-line(s => text(size: s, fill: ulaval-gray, emph(subtitle)),
            max-size: 1.2em, min-size: 0.8em)
        }

        #if authors != none {
          v(1em)
          text(size: 1.4em, fill: ulaval-black)[#authors]
        }

        #if institute != none {
          v(0.2em)
          text(size: 1.2em, fill: ulaval-gray)[#institute]
        }

        #if email != none {
          v(0.2em)
          text(size: 1.2em, fill: ulaval-gray)[#email]
        }

        #if date != none or venue != none {
          v(1.5em)
          if venue != none {
            text(size: 1.1em, fill: ulaval-gray)[#venue]
            if date != none { text(size: 1.1em, fill: ulaval-gray)[, ] }
          }
          if date != none { text(size: 1.1em, fill: ulaval-black)[#date] }
        }
      ]
    )
  )
}
// ============================================================================
// TABLE OF CONTENTS SLIDE
// ============================================================================
#let toc-slide(title: none) = {
  pagebreak(weak: true)
  v(0.5em)
  context {
    let actual-title = if title != none { title }
                       else if ulaval-lang.get() == "en" { "Table of Contents" }
                       else { "Table des matières" }
    text(size: 2em, weight: "bold", fill: ulaval-red, actual-title)
  }
  v(1em)

  // Use 'context' to allow Typst to "look ahead" at the headings
  context {
    let sections = query(heading.where(level: 1))
    let count = 0
    for section in sections {
      count = count + 1
      h(1em)
      text(weight: "bold", fill: ulaval-red, str(count) + ".")
      h(0.5em)
      // This creates a clickable link to the section
      link(section.location(), text(size: 1.2em, section.body))
      v(0.5em)
    }
  }
  v(1fr)
}

// ============================================================================
// CHEVRON PROGRESS BAR
// Renders a row of chevron-shaped section indicators.
// Sections before current are a lighter red; active is full red; future is gray.
// ============================================================================
#let chevron-bar(sections, current-idx) = layout(size => {
  let n = sections.len()
  if n == 0 { return [] }

  let W = size.width
  let h = 22pt   // bar height
  let d = 9pt    // arrow depth (horizontal extent of the chevron point)

  // cell width: n cells with (n-1) overlaps of d give total width W
  //   n * cell - (n-1) * d = W  =>  cell = (W + (n-1)*d) / n
  let cell = (W + (n - 1) * d) / n

  box(width: W, height: h, clip: true, {
    for (i, section) in sections.enumerate() {
      let is-first   = i == 0
      let is-last    = i == n - 1
      let is-active  = i == current-idx
      let is-past    = i < current-idx

      let bg = if is-active     { ulaval-red }
               else if is-past  { ulaval-red.lighten(35%) }
               else             { rgb(185, 185, 185) }

      let x = i * (cell - d)

      // Build chevron polygon vertices
      let pts = if is-first and is-last {
        ((x, 0pt), (x + cell, 0pt), (x + cell, h), (x, h))
      } else if is-first {
        ((x, 0pt), (x + cell - d, 0pt), (x + cell, h / 2),
         (x + cell - d, h), (x, h))
      } else if is-last {
        ((x, 0pt), (x + cell, 0pt), (x + cell, h),
         (x, h), (x + d, h / 2))
      } else {
        ((x, 0pt), (x + cell - d, 0pt), (x + cell, h / 2),
         (x + cell - d, h), (x, h), (x + d, h / 2))
      }

      place(top + left, polygon(fill: bg, stroke: none, ..pts))

      // Text label — inset from the notch/point on each side
      let pad-l = if is-first { 5pt } else { d + 4pt }
      let pad-r = if is-last  { 4pt } else { d + 2pt }

      place(top + left, dx: x + pad-l,
        box(width: cell - pad-l - pad-r, height: h,
          align(center + horizon,
            text(
              size: 8pt,
              fill: white,
              weight: if is-active { "bold" } else { "regular" },
              upper(section.body)
            )
          )
        )
      )
    }
  })
})

// ============================================================================
// CONTENT SLIDE - with chevroned section progress bar
// ============================================================================
#let content-slide(
  title: none,
  subtitle: none,
  section: none,  // Pass to register a new section at this slide (replaces standalone = Heading)
  body
) = {
  pagebreak(weak: true)

  // Register section heading inline so it lands before here() with no empty slide
  if section != none { heading(level: 1, section) }

  if title != none {
    text(size: 1.5em, weight: "extrabold", fill: ulaval-black, title)
    if subtitle != none { v(0.15em) }
  }
  if subtitle != none {
    text(size: 1.05em, fill: ulaval-gray, emph(subtitle))
  }
  if title != none or subtitle != none { v(0.5em) }

  body
}

// ============================================================================
// TWO THIRDS / ONE THIRD SLIDE (Content + Image)
// ============================================================================
#let two-thirds-slide(
  title: none,
  subtitle: none,
  section: none,  // Pass to register a new section at this slide (replaces standalone = Heading)
  content,
  image: none,
  image-position: "right"  // "right" or "left"
) = {
  pagebreak(weak: true)

  // Register section heading inline so it lands before here() with no empty slide
  if section != none { heading(level: 1, section) }

  if title != none {
    text(size: 1.5em, weight: "extrabold", fill: ulaval-black, title)
    if subtitle != none { v(0.15em) }
  }
  if subtitle != none {
    text(size: 1.05em, fill: ulaval-gray, emph(subtitle))
  }
  if title != none or subtitle != none { v(0.5em) }

  // Two columns: content (2/3) + image (1/3)
  if image != none {
    if image-position == "right" {
      grid(
        columns: (2fr, 1fr),
        gutter: 1em,
        align(left + top, content),
        align(center + top, image)
      )
    } else {
      grid(
        columns: (1fr, 2fr),
        gutter: 1em,
        align(center + top, image),
        align(left + top, content)
      )
    }
  } else {
    content
  }
}

// ============================================================================
// END SLIDE
// ============================================================================
#let end-slide(
  title: none,
  subtitle: none,
  authors: none,
  institute: none,
  contact: none
) = {
  pagebreak()
  set page(margin: 0pt, header: none, footer: none, fill: ulaval-white)

  // Red top bar — placed so it doesn't consume flow height
  place(top + left, rect(fill: ulaval-red, width: 100%, height: 11.43mm))

  context {
    let lang = ulaval-lang.get()
    let actual-title = if title != none { title }
                       else if lang == "en" { "Thank you!" }
                       else { "Merci !" }
    let actual-subtitle = if subtitle != none { subtitle }
                          else { "Questions?" }

    // Title
    place(top + center, dy: 28%,
      text(size: 2.5em, weight: "bold", fill: ulaval-red, actual-title))

    // Subtitle
    place(top + center, dy: 40%,
      text(size: 1.5em, fill: ulaval-black, actual-subtitle))
  }

  // Authors
  if authors != none {
    place(top + center, dy: 52%,
      text(size: 1.3em, fill: ulaval-black, authors))
  }

  // Institute
  if institute != none {
    place(top + center, dy: 60%,
      text(size: 1.1em, fill: ulaval-gray, institute))
  }

  // Contact
  if contact != none {
    place(top + center, dy: 67%,
      text(size: 1em, fill: ulaval-gray, contact))
  }

  // Bottom text and logo
  place(bottom + left, dx: 2em, dy: -1em,
    text(size: 0.8em, fill: ulaval-gray, "Université Laval"))
  place(bottom + right, dx: -2em, dy: -1em,
    image(faculty-logo, height: 1.5em))
}

// ============================================================================
// REFERENCES SLIDE
// ============================================================================
#let references-slide(
  title: none,
  body
) = {
  pagebreak(weak: true)

  context {
    let actual-title = if title != none { title }
                       else if ulaval-lang.get() == "en" { "References" }
                       else { "Références" }
    block(
      width: 100%,
      fill: ulaval-red,
      inset: (x: 1.5em, y: 0.8em),
      text(size: 1.3em, weight: "bold", fill: ulaval-white, actual-title)
    )
  }
  
  v(1em)
  
  // References list
  block(
    width: 100%,
    {
      set text(size: 0.9em)
      body
    }
  )
}

// ============================================================================
// BIBLIOGRAPHY FUNCTION - For Zotero BibTeX integration
// Use this to display references in your slides
// ============================================================================
#let show-references(
  bib-path,
  style: "apa",
  title: none
) = {
  pagebreak(weak: true)

  context {
    let actual-title = if title != none { title }
                       else if ulaval-lang.get() == "en" { "References" }
                       else { "Références" }
    block(
      width: 100%,
      fill: ulaval-red,
      inset: (x: 1.5em, y: 0.8em),
      text(size: 1.5em, weight: "bold", fill: ulaval-white, actual-title)
    )
  }
  
  v(1em)
  
  // Display bibliography using Typst's native bibliography function
  bibliography(bib-path, style: style)
}

// ============================================================================
// UTILITY CONTENT BLOCKS
// ============================================================================
#let note-block(body) = block(
  width: 100%,
  fill: rgb("#dce8f7"),
  stroke: (left: 3pt + rgb("#4a7fc1")),
  inset: (x: 1em, y: 0.6em),
  radius: (right: 3pt),
  body
)

#let warning-block(body) = block(
  width: 100%,
  fill: rgb("#fff3cd"),
  stroke: (left: 3pt + ulaval-gold),
  inset: (x: 1em, y: 0.6em),
  radius: (right: 3pt),
  body
)

#let example-block(body) = block(
  width: 100%,
  fill: rgb("#d4edda"),
  stroke: (left: 3pt + rgb("#4cae4c")),
  inset: (x: 1em, y: 0.6em),
  radius: (right: 3pt),
  body
)

// ============================================================================
// MAIN TEMPLATE SHOW RULE
// Usage:
//   #show: doc => ulaval-template(
//     title: "My Talk",
//     subtitle: "A subtitle",
//     authors: "First Last",
//     ...
//     doc,
//   )
// ============================================================================
#let ulaval-template(
  title:     none,
  subtitle:  none,
  authors:   none,
  institute: none,
  date:      none,
  venue:     none,
  email:     none,
  bg-image:  none,
  lang:      "fr",
  doc,
) = {
  ulaval-lang.update(lang)
  // Base page dimensions (16:9, ~1920×1080 scaled to 254×142.875 mm)
  set page(width: 254mm, height: 142.875mm)

  // Typography
  set text(font: primary-font, size: 16pt)
  set par(leading: 0.6em, spacing: 0.7em)
  set list(marker: ([•], [–], [·]))

  // Level-1 headings register sections for the chevron bar and TOC only.
  // They are hidden from slide content — use the `title:` parameter in
  // content-slide / two-thirds-slide for the visual on-slide title.
  show heading.where(level: 1): h => place(hide(h))

  // Title slide (handles its own 0-margin page setup)
  title-slide(
    title,
    subtitle:  subtitle,
    authors:   authors,
    institute: institute,
    date:      date,
    venue:     venue,
    email:     email,
    bg-image:  bg-image,
  )

  // Content pages
  set page(
    margin: (top: 38pt, bottom: 1.5cm, x: 1.2cm),
    header-ascent: 8pt,
    header: context {
      let pg = counter(page).get().first()
      if pg > 1 {
        let all-secs = query(heading.where(level: 1))
        if all-secs.len() > 0 {
          let this-page = here().page()
          let on-page = all-secs.filter(h => h.location().page() == this-page)
          let current-idx = -1
          if on-page.len() > 0 {
            let cur = on-page.last().body
            for (i, s) in all-secs.enumerate() {
              if s.body == cur { current-idx = i }
            }
          } else {
            let before = query(selector(heading.where(level: 1)).before(here()))
            if before.len() > 0 {
              let cur = before.last().body
              for (i, s) in all-secs.enumerate() {
                if s.body == cur { current-idx = i }
              }
            }
          }
          chevron-bar(all-secs, current-idx)
        }
      }
    },
    footer: context {
      let pg = counter(page).get().first()
      if pg > 1 {
        line(length: 100%, stroke: 0.4pt + ulaval-gray)
        
        grid(
          columns: (auto, 1fr, auto, auto),
          align: horizon + center,
          column-gutter: 0.6em,
          align(left + horizon, text(size: 0.65em, fill: ulaval-gray, str(pg - 1))),
          [],
          align(right + horizon, image(faculty-logo, height: 1.8em)),
          align(right + horizon, image(ulaval-logo-grey,  height: 1.8em)),
        )
      }
    },
  )

  doc
}
