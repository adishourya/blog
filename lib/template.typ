// Page shell shared by every HTML document in the bundle.

#let site-title = "The Hitchhiker's Guide to X"
#let site-tagline = "Mostly harmless notes on physics, computation & learning."

#let nav-links = (
  ("index.html", "Guides"),
  ("about.html", "About"),
)

// Wrap `body` in a full <html> document with head, header, nav and footer.
// `path` is this page's output file, used to highlight the active nav link.
#let page-shell(
  path: "index.html",
  title: none,
  description: site-tagline,
  date: none,
  kicker: none,
  body,
) = {
  let full-title = if title == none { site-title } else { title + " · " + site-title }

  html.html(lang: "en")[
    #html.head[
      #html.meta(charset: "utf-8")
      #html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
      #html.meta(name: "description", content: description)
      #html.title(full-title)
      #html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
      #html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")
      #html.link(
        rel: "stylesheet",
        href: "https://fonts.googleapis.com/css2?family=Atkinson+Hyperlegible:ital,wght@0,400;0,700;1,400&family=JetBrains+Mono:wght@400;700;800&display=swap",
      )
      #html.link(rel: "stylesheet", href: "style.css")
    ]
    #html.body[
      #html.header(class: "site-header")[
        #html.div(class: "wrap header-inner")[
          #html.a(class: "brand", href: "index.html")[
            #html.span(class: "brand-kicker")[The Hitchhiker's Guide to]
            #html.span(class: "brand-x")[X]
          ]
          #html.nav(class: "site-nav", aria-label: "Main")[
            #for (href, label) in nav-links {
              if href == path {
                html.a(href: href, aria-current: "page")[#label]
              } else {
                html.a(href: href)[#label]
              }
            }
          ]
        ]
      ]
      #html.main(class: "wrap")[
        #html.article[
          #if title != none {
            html.header(class: "post-header")[
              #if kicker != none { html.p(class: "kicker")[#kicker] }
              #html.h1[#title]
              #if date != none {
                html.p(class: "meta")[
                  #html.time(datetime: date.display())[#date.display("[month repr:long] [day padding:none], [year]")]
                ]
              }
            ]
          }
          #body
        ]
      ]
      #html.footer(class: "site-footer")[
        #html.div(class: "wrap")[
          #html.span(class: "dont-panic small")[Don't Panic]
          #html.p[Written in #link("https://typst.app")[Typst]. Always know where your towel is.]
        ]
      ]
    ]
  ]
}
