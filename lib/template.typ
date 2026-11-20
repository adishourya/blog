// Page shell shared by every HTML document in the bundle. Shared by both blogs:
// keep identical in ~/code/claude_blogs and ~/code/blog (site identity is in lib/site.typ).
#import "site.typ": site-title, site-tagline, site-author, nav-links

#let default-fonts = "https://fonts.googleapis.com/css2?family=Martian+Mono:wdth,wght@75..112.5,400..800&family=JetBrains+Mono:ital,wght@0,400;0,700;1,400&display=swap"

// Applies a saved light/dark choice before first paint; light is the default.
#let theme-init = "try{var t=localStorage.getItem('theme');if(t)document.documentElement.dataset.theme=t}catch(e){}"
#let theme-toggle-js = "document.getElementById('theme-toggle').addEventListener('click',function(){var r=document.documentElement,d=r.dataset.theme||'light',n=d==='dark'?'light':'dark';r.dataset.theme=n;try{localStorage.setItem('theme',n)}catch(e){}})"

// Wrap `body` in a full <html> document with head, header, nav and footer.
//   path    this page's output file (highlights the active nav link)
//   base    prefix for site-relative links: "" at the root, "../" for pages in a subfolder
//   info    key/value lines in the post header, e.g. (("source", [Hernán & Robins]), ("pages", [3–12]))
#let page-shell(
  path: "index.html",
  title: none,
  description: site-tagline,
  info: (),
  accent: "sky",
  noindex: false,
  base: "",
  fonts: default-fonts,
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
      #html.link(rel: "stylesheet", href: fonts)
      #html.link(rel: "stylesheet", href: base + "style.css")
      #html.script(theme-init)
    ]
    #html.body(class: "accent-" + accent)[
      #html.header(class: "site-header")[
        #html.div(class: "wrap header-inner")[
          #html.a(class: "brand", href: base + "index.html")[#site-title]
          #html.nav(class: "site-nav", aria-label: "Main")[
            #for (href, label) in nav-links {
              if href == path {
                html.a(href: base + href, aria-current: "page")[#label]
              } else {
                html.a(href: base + href)[#label]
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
              #html.h1[#title]
              #for (key, value) in info {
                html.p(class: "meta")[#html.span(class: "meta-key")[#key:]#html.span(class: "meta-value")[#value]]
              }
            ]
          }
          #body
        ]
      ]
      #html.footer(class: "site-footer")[
        #html.div(class: "wrap")[
          #html.p[© #datetime.today().year() #site-author · Written in #link("https://typst.app")[Typst].]
        ]
      ]
      #html.script(theme-toggle-js)
    ]
  ]
}

// "November 18, 2026"
#let long-date(d) = d.display("[month repr:long] [day padding:none], [year]")
