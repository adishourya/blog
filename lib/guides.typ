// Guides = a table-of-contents page plus one page per chapter. Shared by both blogs:
// keep identical in ~/code/claude_blogs and ~/code/blog.
//
// A guide (in posts/_posts.typ):
//   (slug, title, short, source, summary, color, intro: [...] or none,
//    parts: ((title: "Part I · ...", chapters: (CHAPTER, ...)), ...))
// A chapter:
//   (num: 1, title: "...", pages: "3–12" or none, status: "read" | "draft" | "todo",
//    sections: (("1.1", "Title"), ...), body: include "..." (needed for read/draft),
//    date: datetime(...) (optional))
// Status: "read" = written and published; "draft" = being written (only rendered by ./dev.sh);
// "todo" = planned (listed, not linked).

#let pad2(n) = if n < 10 { "0" + str(n) } else { str(n) }
#let chapters-of(g) = g.parts.map(p => p.chapters).flatten()
#let chapter-path(g, c) = g.slug + "/" + pad2(c.num) + ".html"
#let is-live(c, drafts) = "body" in c and (c.status == "read" or (drafts and c.status == "draft"))

// "[██████░░░░] 10 / 22 chapters"
#let progress-bar(g, width: 22) = {
  let all = chapters-of(g)
  let done = all.filter(c => c.status == "read").len()
  if all.len() == 0 { return [no chapters yet] }
  let filled = int(calc.round(width * done / all.len()))
  html.span(class: "toc-bar")[\[#("█" * filled)#html.span(class: "toc-bar-empty")[#("░" * (width - filled))]\]]
  [ #str(done) \/ #str(all.len()) chapters]
}

#let toc-legend = html.p(class: "toc-legend")[
  #html.span[#html.span(class: "toc-status read")[\[read\]] written]
  #html.span[#html.span(class: "toc-status draft")[\[draft\]] being written]
  #html.span[#html.span(class: "toc-status todo")[\[todo\]] planned]
]

#let _row-cells(g, c, drafts) = {
  html.span(class: "toc-num")[#pad2(c.num)]
  if is-live(c, drafts) {
    html.a(class: "toc-title", href: chapter-path(g, c))[#c.title]
  } else {
    html.span(class: "toc-title")[#c.title]
  }
  html.span(class: "toc-leader", aria-hidden: true)[]
  html.span(class: "toc-meta")[#if c.at("pages", default: none) != none [pp. #c.pages] else [—]]
  html.span(class: "toc-status " + c.status)[\[#c.status\]]
}

// The whole table of contents: one heading per part, one ruled row per chapter;
// chapters with sections expand to show them.
#let toc(g, drafts: false) = {
  if chapters-of(g).len() == 0 {
    html.p(class: "toc-empty")[No chapters planned yet.]
  } else {
    toc-legend
  }
  for p in g.parts [
    #if p.at("title", default: none) != none [= #p.title]

    #html.ol(class: "toc")[
      #for c in p.chapters {
        let secs = c.at("sections", default: ())
        html.li(class: "toc-item")[
          #if secs.len() > 0 {
            html.elem("details")[
              #html.elem("summary", attrs: (class: "toc-row"))[#_row-cells(g, c, drafts)]
              #html.ol(class: "toc-sections")[
                #for (num, title) in secs {
                  html.li(class: "toc-row toc-sec")[
                    #html.span(class: "toc-num")[#num]
                    #html.span(class: "toc-title")[#title]
                  ]
                }
              ]
            ]
          } else {
            html.div(class: "toc-row")[#_row-cells(g, c, drafts)]
          }
        ]
      }
    ]
  ]
}

// Previous / contents / next links at the bottom of a chapter page (from inside g.slug/).
#let chapter-nav(g, c, drafts: false) = {
  let live = chapters-of(g).filter(x => is-live(x, drafts))
  let i = live.position(x => x.num == c.num)
  let link-to(x, cls, label) = html.a(class: cls, href: pad2(x.num) + ".html")[
    #html.elem("small")[#label] #pad2(x.num) #x.title
  ]
  html.nav(class: "chapter-nav", aria-label: "Chapters")[
    #if i > 0 { link-to(live.at(i - 1), "prev", "← previous") } else { html.span[] }
    #html.a(class: "up", href: "../" + g.slug + ".html")[Contents]
    #if i + 1 < live.len() { link-to(live.at(i + 1), "next", "next →") } else { html.span[] }
  ]
}
