// Animated line art (inline SVG). All strokes use `currentColor` or CSS classes,
// so they follow the light/dark theme and the page accent. Animations live in
// assets/style.css (.flow, .spin, .wave) and are disabled for prefers-reduced-motion.

#let _svg(view, class: "", label: none, body) = {
  let attrs = (viewBox: view, class: "line-art " + class, fill: "none")
  if label == none { attrs.insert("aria-hidden", "true") } else {
    attrs.insert("role", "img")
    attrs.insert("aria-label", label)
  }
  html.elem("svg", attrs: attrs, body)
}
#let _path(d, class: "", ..extra) = html.elem("path", attrs: (d: d, class: class) + extra.named())
#let _circle(cx, cy, r, class: "") = html.elem("circle", attrs: (cx: str(cx), cy: str(cy), r: str(r), class: class))
#let _line(x1, y1, x2, y2, class: "") = html.elem(
  "line",
  attrs: (x1: str(x1), y1: str(y1), x2: str(x2), y2: str(y2), class: class),
)
#let _fmt(v) = str(calc.round(v, digits: 1))
#let _poly(pts) = "M" + pts.map(p => _fmt(p.at(0)) + " " + _fmt(p.at(1))).join(" L")

// A streamline drawn twice: a faint guide line plus travelling "particles".
#let _streamline(d, speed: 0) = {
  _path(d, class: "stream")
  _path(d, class: "flow flow-" + str(speed))
}

// ---------- Potential flow past a cylinder ----------
// Stream function psi = y (1 - R^2 / (x^2 + y^2)); solve psi = c for y by bisection.
#let _psi-y(x, c, R) = {
  let s = if c < 0 { -1 } else { 1 }
  let c = calc.abs(c)
  let lo = if calc.abs(x) < R { calc.sqrt(R * R - x * x) + 0.01 } else { 0.0 }
  let hi = c + R + 1
  for _ in range(40) {
    let m = (lo + hi) / 2
    if m * (1 - R * R / (x * x + m * m)) < c { lo = m } else { hi = m }
  }
  s * (lo + hi) / 2
}

// Small Archimedean spiral (a vortex), centred at (cx, cy).
#let _vortex(cx, cy, r, turns: 2.2, dir: 1) = {
  let n = 48
  let pts = range(n + 1).map(i => {
    let t = i / n
    let a = dir * t * turns * 2 * calc.pi
    (cx + r * t * calc.cos(a), cy + r * t * calc.sin(a))
  })
  _path(_poly(pts), class: "vortex spin" + if dir < 0 { " spin-rev" } else { "" })
}

// Sun with rays (rays rotate slowly).
#let _sun(cx, cy, r) = {
  _circle(cx, cy, r, class: "sun-disc")
  html.elem("g", attrs: (class: "sun-rays spin-slow"))[
    #for i in range(12) {
      let a = i * 30deg
      _line(
        _fmt(cx + (r + 9) * calc.cos(a)), _fmt(cy + (r + 9) * calc.sin(a)),
        _fmt(cx + (r + 20) * calc.cos(a)), _fmt(cy + (r + 20) * calc.sin(a)),
        class: "sun-ray",
      )
    }
  ]
}

// Hero / figure: uniform flow past a cylinder, a vortex street in the wake, and the sun.
#let cylinder-flow(label: "Streamlines of uniform flow past a cylinder, with a vortex street in its wake") = {
  let (W, H, cx, cy, R) = (600, 330, 190, 205, 40)
  _svg("0 0 " + str(W) + " " + str(H), class: "cylinder-flow", label: label)[
    #_sun(540, 42, 20)
    #for (i, c) in (-112, -84, -58, -36, -16, 16, 36, 58, 84, 112).enumerate() {
      let pts = range(0, W + 1, step: 6).map(x => (x, cy - _psi-y(x - cx, c, R)))
      _streamline(_poly(pts), speed: calc.rem(i, 3))
    }
    #_circle(cx, cy, R, class: "body")
    #_line(cx - R - 4, cy, cx + R + 4, cy, class: "body-axis")
    #for (k, x) in (290, 360, 430, 500, 570).enumerate() {
      let up = calc.rem(k, 2) == 0
      _vortex(x, cy + if up { -16 } else { 16 }, 13 - k, dir: if up { 1 } else { -1 })
    }
  ]
}

// Card banner: gentle wavy streamlines with the guide name written in outline.
#let card-banner(name, seed: 0) = {
  let (W, H) = (320, 160)
  let fs = calc.min(46, 520 / calc.max(name.len(), 1))
  _svg("0 0 " + str(W) + " " + str(H), class: "card-banner")[
    #for i in range(6) {
      let y0 = 18 + i * 25
      let amp = 5 + calc.rem(i + seed, 3) * 3
      let ph = (i + seed) * 0.9
      let pts = range(0, W + 1, step: 8).map(x => (x, y0 + amp * calc.sin(x / 38 + ph)))
      _streamline(_poly(pts), speed: calc.rem(i + seed, 3))
    }
    #html.elem("text", attrs: (
      x: "50%", y: "52%", class: "banner-name",
      "text-anchor": "middle", "dominant-baseline": "middle",
      "font-size": str(fs),
    ))[#name]
  ]
}

// Animated wave line, full width. Use between sections.
#let flow-divider() = html.elem("svg", attrs: (
  viewBox: "0 0 400 24", class: "line-art flow-divider", fill: "none",
  preserveAspectRatio: "none", "aria-hidden": "true",
))[
  #html.elem("g", attrs: (class: "wave"))[
    #_path(_poly(range(0, 801, step: 4).map(x => (x, 12 + 6 * calc.sin(x / 40 * 2 * calc.pi)))), class: "wave-line")
  ]
]
