// ============================================================================
// ULaval Presentation — sample / starter file
// Copy this file to your project folder and customise from there.
// ============================================================================

#import "ulaval_template.typ": *

// ----------------------------------------------------------------------------
// 1. TEMPLATE SETUP
//    title       — required, can be a string or inline content
//    subtitle    — optional
//    authors     — optional
//    institute   — optional (supports inline formatting)
//    email       — optional
//    date        — optional (auto-today shown below)
//    bg-image    — optional path to a background image for the title slide
// ----------------------------------------------------------------------------
#show: ulaval-template.with(
  title: "Présentation de recherche",
  subtitle: "Sous-titre de la présentation",
  authors: "Prénom Nom",
  email: "prenom.nom@ulaval.ca",
  institute: [model#emph[EAU], Département de génie civil et de génie des eaux],
  date: datetime.today().display("[month repr:long] [day], [year]"),
  lang: "en",  // change to "en" for English labels
)

// ----------------------------------------------------------------------------
// 2. TABLE OF CONTENTS
//    Automatically lists every level-1 heading (= Section name)
// ----------------------------------------------------------------------------
#toc-slide()

// ============================================================================
// SECTION 1 — INTRODUCTION
// The `title:` parameter must match the level-1 heading text exactly so
// the chevron bar highlights the correct section.
// ============================================================================
#content-slide(title: "Introduction", subtitle: "Mise en contexte")[
  = Introduction

  Quelques points d'introduction :

  - Premier point avec une information importante
  - Deuxième point avec des détails supplémentaires
  - Troisième point avec les points clés

  #note-block[
    Utilisez `note-block` pour de l'information complémentaire (fond bleu).
  ]
]

// ============================================================================
// SECTION 2 — MÉTHODOLOGIE
// ============================================================================
#content-slide(title: "Méthodologie", subtitle: "Approche et outils")[
  = Méthodologie

  Description de la méthodologie :

  - Étape 1 : collecte des données
    - Sous-étape A
    - Sous-étape B
  - Étape 2 : traitement et analyse
  - Étape 3 : validation des résultats
  

  #warning-block[
    Utilisez `warning-block` pour les mises en garde importantes (fond jaune).
  ]
]

// Two-thirds / one-third layout: pass content as trailing block, image as
// a named `image:` parameter.  When no image is given the content fills the
// full width, just like a regular content-slide.
#two-thirds-slide(title: "Méthodologie", subtitle: "Dispositif expérimental")[
  #grid(
    columns: (2fr, 1fr),
    gutter: 1.5em,
    [
      Description du dispositif expérimental :

      - Paramètre A : valeur et justification
      - Paramètre B : valeur et justification
      - Paramètre C : valeur et justification

      #example-block[
        Utilisez `example-block` pour illustrer un cas concret (fond vert).
      ]
    ],
    align(center + horizon,
      rect(
        width: 100%, height: 8em,
        fill: ulaval-light-gray, stroke: ulaval-gray,
        align(center + horizon,
          text(size: 0.85em, fill: ulaval-gray)[Figure / schéma]
        )
      )
    )
  )
]

// ============================================================================
// SECTION 3 — RÉSULTATS
// ============================================================================
#content-slide(title: "Résultats", subtitle: "Principaux résultats")[
  = Résultats

  Principaux résultats obtenus :

  - Résultat 1 : observation importante
  - Résultat 2 : tendance significative
  - Résultat 3 : validation de l'hypothèse

  Les résultats montrent des tendances claires dans les données.
]

#two-thirds-slide(title: "Résultats", subtitle: "Analyse visuelle")[
  #grid(
    columns: (1fr, 2fr),
    gutter: 1.5em,
    align(center + horizon,
      rect(
        width: 100%, height: 9em,
        fill: ulaval-light-gray, stroke: ulaval-gray,
        align(center + horizon,
          text(size: 0.85em, fill: ulaval-gray)[Graphique / figure]
        )
      )
    ),
    [
      Interprétation du graphique :

      - Point A : explication
      - Point B : explication
      - Point C : conclusion partielle
    ]
  )
]

// ============================================================================
// SECTION 4 — CONCLUSION
// ============================================================================
#content-slide(title: "Conclusion", subtitle: "Synthèse et perspectives")[
  = Conclusion

  Dans cette présentation nous avons couvert :

  - Introduction et contexte
  - Méthodologie et dispositif
  - Résultats et analyse

  *Points à retenir :*
  - Point 1
  - Point 2
  - Point 3

  #note-block[
    Travaux futurs : préciser ici les prochaines étapes de la recherche.
  ]
]

// ============================================================================
// REFERENCES
// ============================================================================
#references-slide[
  #set text(size: 0.8em)

  // Manual reference list — or replace with:
  // #bibliography("references.bib", style: "apa")

  Auteur, P., & Collaborateur, Q. (#datetime.today().year()). Titre de l'article.
  _Nom de la revue_, _1_(1), 1–15.

  Chercheur, R., & Associé, S. (2024). Autre référence importante.
  _Actes du colloque_, 20–30.
]

// ============================================================================
// END SLIDE
// ============================================================================
#end-slide(
  authors: "Prénom Nom",
  institute: "Université Laval",
  contact: "prenom.nom@ulaval.ca",
)
