// Page shell shared by every HTML document in the bundle.

// #let site-title = "Infinite Improbability"
#let site-title = "Underclocked Thoughts"
// #let site-tagline = "Hitchhiker's guides to physics, computation & learning — by Adi Shourya."
#let site-tagline = "A slow atom drifting through computational waters."

#let nav-links = (
  ("index.html", "Guides"),
  ("about.html", "About"),
)

// Applies a saved light/dark choice before first paint; light is the default.
#let theme-init = "try{var t=localStorage.getItem('theme');if(t)document.documentElement.dataset.theme=t}catch(e){}"
#let theme-toggle-js = "document.getElementById('theme-toggle').addEventListener('click',function(){var r=document.documentElement,d=r.dataset.theme||'light',n=d==='dark'?'light':'dark';r.dataset.theme=n;try{localStorage.setItem('theme',n)}catch(e){}})"

// Wrap `body` in a full <html> document with head, header, nav and footer.
// `path` is this page's output file, used to highlight the active nav link.
#let page-shell(
  path: "index.html",
  title: none,
  description: site-tagline,
  date: none,
  kicker: none,
  accent: "sky",
  noindex: false,
  body,
) = {
  let full-title = if title == none { site-title } else { title + " · " + site-title }

  html.html(lang: "en")[
    #html.head[
      #html.meta(charset: "utf-8")
      #html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
      #html.meta(name: "description", content: description)
      #if noindex { html.meta(name: "robots", content: "noindex") }
      #html.title(full-title)
      #html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
      #html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")
      #html.link(
        rel: "stylesheet",
        href: "https://fonts.googleapis.com/css2?family=Outfit:wght@500;600;700;800&family=Nunito+Sans:ital,opsz,wght@0,6..12,400;0,6..12,600;0,6..12,700;1,6..12,400&family=JetBrains+Mono:wght@400;600&display=swap",
      )
      #html.link(rel: "stylesheet", href: "style.css")
      #html.script(theme-init)
    ]
    #html.body(class: "accent-" + accent)[
      #html.header(class: "site-header")[
        #html.div(class: "wrap header-inner")[
          #html.a(class: "brand", href: "index.html")[#site-title]
          #html.nav(class: "site-nav", aria-label: "Main")[
            #for (href, label) in nav-links {
              if href == path {
                html.a(href: href, aria-current: "page")[#label]
              } else {
                html.a(href: href)[#label]
              }
            }
            #html.button(id: "theme-toggle", class: "theme-toggle", type: "button", aria-label: "Toggle dark mode", title: "Toggle dark mode")[
              #html.span(class: "icon-sun")[☀]#html.span(class: "icon-moon")[☾]
            ]
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
                  #html.time(datetime: date)[#date.display("[month repr:long] [day padding:none], [year]")]
                ]
              }
            ]
          }
          #body
        ]
      ]
      #html.footer(class: "site-footer")[
        #html.div(class: "wrap")[
          #html.p[© #datetime.today().year() Adi Shourya · Written in #link("https://typst.app")[Typst].]
        ]
      ]
      #html.script(theme-toggle-js)
    ]
  ]
}
