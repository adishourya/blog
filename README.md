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
lib/components.typ    # content blocks: guide-entry, definition, theorem, remark, margin-note
assets/style.css      # the theme (light/dark, full-width, grid of guides)
build.sh              # builds the site into dist/
.github/workflows/deploy.yml   # CI: build + deploy on push to main
```

## Requirements

- Typst **0.15.1** (CI pins the same version, so keep them in sync).
- Optional: Python, to preview locally.

## Write a new guide

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
     source: "Associative memory, revisited",      // small label above the title
     summary: "From energy-based attractors to modern Hopfield layers and attention.",
     status: "published",                           // "planned" = greyed "Coming soon" card
     date: datetime(year: 2026, month: 11, day: 17),
     body: include "deep-hopfield-networks.typ",
   ),
   ```

   `date` and `body` are only needed when `status: "published"`. Cards appear on the home
   page in the order of this list.

3. **Preview locally**

   ```sh
   ./build.sh && python -m http.server -d dist 8000
   # open http://localhost:8000
   ```

   For a live-reload loop while writing:

   ```sh
   typst watch --features html,bundle --format bundle main.typ dist/ &
   python -m http.server -d dist 8000
   ```

4. **Publish**: commit and push to `main`. The *Build & deploy* workflow takes about a minute.
   Watch it with `gh run watch`.

Drafts: keep a post's `status: "planned"` (no page is generated) until it's ready, or work on a branch.
Only `main` deploys.

## Components (`lib/components.typ`)

| Call | Renders as |
|---|---|
| `#guide-entry(title: "From the Guide")[…]` | accent-tinted aside, good for a TL;DR |
| `#definition(title: "…")[…]` | box with blue left rule |
| `#theorem(title: "…")[…]` | box with amber left rule |
| `#remark[…]` | dashed box |
| `#callout(kind: "note", title: "…")[…]` | generic box (`kind` maps to CSS class `callout-<kind>`) |
| `#margin-note[…]` | small muted side note |

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

- Page-layout features (`page`, `columns`, `place`, `pagebreak`, fixed sizes) have no HTML meaning
  and are ignored. Use `html.frame` when you need exact visual layout.
- Raw HTML is available everywhere: `html.div(class: "x")[…]`, `html.elem("details")[…]`, etc.
- `--features html,bundle` must be passed (already in `build.sh` and CI).
- When upgrading Typst, bump `typst-version` in `.github/workflows/deploy.yml` too, then build
  locally and check the output before pushing.

## Theme

- Colours are CSS variables at the top of `assets/style.css`: `:root` for light, and the two dark
  blocks (`prefers-color-scheme` and `[data-theme="dark"]`). Keep those two dark blocks identical.
- The ☾/☀ button toggles light/dark and remembers the choice in `localStorage`. With no choice saved,
  the OS setting wins.
- Content uses the full viewport width with responsive side padding (`--pad`). Guides render as a
  responsive grid (`.guide-grid`, min card width 280px).
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
