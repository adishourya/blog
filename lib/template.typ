// Page shell shared by every HTML document in the bundle. Shared by both blogs:
// keep identical in ~/code/claude_blogs and ~/code/blog (site identity is in lib/site.typ).
#import "site.typ": site-title, site-tagline, site-author, nav-links

#let default-fonts = "https://fonts.googleapis.com/css2?family=Martian+Mono:wdth,wght@75..112.5,100..800&display=swap"

// Applies a saved light/dark choice before first paint; light is the default.
#let theme-init = "try{var t=localStorage.getItem('theme');if(t)document.documentElement.dataset.theme=t}catch(e){}"
#let theme-toggle-js = "(function(){var b=document.getElementById('theme-toggle'),r=document.documentElement;function sync(){b.setAttribute('aria-checked',r.dataset.theme==='dark'?'true':'false')}sync();b.addEventListener('click',function(){var n=r.dataset.theme==='dark'?'light':'dark';r.dataset.theme=n;sync();try{localStorage.setItem('theme',n)}catch(e){}})})()"
// Phones: the sticky header slides away while scrolling down and comes back on scroll up.
#let header-autohide-js = "(function(){var h=document.querySelector('.site-header'),mq=matchMedia('(max-width: 700px)'),y=scrollY;addEventListener('scroll',function(){var n=scrollY;if(!mq.matches||h.contains(document.activeElement)){h.classList.remove('is-hidden');y=n;return}if(Math.abs(n-y)<8)return;h.classList.toggle('is-hidden',n>y&&n>h.offsetHeight);y=n},{passive:true})})()"

// Reading progress: marks a chapter read when its .read-mark scrolls into view, and fills every
// .read-progress bar and the ✓ on read chapters in the contents (see progress-bar in lib/guides.typ).
#let reading-js = "(function(){function key(g){return 'read:'+g}function get(g){try{return JSON.parse(localStorage.getItem(key(g))||'[]')}catch(e){return[]}}function paint(){document.querySelectorAll('.read-progress').forEach(function(el){var g=el.dataset.guide,t=+el.dataset.total,w=+el.dataset.width,n=Math.min(get(g).length,t),f=Math.round(w*n/t);el.querySelector('.toc-bar-fill').textContent='\u2588'.repeat(f);el.querySelector('.toc-bar-empty').textContent='\u2591'.repeat(w-f);el.querySelector('.read-count').textContent=n});document.querySelectorAll('.toc-item[data-chapter]').forEach(function(li){li.classList.toggle('is-read',get(li.dataset.guide).indexOf(li.dataset.chapter)>=0)})}function mark(g,c){var r=get(g);if(r.indexOf(c)<0){r.push(c);try{localStorage.setItem(key(g),JSON.stringify(r))}catch(e){}paint()}}paint();if(!('IntersectionObserver' in window))return;var io=new IntersectionObserver(function(es){es.forEach(function(e){if(e.isIntersecting){mark(e.target.dataset.guide,e.target.dataset.chapter);io.unobserve(e.target)}})});document.querySelectorAll('.read-mark').forEach(function(m){io.observe(m)})})()"

// Sun and moon line icons for the theme switch.
#let _icon(cls, ..paths) = html.elem("svg", attrs: (
  class: cls, viewBox: "0 0 24 24", fill: "none", stroke: "currentColor",
  "stroke-width": "2.2", "stroke-linecap": "round", "stroke-linejoin": "round", "aria-hidden": "true",
))[#for d in paths.pos() { html.elem("path", attrs: (d: d)) }]
#let _sun-icon = _icon("icon-sun", "M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8z",
  "M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4")
#let _moon-icon = _icon("icon-moon", "M20.5 14.2A8.5 8.5 0 1 1 9.8 3.5a6.6 6.6 0 0 0 10.7 10.7z")

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
  jump: none,   // optional (href, label): an extra link in the sticky header, e.g. back to the contents
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
    #html.body(class: "accent-" + accent + if path == "index.html" { " home" } else { "" })[
      #html.header(class: "site-header")[
        #html.div(class: "wrap header-inner")[
          #html.a(class: "brand", href: base + "index.html")[#site-title]
          #html.nav(class: "site-nav", aria-label: "Main")[
            #if jump != none {
              let (href, label) = jump
              html.a(class: "jump", href: href, title: label)[↑#html.span(class: "jump-label")[ #label]]
            }
            #for (href, label) in nav-links {
              if href == path {
                html.a(href: base + href, aria-current: "page")[#label]
              } else {
                html.a(href: base + href)[#label]
              }
            }
            #html.button(id: "theme-toggle", class: "theme-toggle", type: "button", role: "switch", aria-label: "Dark mode", title: "Toggle dark mode")[
              #html.span(class: "toggle-knob")[#_sun-icon#_moon-icon]
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
      #html.script(header-autohide-js)
      #html.script(reading-js)
    ]
  ]
}

// "November 18, 2026"
#let long-date(d) = d.display("[month repr:long] [day padding:none], [year]")
