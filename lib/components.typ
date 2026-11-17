// Reusable content blocks for posts. Each maps to a CSS class in assets/style.css.
// Also re-exports the animated line art from art.typ (flow-divider, cylinder-flow).

#import "art.typ": flow-divider, cylinder-flow

// A boxed aside, as if quoted from the Guide itself.
#let guide-entry(title: "From the Guide", body) = html.aside(class: "guide-entry")[
  #html.p(class: "guide-entry-title")[#title]
  #body
]

// Definition / theorem / remark style boxes.
#let callout(kind: "note", title: none, body) = html.div(class: "callout callout-" + kind)[
  #if title != none { html.p(class: "callout-title")[#title] }
  #body
]
#let definition(title: none, body) = callout(kind: "definition", title: if title == none { "Definition" } else { "Definition — " + title }, body)
#let theorem(title: none, body) = callout(kind: "theorem", title: if title == none { "Theorem" } else { "Theorem — " + title }, body)
#let remark(body) = callout(kind: "note", title: "Remark", body)

// Small note set off from the main text (floats into the margin on wide screens).
#let margin-note(body) = html.span(class: "margin-note")[#body]

// A figure with a caption. Wrap Typst drawings in html.frame so they render as SVG:
//   #figure-box(caption: [...])[#html.frame(...)]
#let figure-box(caption: none, body) = html.figure(class: "figure-box")[
  #body
  #if caption != none { html.figcaption[#caption] }
]
