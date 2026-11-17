// Bundle entry point: every page of the site is a `document` emitted from here.
// Build with ./build.sh (typst compile --features html,bundle --format bundle main.typ dist/).

#import "lib/template.typ": page-shell, site-title, site-tagline
#import "posts/_posts.typ": guides, published

#asset("style.css", read("assets/style.css"))

// ---------- Home ----------
#document("index.html", title: site-title)[
  #page-shell(path: "index.html")[
    #html.section(class: "hero")[
      #html.h1(class: "hero-title")[#site-title]
      #html.p(class: "hero-lede")[#site-tagline Long books, distilled into guides you can carry in your pocket.]
    ]

    #html.h2(class: "section-title")[Guides]
    #html.ul(class: "guide-grid")[
      #for g in guides {
        let is-live = g.status == "published"
        html.li(class: "guide-card" + if is-live { "" } else { " is-planned" })[
          #html.p(class: "guide-source")[#g.source]
          #html.h3[
            #if is-live { html.a(href: g.slug + ".html")[#g.title] } else { g.title }
          ]
          #html.p[#g.summary]
          #html.p(class: "guide-status")[
            #if is-live { g.date.display("[month repr:short] [day padding:none], [year]") } else { "Coming soon" }
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

// ---------- Guides ----------
#for g in published {
  document(g.slug + ".html", title: g.title)[
    #page-shell(
      path: g.slug + ".html",
      title: g.title,
      kicker: g.source,
      description: g.summary,
      date: g.date,
      g.body,
    )
  ]
}
