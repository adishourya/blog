// Bundle entry point: every page of the site is a `document` emitted from here.
// Build with ./build.sh (typst compile --features html,bundle --format bundle main.typ dist/).

#import "lib/template.typ": page-shell, long-date
#import "lib/site.typ": site-title, site-tagline, site-fonts
// This blog's fonts (lib/site.typ) instead of the shared template's default.
#let page-shell = page-shell.with(fonts: site-fonts)
#import "lib/guides.typ": outline-of, chapters-of, chapter-path, chapter-body, guide-flow, pad2, plain, progress-bar, toc, chapter-nav
#import "posts/_posts.typ": guides
#import "lib/art.typ": cylinder-flow, card-banner

// Each guide's outline (contents, chapters, statuses), read from its headings once.
#let outlines = guides.map(g => outline-of(g.body))

#asset("style.css", read("assets/theme.css") + "\n" + read("assets/art.css"))

// Files a guide ships with (images etc.), listed in its registry entry as `assets:` (paths relative
// to posts/). Assets must be registered here, at the top level.
#for g in guides {
  for p in g.at("assets", default: ()) { asset(p, read("posts/" + p, encoding: none)) }
}

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

    #html.h2(class: "section-title")[Articles]
    #html.ul(class: "guide-grid")[
      #for (i, g) in guides.enumerate() {
        html.li(class: "guide-card card-" + g.at("color", default: "sky"))[
          #html.div(class: "card-art")[#card-banner(g.at("short", default: g.title), seed: i)]
          #html.div(class: "card-body")[
            #html.p(class: "guide-source")[#g.source]
            #html.h3[#html.a(href: g.slug + ".html")[#g.title]]
            #html.p(class: "guide-summary")[#g.summary]
            #html.p(class: "guide-progress")[#progress-bar(outlines.at(i), width: 12)]
          ]
        ]
      }
    ]
  ]
]

// ---------- About ----------
#document("about.html", title: "About")[
  #page-shell(path: "about.html", title: "About me", description: "Who writes these guides.")[
    #include "posts/about.typ"
  ]
]

// ---------- Style guide (unlisted: not on the home page, reachable at /dummy) ----------
#document("dummy.html", title: "How to write a post")[
  #page-shell(
    path: "dummy.html",
    title: "How to write a post",
    info: (("page", [style guide]), ("updated", [#long-date(datetime(year: 2026, month: 11, day: 20))])),
    description: "A tour of everything a post on this blog can use.",
    accent: "mint",
    noindex: true,
  )[
    #include "posts/dummy.typ"
  ]
]

// ---------- Articles: a contents page each, plus one page per chapter that has text ----------
#for (g, o) in guides.zip(outlines) {
  document(g.slug + ".html", title: g.title)[
    #page-shell(
      path: g.slug + ".html",
      title: g.title,
      info: (("source", g.source), ("progress", progress-bar(o))),
      description: g.summary,
      accent: g.at("color", default: "sky"),
      jump: ("#contents", "Contents"),
    )[
      #o.intro.join()
      #toc(g.slug, o)
      #o.after.join()
      #guide-flow(g.slug, o)
    ]
  ]

  for c in chapters-of(o).filter(c => c.has-text) {
    let info = (
      ("article", html.a(href: "../" + g.slug + ".html")[#g.title]),
      ("chapter", [#pad2(c.num)#if not c.done [ (in progress)]]),
    )
    if c.pages != none { info.push(("pages", [#g.source, pp. #c.pages])) }
    document(chapter-path(g.slug, c), title: plain(c.title))[
      #page-shell(
        path: chapter-path(g.slug, c),
        title: c.title,
        info: info,
        description: g.title + ", chapter " + str(c.num) + ": " + plain(c.title),
        accent: g.at("color", default: "sky"),
        base: "../",
        jump: ("../" + g.slug + ".html#contents", "Contents"),
      )[
        #chapter-body(c)
        #chapter-nav(g.slug, o, c)
      ]
    ]
  }
}
