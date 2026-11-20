// =====================================================================
//  posts/dummy.typ — a tour of everything a post can use.
//  Rendered (unlisted) at /dummy. Copy what you need into a chapter file.
//
//  A chapter is plain Typst. Its title, chapter number and page range come
//  from the guide's toc.typ, so do NOT put a title at the top.
//  Headings: `=` → <h2>, `==` → <h3>, `===` → <h4>.
// =====================================================================

#import "../lib/components.typ": *

// ---------------------------------------------------------------------
// callout: the one box for everything. Default is a yellow TL;DR box.
// ---------------------------------------------------------------------
#callout(title: "From the Guide")[
  This page is a working example. Each section shows one feature, and the
  Typst source sits in `posts/dummy.typ`. Read the two side by side.
]

= Text basics

Plain paragraphs need nothing special. Use *bold*, _italic_, `inline code`,
and #link("https://typst.app/docs")[links]. A blank line starts a new paragraph.
Smart quotes and dashes work: "quotes", 'single', en–dash, em---dash.

Lists:
- Unordered items use `-`
- They can nest
  - like this
+ Ordered items use `+`
+ and number themselves

Term lists use `/ Term: description`:
/ Reynolds number: ratio of inertial to viscous forces, $"Re" = U L \/ nu$.
/ Strouhal number: dimensionless shedding frequency, $"St" = f D \/ U$.

#quote(block: true, attribution: [L. F. Richardson])[
  Big whirls have little whirls that feed on their velocity,
  and little whirls have lesser whirls, and so on to viscosity.
]

= Math

Inline math goes between dollars with no inner spaces: the velocity is
$bold(u) = nabla phi$. Put spaces inside the dollars for a display equation:

$ (partial bold(u)) / (partial t) + (bold(u) dot nabla) bold(u)
  = -1/rho nabla p + nu nabla^2 bold(u) $

Aligned, multi-line derivations use `&` and `\`:

$ psi(r, theta) &= U (r - R^2 / r) sin theta \
  u_r &= 1/r (partial psi)/(partial theta) = U (1 - R^2/r^2) cos theta $

Math is exported as native MathML, so it is crisp at any zoom and needs no JavaScript.

= Callout boxes

There is one box, `#callout`, and you style it with arguments. With no arguments it's a
yellow box with an ink outline and the chunky shadow:

#callout(title: "Takeaway")[
  `#callout(title: "Takeaway")[...]`. The title is optional.
]

`color` takes a palette name (`"coral"`, `"sun"`, `"mint"`, `"sky"`, `"grape"`),
a hex string, or any Typst colour. It sets the title pill and a light background tint:

#callout(title: "Definition — Stream function", color: "sky")[
  For 2-D incompressible flow, $psi$ is defined by
  $u = partial_y psi$, $v = -partial_x psi$, so $nabla dot bold(u) = 0$ holds automatically.
]

#callout(title: "Theorem — Kelvin's circulation theorem", color: "grape")[
  In an inviscid, barotropic fluid with conservative body forces, the circulation
  around a material loop is constant: $ (D Gamma) / (D t) = 0 $
]

`fill` sets the background exactly, and `stroke` sets the border colour:

#callout(title: "Custom colours", color: "#0f766e", fill: "#ccfbf1", stroke: "#0f766e")[
  `color: "#0f766e", fill: "#ccfbf1", stroke: "#0f766e"`
]

`border` is `"solid"` (default), `"dashed"`, `"dotted"`, `"left"` (an accent bar only)
or `"none"`. `shadow: false` removes the bottom shadow:

#callout(title: "Remark", color: "mint", border: "dashed", shadow: false)[
  `border: "dashed", shadow: false`: softer, for asides and caveats.
]

#callout(color: "coral", border: "left")[
  `border: "left"` with no title: a quiet side note, good for citations or fun-fact tangents.
]

#callout(title: "Any Typst colour", color: rgb("#ff9f1c"), stroke: rgb("#ff9f1c"), fill: none, border: "dotted")[
  `color: rgb("#ff9f1c"), stroke: rgb("#ff9f1c"), fill: none, border: "dotted"`: transparent background.
]

= Line art & animation

`#cylinder-flow()` draws the animated hero figure: streamlines of potential flow
past a cylinder, computed from $psi = U y (1 - R^2 \/ r^2)$, with a vortex street in the wake.

#figure-box(caption: [Potential flow past a cylinder, from `#cylinder-flow()`.])[
  #cylinder-flow()
]

`#flow-divider()` is an animated wave for separating big sections:

#flow-divider()

Animations stop automatically for readers who turn on "reduce motion".

= Quick diagrams

Prefer a small diagram to a paragraph whenever something has parts and arrows:
a pipeline, a cause and its effects, a before/after. `#diagram` draws boxes and arrows
with #link("https://typst.app/universe/package/fletcher")[fletcher]. Coordinates are
(column, row), and `edge("-|>")` with no coordinates connects the previous and next node.

#figure-box(caption: [A confounder: $L$ causes both treatment $A$ and outcome $Y$.])[
  #diagram(
    node((0, 0), $L$, shape: circle),
    edge((0, 0), (1, 1), "-|>"),
    edge((0, 0), (2, 1), "-|>", bend: 20deg),
    node((1, 1), $A$, shape: circle),
    edge("-|>"),
    node((2, 1), $Y$, shape: circle),
  )
]

#figure-box(caption: [A pipeline: label edges, colour the node that matters.])[
  #diagram(
    node((0, 0), [Raw data]),
    edge("-|>", [clean]),
    node((1, 0), [Cohort]),
    edge("-|>", [weight]),
    node((2, 0), [Estimate], fill: rgb("#fff4d4")),
  )
]

```typ
#figure-box(caption: [...])[
  #diagram(
    node((0, 0), [Raw data]), edge("-|>", [clean]),
    node((1, 0), [Cohort]),  edge("-|>", [weight]),
    node((2, 0), [Estimate], fill: rgb("#fff4d4")),
  )
]
```

Images shipped with a guide go in `posts/<guide>/figs/` and are listed in the guide's
`assets:` in `posts/_posts.typ`; show one with
`#figure-box(caption: [...])[#fig("<guide>/figs/plot.png", alt: "...")]`.

= Figures drawn with Typst

Anything Typst can draw goes inside `html.frame`, which renders it as a crisp SVG.
Packages like `cetz` or `lilaq` work the same way.

#figure-box(caption: [A Typst-drawn velocity profile: laminar (parabolic) vs. turbulent (flatter).])[
  #html.frame(block(width: 12cm, inset: 4pt)[
    #let w = 10cm
    #let h = 4cm
    #let pts(f) = range(0, 41).map(i => {
      let y = i / 40
      ((f(y) * w * 0.9), (h - y * h))
    })
    #place(curve(stroke: 1.5pt + rgb("#13c2a3"),
      curve.move(pts(y => 4 * y * (1 - y)).first()),
      ..pts(y => 4 * y * (1 - y)).slice(1).map(p => curve.line(p))))
    #place(curve(stroke: (paint: rgb("#ff6b57"), thickness: 1.5pt, dash: "dashed"),
      curve.move(pts(y => calc.pow(1 - calc.abs(2 * y - 1), 1 / 7)).first()),
      ..pts(y => calc.pow(1 - calc.abs(2 * y - 1), 1 / 7)).slice(1).map(p => curve.line(p))))
    #place(line(start: (0pt, 0pt), end: (0pt, h), stroke: 1pt + gray))
    #box(height: h)
  ])
]

Images work too: `#image("figs/plot.svg")` (paths are relative to the post file).
They get inlined into the page, so prefer small SVGs.

= Code

Fenced code blocks get syntax highlighting:

```python
import numpy as np

def stream_function(x, y, U=1.0, R=1.0):
    """Potential flow past a cylinder."""
    r2 = x**2 + y**2
    return U * y * (1 - R**2 / r2)
```

```typ
#callout(title: "Stream function", color: "sky")[ ... ]
```

= Tables

#table(
  columns: 3,
  table.header[Regime][Reynolds number][What you see],
  [Creeping], [$"Re" < 1$], [Symmetric, attached flow],
  [Steady wake], [$5 < "Re" < 40$], [Two fixed recirculation bubbles],
  [Vortex street], [$40 < "Re" < 200$], [Periodic shedding, $"St" approx 0.2$],
  [Turbulent wake], [$"Re" > 10^3$], [Chaotic, broadband],
)

= Raw HTML (escape hatch)

When you need an element Typst doesn't have, write it directly:

#html.elem("details")[
  #html.elem("summary")[Click to expand a collapsible section]
  Hidden content: handy for long derivations or exercise solutions.
]

// Note: Typst's #footnote is not supported in this HTML setup yet.
// Use #callout(border: "left")[...] for asides instead.

#flow-divider()

That's the whole toolbox. To start a real guide: add `posts/<guide>/toc.typ` with its chapters,
write each chapter as `posts/<guide>/chNN.typ`, and register the guide in `posts/_posts.typ`
(see README.md).
