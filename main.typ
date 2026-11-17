// Bundle entry point: every page of the site is a `document` emitted from here.
// Build with ./build.sh (typst compile --features html,bundle --format bundle main.typ dist/).

#import "lib/template.typ": page-shell, site-title, site-tagline
#import "posts/_posts.typ": guides, published

// Draft mode (./dev.sh passes --input drafts=true): also render guides that have a
// `body` but aren't published yet, so you can preview them. Production builds skip them.
#let drafts = sys.inputs.at("drafts", default: "false") == "true"
#let is-draft(g) = drafts and g.status != "published" and "body" in g
#let rendered = guides.filter(g => g.status == "published" or is-draft(g))
#import "lib/art.typ": cylinder-flow, card-banner, flow-divider

#asset("style.css", read("assets/style.css"))

// ---------- Home ----------
#document("index.html", title: site-title)[
  #page-shell(path: "index.html")[
    #html.section(class: "hero")[
      #html.div(class: "hero-text")[
        #html.h1(class: "hero-title")[#site-title]
        #html.p(class: "hero-lede")[#site-tagline]
      ]
      #html.div(class: "hero-art")[#cylinder-flow()]
    ]
    #flow-divider()

    #html.h2(class: "section-title")[Guides]
    #html.ul(class: "guide-grid")[
      #for (i, g) in guides.enumerate() {
        let is-live = g.status == "published" or is-draft(g)
        let status-label = if is-draft(g) { "Draft preview →" } else if is-live { "Read guide →" } else if g.status == "ongoing" { "In progress" } else { "Coming soon" }
        html.li(
          class: "guide-card card-" + g.at("color", default: "sky") + if is-live { "" } else { " is-planned" },
        )[
          #html.div(class: "card-art")[#card-banner(g.at("short", default: g.title), seed: i)]
          #html.div(class: "card-body")[
            #html.p(class: "guide-source")[#g.source]
            #html.h3[
              #if is-live { html.a(href: g.slug + ".html")[#g.title] } else { g.title }
            ]
            #html.p(class: "guide-summary")[#g.summary]
            #html.p(class: "guide-status")[#status-label]
          ]
        ]
      }
    ]
  ]
]

// ---------- About ----------
#document("about.html", title: "About")[
  #page-shell(path: "about.html", title: "About me", kicker: "About", description: "Who writes these guides.")[
    #include "posts/about.typ"
  ]
]

// ---------- Style guide (unlisted: not on the home page, reachable at /dummy) ----------
#document("dummy.html", title: "How to write a post")[
  #page-shell(
    path: "dummy.html",
    title: "How to write a post",
    kicker: "Style guide",
    description: "A tour of everything a post on this blog can use.",
    date: datetime(year: 2026, month: 11, day: 17),
    accent: "mint",
    noindex: true,
  )[
    #include "posts/dummy.typ"
  ]
]

// ---------- Guides ----------
#for g in rendered {
  // Friendly errors for common registry mistakes.
  assert("body" in g, message: "guide '" + g.slug + "' is published but has no `body: include \"<file>.typ\"`")
  let date = g.at("date", default: none)
  assert(
    date == none and is-draft(g) or type(date) == datetime,
    message: "guide '" + g.slug + "' needs `date: datetime(year: ..., month: ..., day: ...)` (not a string)",
  )
  document(g.slug + ".html", title: g.title)[
    #page-shell(
      path: g.slug + ".html",
      title: g.title,
      kicker: if is-draft(g) { "Draft · " + g.source } else { g.source },
      description: g.summary,
      date: date,
      accent: g.at("color", default: "sky"),
      noindex: is-draft(g),
      g.body,
    )
  ]
}
