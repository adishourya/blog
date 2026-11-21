# Underclocked Thoughts

*A slow atom drifting through computational waters.* Live at **https://adishourya.pages.dev**.

The whole site is written in [Typst](https://typst.app) and compiled to HTML with Typst's
(experimental) **bundle** export: one `main.typ` emits every page, the stylesheet and the images.
Every push to `main` rebuilds and deploys to Cloudflare Pages via GitHub Actions.

**Sibling blog:** `~/code/claude_blogs` (Claude Thoughts, private) uses the same engine and theme. The files marked *shared* below
must stay identical in both repos; copy them across when you change them.

## How the site is organised

Every guide follows a book or a course, and is written as **one outline**: `posts/<guide>/index.typ`
(which can `#include` one file per chapter). Typst reads its headings and builds:

- **`<slug>.html` — the guide's front page**: the intro (text before the first heading), then a
  **table of contents** made from the headings, one row per chapter, each opening to its
  sections. Statuses come from the text itself: a section with nothing under it is
  `[in progress]`, otherwise `[done]`; a chapter is `[done]` when it has text and no empty sections.
  Below the contents the page **continues with every chapter that has text**, so scrolling down
  reads the whole guide; the contents link to those chapters and sections on the same page.
- **`<slug>/01.html`, `<slug>/02.html`, … — one page per chapter that has any text**, with
  previous / contents / next links. Sections get anchors, so the contents can link straight to them.
- The **home page** lists every guide with a progress bar (chapters done / chapters).

## Layout

```
main.typ                # entry point: home, about, style guide, and for each guide its contents + chapter pages
posts/_posts.typ        # registry of guides (order = order on the home page)
posts/<guide>/index.typ # a guide as one outline: = part, == chapter, === section (contents + statuses come from it)
posts/<guide>/chNN.typ  # optional: one file per chapter, #include-d from index.typ
posts/<guide>/figs/     # images shipped with a guide (listed in its `assets:`)
posts/about.typ         # the About page
posts/dummy.typ         # style guide: every feature next to its source (unlisted page at /dummy)
lib/site.typ            # this blog's name, tagline, author, nav links
lib/template.typ        # page shell: <head>, header, theme toggle, post header, footer        (shared)
lib/guides.typ          # reads the outline: contents, statuses, chapter pages, navigation (shared)
lib/components.typ      # callout, figure-box, fig, diagram, book-pages, after-contents   (shared)
lib/art.typ             # this blog's line art: fluid line art (hero cylinder flow, card banners, wave divider)
assets/theme.css        # the Notebook theme (dot grid, margin line)                                          (shared)
assets/art.css          # this blog's brand mark and art styles
build.sh                # production build into dist/ (same as CI)
dev.sh                  # live preview with auto-reload, into dist-dev/
.github/workflows/deploy.yml   # CI: build + deploy on push to main
```

## Requirements

- Typst **0.15.1** (CI pins the same version, so keep them in sync).
- Network access on the first build: diagrams use the `@preview/fletcher` package, which Typst
  downloads and caches.

## Add a guide

1. Write the outline in `posts/<guide>/index.typ`:

   ```typ
   #import "../../lib/components.typ": *

   A short intro: shown above the table of contents.

   #after-contents[ Notation, sources, …: shown below the table of contents. ]

   = Part I · Foundations            // optional part headings
   #include "ch01.typ"               // a chapter file that starts with its == heading
   == The second chapter             // an empty chapter: listed as [in progress]
   #book-pages("21–40")              // optional: the book's page range
   ```

   Heading levels: `=` part, `==` chapter, `===` section (listed in the contents), `====` and
   deeper are sub-headings inside the chapter page. Keep `#set` / `#show` rules out of the top level.

2. Register it in `posts/_posts.typ`:

   ```typ
   (
     slug: "my-guide",                  // URL: /my-guide.html and /my-guide/01.html
     title: "My Guide",
     short: "Guide",                    // drawn in outline on the home-page card
     source: "Author & Author",         // shown on the card and in the page headers
     summary: "One line for the home-page card.",
     color: "sky",                      // coral | sun | mint | sky | grape
     body: include "my-guide/index.typ",
     assets: (),                        // image files under posts/, e.g. ("my-guide/figs/a.png",)
   ),
   ```

## Write a chapter

Start from the style guide: `posts/dummy.typ` shows every feature (callouts, quick diagrams, maths,
figures, code, tables) next to its source, and renders unlisted at **/dummy**.

1. Write under the chapter's `==` heading, either in `index.typ` or in `posts/<guide>/chNN.typ`
   (start it with `#import "../../lib/components.typ": *` and the `== Title` line, then
   `#include` it from `index.typ`). Use `===` for sections.
2. As soon as a chapter has text it gets a page; once every section has text it shows `[done]`.
   Empty `===` headings are a to-do list: they show as `[in progress]` until you fill them.
3. Preview with `./dev.sh` (→ http://127.0.0.1:3000; rebuilds on save and reloads the browser).
4. Publish: commit and push to `main`. The deploy takes about a minute (`gh run watch`).

### "My change didn't show up"

- **The build failed.** `./build.sh` stops at the first Typst error and prints `error: …` (easy to miss
  among the `warning:` lines).
- **The chapter has no text yet**, so it has no page (it's listed as `[in progress]`).
- **Browser cache.** Hard-refresh (Ctrl+Shift+R), or use `./dev.sh`, which reloads for you.

## Components (`lib/components.typ`)

There is **one box**, `#callout`, styled with arguments:

```typ
#callout(
  title: "Definition — Stream function",  // optional title tag on the top border
  color: "sky",        // frame + tint: "coral" | "sun" | "mint" | "sky" | "grape", "#hex" or rgb(...)
  fill: auto,          // background: auto = tint of color, none = transparent, or a colour
  stroke: auto,        // border colour: auto = the box colour
  border: "solid",     // "solid" | "dashed" | "dotted" | "left" (accent bar only) | "none"
  shadow: true,
)[ ... ]
```

Conventions: summary / takeaways → default (`sun`), definition → `sky` + `border: "left"`,
technical detail → `grape`, side note → `mint` + `border: "dashed"`, citation → `coral` + `border: "left"`.

| Other helpers | Renders as |
|---|---|
| `#diagram(node(…), edge("-\|>"), …)` | quick boxes-and-arrows diagram ([fletcher](https://typst.app/universe/package/fletcher)), inline SVG |
| `#figure-box(caption: […])[…]` | framed figure with caption |
| `#fig("<guide>/figs/x.png", alt: "…")` | an image file shipped with the guide (lazy-loaded; list it in `assets:`) |
| `#cylinder-flow()` | animated hero: the CPU mascot in a stream (potential flow past a cylinder), a vortex street and a sun |
| `#flow-divider()` | animated wave line between sections |

## Maths, code, images

- **Diagrams first.** Explain with small `#diagram`s whenever something has parts, steps or causes.
- **Maths** is exported as native MathML. Inline `$x^2$`, display `$ x^2 $`.
- **Code**: ```` ```python … ``` ```` gets syntax highlighting (on a light card in both themes).
- **Images**: put them in `posts/<guide>/figs/`, list them in the guide's `assets:`, and show them
  with `#fig(...)` inside a `#figure-box`. (`#image(...)` inlines the image into the page; use it only
  for tiny ones.)
- **Typst-drawn figures** (cetz, plots): wrap them in `#html.frame[…]` to get an inline SVG.

## HTML export caveats

Typst's HTML export is still experimental:

- Page-layout features (`page`, `columns`, `place`, `pagebreak`, `h`/`v` spacing) are ignored in HTML.
  Use `html.frame` when you need exact visual layout.
- `#footnote` is not supported. Use `#callout(border: "left")[…]`.
- Raw HTML is available everywhere: `html.div(class: "x")[…]`, `html.elem("details")[…]`, etc.
- When upgrading Typst, bump `typst-version` in `.github/workflows/deploy.yml` too.

## Theme: Notebook (`assets/theme.css`, shared)

- **Paper**: a faint dot grid across the whole page; on wide screens, binding holes down the left
  edge and a red double margin line beside the text column (both hidden on phones).
- **Type**: Martian Mono (wide) for headings, Spline Sans Mono (weight 460) for everything else, ~17–18px on laptops.
- **Headings**: `h2` sits on a rule that starts with a short clay bar; no `#` markers.
- **Boxes**: square panels in the box's colour with the title tag on the top border; hard offset
  shadows on the post header, figures, code and cards.
- **Contents**: one row per chapter (number, title, dotted leader, `[done]` / `[in progress]`),
  opening to its sections. No page numbers there — the book's pages show in each chapter's header.
- **Colours**: `coral`, `sun`, `mint`, `sky`, `grape` plus `clay` for numbers and accents. A guide's
  `color` sets its card and the accent of its pages.
- **Light/dark**: light is the default; the ☾/☀ button switches and remembers the choice. Dark mode
  is neutral grey (#212121), never blue-tinted.
- **Width**: the text column is about 80% of a laptop screen and stops at 1600px on ultra-wide
  screens.
- **Art**: the CPU mascot (also the brand mark) and fluid line art — the hero shows the mascot sitting in a
  stream: streamlines of potential flow past a cylinder (computed in
  `lib/art.typ` from ψ = U·y·(1 − R²/r²)) with a vortex street and a sun; guide cards have flowing
  streamlines behind their name; `#flow-divider()` is a travelling wave. Animations are pure CSS
  (`assets/art.css`) and switch off when the reader has "reduce motion" enabled.

## Deployment

`.github/workflows/deploy.yml` runs on every push to `main` (or manually: `gh workflow run "Build & deploy"`):
checkout → install Typst 0.15.1 → `./build.sh` → `wrangler pages deploy dist --project-name=adishourya`.

Repository secrets it needs:

| Secret | Value |
|---|---|
| `CLOUDFLARE_API_TOKEN` | Cloudflare API token with **Account → Cloudflare Pages → Edit** |
| `CLOUDFLARE_API_ACCOUNT_ID` | Cloudflare account ID |
