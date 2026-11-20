// Guides = a table-of-contents page plus one page per chapter, built from the guide's headings.
// Shared by both blogs: keep identical in ~/code/claude_blogs and ~/code/blog.
//
// A guide's body (posts/<guide>/index.typ, which may #include one file per chapter) is an outline:
//
//   Text before the first heading      → intro, shown above the contents
//                                        (wrap parts of it in #after-contents[...] to show them below)
//   = Part I · Something               → part heading in the contents (optional)
//   == A chapter title                 → chapter: a row in the contents and its own page
//   === 1.1 A section                  → section: listed under its chapter, linked to its anchor
//   ==== deeper                        → sub-headings inside the chapter page
//
// Status is read from the text, not written by hand:
//   section   done = it has text under it; otherwise "in progress"
//   chapter   done = it has text and none of its sections is empty; otherwise "in progress"
// A chapter gets a page as soon as it has any text. `#book-pages("3–12")` anywhere in a chapter
// adds the book's page range to the contents row and the chapter header.
//
// Keep #set / #show rules out of the top level of these files (they would hide the headings).

#let _sequence = [].func()
#let _space = [ ].func()

// Top-level pieces of a body, with #include-d files flattened in.
#let _pieces(c) = {
  if type(c) == content and c.func() == _sequence { c.children.map(_pieces).flatten() } else { (c,) }
}
#let _is-heading(c) = type(c) == content and c.func() == heading
#let _after-of(c) = if type(c) == content and c.func() == metadata and type(c.value) == dictionary and "after-contents" in c.value { c.value.after-contents } else { none }
#let _pages-of(c) = if type(c) == content and c.func() == metadata and type(c.value) == dictionary and "book-pages" in c.value { c.value.book-pages } else { none }
#let _is-blank(c) = {
  if type(c) != content { return c == none }
  let f = c.func()
  if f in (parbreak, linebreak, _space, metadata) { return true }
  if f == text { return c.text.trim() == "" }
  false
}

// Plain text of a heading (for page titles and descriptions).
#let plain(c) = {
  if type(c) == str { return c }
  if type(c) != content { return "" }
  if c.has("text") { return c.text }
  if c.has("children") { return c.children.map(plain).join("") }
  if c.has("body") { return plain(c.body) }
  if c.func() == _space { return " " }
  ""
}

#let pad2(n) = if n < 10 { "0" + str(n) } else { str(n) }

// Read the outline: (intro: (...), after: (...), parts: ((title, chapters: (...)), ...)).
#let outline-of(body) = {
  let intro = ()
  let after = ()
  let parts = ()
  let n = 0
  for c in _pieces(body) {
    if _is-heading(c) and c.depth == 1 {
      parts.push((title: c.body, chapters: ()))
    } else if _is-heading(c) and c.depth == 2 {
      if parts.len() == 0 { parts.push((title: none, chapters: ())) }
      n += 1
      parts.at(-1).chapters.push((num: n, title: c.body, body: (), sections: (), pages: none, has-text: false))
    } else if parts.len() == 0 or parts.at(-1).chapters.len() == 0 {
      let a = _after-of(c)
      if a != none { after.push(a) } else if not _is-blank(c) or intro.len() > 0 { intro.push(c) }
    } else {
      let ch = parts.at(-1).chapters.len() - 1
      let p = _pages-of(c)
      if p != none { parts.at(-1).chapters.at(ch).pages = p }
      if _is-heading(c) and c.depth == 3 {
        let id = "s" + str(n) + "-" + str(parts.at(-1).chapters.at(ch).sections.len() + 1)
        parts.at(-1).chapters.at(ch).sections.push((title: c.body, id: id, has-text: false))
        parts.at(-1).chapters.at(ch).body.push((heading: c, id: id))
      } else {
        parts.at(-1).chapters.at(ch).body.push(c)
        if not _is-heading(c) and not _is-blank(c) {
          parts.at(-1).chapters.at(ch).has-text = true
          let s = parts.at(-1).chapters.at(ch).sections.len()
          if s > 0 { parts.at(-1).chapters.at(ch).sections.at(s - 1).has-text = true }
        }
      }
    }
  }
  // chapter status
  parts = parts.map(p => (..p, chapters: p.chapters.map(c => (
    ..c, done: c.has-text and c.sections.all(s => s.has-text),
  ))))
  (intro: intro, after: after, parts: parts)
}

#let chapters-of(o) = o.parts.map(p => p.chapters).flatten()
#let chapter-path(slug, c) = slug + "/" + pad2(c.num) + ".html"

// A chapter's page body: its content, with headings moved up two levels (=== → <h2>) and
// sections given anchors for the contents links.
#let chapter-body(c) = for x in c.body {
  if type(x) == dictionary {
    html.elem("h2", attrs: (id: x.id))[#x.heading.body]
  } else if _is-heading(x) {
    html.elem("h" + str(calc.min(x.depth - 1, 6)))[#x.body]
  } else { x }
}

#let _status(done) = if done {
  html.span(class: "toc-status done")[\[done\]]
} else {
  html.span(class: "toc-status progress")[\[in progress\]]
}

// "[██████░░░░] 10 / 22 chapters done"
#let progress-bar(o, width: 22) = {
  let all = chapters-of(o)
  if all.len() == 0 { return [no chapters yet] }
  let done = all.filter(c => c.done).len()
  let filled = int(calc.round(width * done / all.len()))
  html.span(class: "toc-bar")[\[#("█" * filled)#html.span(class: "toc-bar-empty")[#("░" * (width - filled))]\]]
  [ #str(done) \/ #str(all.len()) chapters done]
}

#let toc-legend = html.p(class: "toc-legend")[
  #html.span[#_status(true) written]
  #html.span[#_status(false) not written yet, or has empty sections]
]

#let _row-cells(slug, c) = {
  html.span(class: "toc-num")[#pad2(c.num)]
  if c.has-text {
    html.a(class: "toc-title", href: chapter-path(slug, c))[#c.title]
  } else {
    html.span(class: "toc-title")[#c.title]
  }
  html.span(class: "toc-leader", aria-hidden: true)[]
  html.span(class: "toc-meta")[#if c.pages != none [pp. #c.pages] else [—]]
  _status(c.done)
}

// The whole table of contents: one heading per part, one ruled row per chapter;
// chapters with sections expand to show them (each with its own status and link).
#let toc(slug, o) = {
  if chapters-of(o).len() == 0 {
    html.p(class: "toc-empty")[No chapters planned yet.]
    return
  }
  toc-legend
  for p in o.parts [
    #if p.title != none [= #p.title]

    #html.ol(class: "toc")[
      #for c in p.chapters {
        html.li(class: "toc-item")[
          #if c.sections.len() > 0 {
            html.elem("details")[
              #html.elem("summary", attrs: (class: "toc-row"))[#_row-cells(slug, c)]
              #html.ol(class: "toc-sections")[
                #for s in c.sections {
                  html.li(class: "toc-row toc-sec")[
                    #if s.has-text {
                      html.a(class: "toc-title", href: chapter-path(slug, c) + "#" + s.id)[#s.title]
                    } else {
                      html.span(class: "toc-title")[#s.title]
                    }
                    #html.span(class: "toc-leader", aria-hidden: true)[]
                    #_status(s.has-text)
                  ]
                }
              ]
            ]
          } else {
            html.div(class: "toc-row")[#_row-cells(slug, c)]
          }
        ]
      }
    ]
  ]
}

// Previous / contents / next links at the bottom of a chapter page (from inside slug/).
#let chapter-nav(slug, o, c) = {
  let live = chapters-of(o).filter(x => x.has-text)
  let i = live.position(x => x.num == c.num)
  let link-to(x, cls, label) = html.a(class: cls, href: pad2(x.num) + ".html")[
    #html.elem("small")[#label] #pad2(x.num) #x.title
  ]
  html.nav(class: "chapter-nav", aria-label: "Chapters")[
    #if i > 0 { link-to(live.at(i - 1), "prev", "← previous") } else { html.span[] }
    #html.a(class: "up", href: "../" + slug + ".html")[Contents]
    #if i + 1 < live.len() { link-to(live.at(i + 1), "next", "next →") } else { html.span[] }
  ]
}
