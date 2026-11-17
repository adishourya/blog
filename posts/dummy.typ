// =====================================================================
//  posts/dummy.typ — a tour of everything a post can use.
//  Rendered (unlisted) at /dummy. Copy this file to start a new guide.
//
//  A post is plain Typst. The page title, kicker and date come from the
//  registry (posts/_posts.typ), so do NOT put a title at the top.
//  Headings: `=` → <h2>, `==` → <h3>, `===` → <h4>.
// =====================================================================

#import "../lib/components.typ": *

// ---------------------------------------------------------------------
// guide-entry: the yellow TL;DR box. Good as the first thing in a post.
// ---------------------------------------------------------------------
#guide-entry(title: "From the Guide")[
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

#definition(title: "Stream function")[
  For 2-D incompressible flow, $psi$ is defined by
  $u = partial_y psi$, $v = -partial_x psi$, so $nabla dot bold(u) = 0$ holds automatically.
]

#theorem(title: "Kelvin's circulation theorem")[
  In an inviscid, barotropic fluid with conservative body forces, the circulation
  around a material loop is constant: $ (D Gamma) / (D t) = 0 $
]

#remark[
  A remark is softer: an aside, a caveat, a "you can skip this".
]

#callout(kind: "definition", title: "Any title you like")[
  `callout(kind: ..., title: ...)` is the generic version.
  `kind` is one of `"definition"`, `"theorem"` or `"note"`, and sets the colour.
]

Margin notes are small asides that sit inline with the text:
#margin-note[Like this one. Use them for citations or "fun fact" tangents.]
the paragraph simply continues after them.

= Line art & animation

`#cylinder-flow()` draws the animated hero figure: streamlines of potential flow
past a cylinder, computed from $psi = U y (1 - R^2 \/ r^2)$, with a vortex street in the wake.

#figure-box(caption: [Potential flow past a cylinder, from `#cylinder-flow()`.])[
  #cylinder-flow()
]

`#flow-divider()` is an animated wave for separating big sections:

#flow-divider()

Animations stop automatically for readers who turn on "reduce motion".

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
#definition(title: "Stream function")[ ... ]
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
// Use #margin-note[...] for asides instead.

#flow-divider()

That's the whole toolbox. To start a real guide: copy this file to
`posts/<slug>.typ`, delete what you don't need, and register it in `posts/_posts.typ`.
