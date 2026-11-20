// Reusable content blocks for posts. Each maps to a CSS class in assets/style.css.
// Also re-exports this blog's animated line art from art.typ. Shared by both blogs:
// keep identical in ~/code/claude_blogs and ~/code/blog.

#import "art.typ": *   // each blog's own line art, re-exported for posts
#import "@preview/fletcher:0.5.8" as fletcher: node, edge

// Palette names usable anywhere a colour is expected. Values live in assets/style.css.
#let _palette = ("coral", "sun", "mint", "sky", "grape")

// Turn a colour argument into a CSS value: a palette name, a "#hex" string, or a Typst colour.
#let _css-color(c) = {
  if type(c) == color { c.to-hex() }
  else if c in _palette { "var(--" + c + ")" }
  else if type(c) == str and c.starts-with("#") { c }
  else { panic("callout: colour must be one of " + _palette.join(", ") + ", a \"#hex\" string or rgb(...), got " + repr(c)) }
}

// Dark or light text on top of a colour, whichever reads better.
#let _on(c) = {
  if type(c) == str and c in _palette { return if c == "sun" { "#1b1d29" } else { "#fff" } }
  let (r, g, b, ..) = rgb(c).components().map(v => v / 100%)
  if 0.2126 * r + 0.7152 * g + 0.0722 * b > 0.6 { "#1b1d29" } else { "#fff" }
}

// The one box for everything: definitions, theorems, takeaways, asides.
//
//   #callout(title: "Definition — Stream function", color: "sky")[ ... ]
//
//   title   optional label, drawn as a pill
//   color   main colour: title pill, and the background tint when `fill` is auto
//           palette name ("coral" | "sun" | "mint" | "sky" | "grape"), "#hex" or rgb(...)
//   fill    background; auto = light tint of `color`, none = page background
//   stroke  border colour; auto = the usual ink outline
//   border  "solid" | "dashed" | "dotted" | "left" (accent bar only) | "none"
//   shadow  the chunky "pressable" bottom shadow
#let callout(
  title: none,
  color: "sun",
  fill: auto,
  stroke: auto,
  border: "solid",
  shadow: true,
  body,
) = {
  assert(border in ("solid", "dashed", "dotted", "left", "none"),
    message: "callout: border must be solid, dashed, dotted, left or none")
  let vars = ("--c: " + _css-color(color), "--c-on: " + _on(color))
  if fill == none { vars.push("--c-fill: var(--bg)") } else if fill != auto {
    vars.push("--c-fill: " + _css-color(fill))
    vars.push("color: " + _on(fill))  // readable text on a custom fill, in light and dark mode
  }
  if stroke != auto { vars.push("--c-stroke: " + _css-color(stroke)) }
  let classes = "callout border-" + border + if shadow { "" } else { " no-shadow" }
  html.div(class: classes, style: vars.join("; "))[
    #if title != none { html.p(class: "callout-title")[#title] }
    #body
  ]
}

// A figure with a caption. Wrap Typst drawings in html.frame so they render as SVG:
//   #figure-box(caption: [...])[#html.frame(...)]
#let figure-box(caption: none, body) = html.figure(class: "figure-box")[
  #body
  #if caption != none { html.figcaption[#caption] }
]

// An image file shipped with the post. The file must also be listed in the post's
// `assets:` in posts/_posts.typ (main.typ copies those into the site).
//   #figure-box(caption: [...])[#fig("my-guide/figs/plot.png", alt: "what it shows")]
// `src` is relative to posts/ (e.g. "what-if/figs/fig-01.png"); it is served from the site root,
// so it works from guide pages and from chapter pages in a subfolder alike.
#let fig(src, alt: "") = html.img(src: if src.starts-with("/") or src.starts-with("http") { src } else { "/" + src }, alt: alt, loading: "lazy")

// A quick diagram (boxes and arrows), drawn with fletcher and exported as inline SVG.
//   #diagram(node((0,0), [Cause]), edge("-|>"), node((1,0), [Effect]))
// Coordinates are (column, row). See posts/dummy.typ for more examples.
#let diagram(..args) = html.frame(fletcher.diagram(
  spacing: (3em, 2em),
  node-stroke: 1pt,
  node-corner-radius: 4pt,
  node-inset: 8pt,
  ..args,
))
