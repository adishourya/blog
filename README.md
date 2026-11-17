# Infinite Improbability

*Hitchhiker's guides to physics, computation & learning.* Live at **https://adishourya.pages.dev**.

The whole site is written in [Typst](https://typst.app) and compiled to HTML with Typst's
(experimental) **bundle** export: one `main.typ` emits every page, the stylesheet and the
images. Every push to `main` rebuilds and deploys to Cloudflare Pages via GitHub Actions.

## Layout

```
main.typ              # entry point: emits index.html, about.html and one page per published guide
posts/_posts.typ      # registry of guides (title, summary, status, date, body) — drives the home grid
posts/about.typ       # the About page
posts/<slug>.typ      # one file per guide
lib/template.typ      # page shell: <head>, header/nav, theme toggle, footer; site title & tagline
lib/components.typ    # content blocks: guide-entry, definition, theorem, remark, margin-note, figure-box
lib/art.typ           # animated line art (inline SVG): hero cylinder flow, card banners, wave divider
posts/dummy.typ       # style guide: a tour of every feature (unlisted page at /dummy)
assets/style.css      # the theme (light/dark, full-width, grid of guides)
build.sh              # production build into dist/ (published guides only; same as CI)
dev.sh                # live preview with auto-reload + drafts, into dist-dev/
.github/workflows/deploy.yml   # CI: build + deploy on push to main
```

## Requirements

- Typst **0.15.1** (CI pins the same version, so keep them in sync).
- Optional: Python, to preview locally.

## Write a new guide

> **Start from the style guide.** `posts/dummy.typ` shows every feature (text, math, callouts,
> line art, Typst-drawn figures, code, tables, raw HTML) next to its source. It renders as an
> unlisted page at **/dummy**: not on the home page, and marked `noindex` for search engines.
> Copy it to `posts/<slug>.typ` and delete what you don't need.

1. **Create the post** at `posts/<slug>.typ`. The slug becomes the URL: `adishourya.pages.dev/<slug>`.

   ```typ
   #import "../lib/components.typ": *

   #guide-entry[
     One-paragraph summary of what this guide covers and who it's for.
   ]

   = The cavity method
   Consider a factor graph with $N$ variables $x_i in {plus.minus 1}$ …

   $ Z = sum_(bold(x)) product_a psi_a (bold(x)_(partial a)) $

   #definition(title: "Bethe free energy")[
     $F_"Bethe" = -1/beta log Z_"Bethe"$
   ]

   == A sub-section
   More text, *bold*, _italic_, `code`, #link("https://example.com")[a link].
   ```

   Do **not** add a title at the top: the template renders it from the registry.
   `=` in a post becomes an `<h2>`, `==` an `<h3>`, and so on.

2. **Register it** in `posts/_posts.typ`. Either flip an existing planned entry or add a new one:

   ```typ
   (
     slug: "deep-hopfield-networks",
     title: "Deep Hopfield Networks",
     color: "sky",                                  // card/accent colour: coral | sun | mint | sky | grape
     short: "Hopfield",                             // optional: name drawn in outline on the card banner
     source: "Associative memory, revisited",      // small label above the title
     summary: "From energy-based attractors to modern Hopfield layers and attention.",
     status: "published",                           // or "ongoing" ("In progress") / "planned" ("Coming soon")
     date: datetime(year: 2026, month: 11, day: 17),
     body: include "deep-hopfield-networks.typ",
   ),
   ```

   `date` and `body` are only needed when `status: "published"`. Cards appear on the home
   page in the order of this list.

3. **Preview while writing**

   ```sh
   ./dev.sh            # → http://127.0.0.1:3000  (or ./dev.sh 8000 for another port)
   ```

   This rebuilds on every save and **reloads the browser automatically**. Compile errors print
   in the terminal, and the last good version stays on screen until you fix them. It also renders
   **drafts**: any guide with a `body` whose status isn't `"published"` gets a page (marked
   "Draft" with a "Draft preview →" card). Output goes to `dist-dev/`, which is git-ignored.

   To check exactly what will go live, build like CI does: `./build.sh`, then open `dist/`.

4. **Publish**: commit and push to `main`. The *Build & deploy* workflow takes about a minute.
   Watch it with `gh run watch`.

### Drafts

Give the guide a `body` but keep `status: "ongoing"` (or `"planned"`). `./dev.sh` renders it so you
can write and preview; `./build.sh` and the deploy skip it, so the live site only shows an
"In progress" card. `date` is optional for drafts. When it's ready, set `status: "published"`
and a `date`, then push.

### "My change didn't show up"

- **The build failed.** `./build.sh` stops at the first Typst error and prints `error: …` (easy to miss
  among the `warning:` lines). With `./dev.sh` the error shows on every save.
- **It's a draft.** `./build.sh` skips anything not `"published"`. Use `./dev.sh`.
- **Browser cache.** `python -m http.server` lets the browser reuse old copies. Hard-refresh
  (Ctrl+Shift+R) or use `./dev.sh`, which reloads for you.

## Components (`lib/components.typ`)

| Call | Renders as |
|---|---|
| `#guide-entry(title: "From the Guide")[…]` | yellow aside, good for a TL;DR |
| `#definition(title: "…")[…]` | blue box |
| `#theorem(title: "…")[…]` | purple box |
| `#remark[…]` | dashed green box |
| `#callout(kind: "note", title: "…")[…]` | generic box (`kind` maps to CSS class `callout-<kind>`) |
| `#margin-note[…]` | small accent-tinted side note |
| `#figure-box(caption: […])[…]` | framed figure with caption (wrap Typst drawings in `html.frame`) |
| `#cylinder-flow()` | animated line art: potential flow past a cylinder + vortex street + sun |
| `#flow-divider()` | animated wave line between sections |

To add a component: define a function that returns `html.div(class: "my-thing")[…]` (or any
`html.<tag>`) in `lib/components.typ`, then style `.my-thing` in `assets/style.css`.

## Math, code, images

- **Math** is exported as native MathML, so no KaTeX/MathJax. Inline `$x^2$`, display `$ x^2 $`
  (spaces inside the dollars).
- **Code**: ```` ```python … ``` ```` gets syntax highlighting (light colours baked in by Typst,
  so code blocks stay on a light card in dark mode too).
- **Images**: `#image("figs/plot.svg")`. Paths are relative to the post file. Images are inlined into the
  page, so keep them reasonably small (prefer SVG).
- **Typst-drawn figures** (cetz, plots, diagrams): wrap them in `#html.frame[…]`. That renders the
  content as an inline SVG, exactly as it would look in a PDF.

## HTML export caveats

Typst's HTML export is still experimental. Things to know:

- Page-layout features (`page`, `columns`, `place`, `pagebreak`, `h`/`v` spacing) have no HTML meaning
  and are ignored. Use `html.frame` when you need exact visual layout.
- `#footnote` is not supported (it clashes with the custom page shell). Use `#margin-note[…]`.
- Raw HTML is available everywhere: `html.div(class: "x")[…]`, `html.elem("details")[…]`, etc.
- `--features html,bundle` must be passed (already in `build.sh` and CI).
- When upgrading Typst, bump `typst-version` in `.github/workflows/deploy.yml` too, then build
  locally and check the output before pushing.

## Theme

Sunny, playful line art with a fluid-mechanics feel: the home page shows animated streamlines of
potential flow past a cylinder (computed in `lib/art.typ` from ψ = U·y·(1 − R²/r²)) with a vortex
street and a sun; each guide card has flowing streamlines behind its name drawn in outline; section
headings get a travelling wave underline. Cards and boxes have thick outlines with a "pressable"
bottom shadow; Outfit headings, Nunito Sans body text.

- **Animations** (`.flow`, `.spin`, `.wave` in `assets/style.css`) are pure CSS and switch off
  automatically when the reader has "reduce motion" enabled.

- **Palette**: five colours (`coral`, `sun`, `mint`, `sky`, `grape`), each with a `-tint`, defined at the
  top of `assets/style.css`. A guide's `color` in the registry sets its card colour *and* the accent
  of its post page (header box, heading underlines, links, list markers).
- **Light/dark**: `:root` holds the light values, `:root[data-theme="dark"]` the dark ones. The ☾/☀ button toggles and remembers the choice in
  `localStorage`. Light is the default; dark only applies after the reader clicks the toggle.
- **Width**: header, hero and the guide grid span the full viewport (side padding `--pad`); the grid
  fits as many 290px+ cards per row as it can. Article text sits in a centred column of
  `--measure` (52rem).
- Site title, tagline and nav links live at the top of `lib/template.typ`.

## Deployment

`.github/workflows/deploy.yml` runs on every push to `main` (or manually: `gh workflow run "Build & deploy"`):
checkout → install Typst 0.15.1 → `./build.sh` → `wrangler pages deploy dist --project-name=adishourya`.

Repository secrets it needs:

| Secret | Value |
|---|---|
| `CLOUDFLARE_API_TOKEN` | Cloudflare API token with **Account → Cloudflare Pages → Edit** |
| `CLOUDFLARE_API_ACCOUNT_ID` | Cloudflare account ID |

If the token expires, deploys fail with an auth error: create a new token and run
`gh secret set CLOUDFLARE_API_TOKEN`.
