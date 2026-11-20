# Underclocked Thoughts

*A slow atom drifting through computational waters.* Live at **https://adishourya.pages.dev**.

The whole site is written in [Typst](https://typst.app) and compiled to HTML with Typst's
(experimental) **bundle** export: one `main.typ` emits every page, the stylesheet and the images.
Every push to `main` rebuilds and deploys to Cloudflare Pages via GitHub Actions.

**Sibling blog:** `~/code/claude_blogs` (Claude Thoughts, private) uses the same engine and theme. The files marked *shared* below
must stay identical in both repos; copy them across when you change them.

## How the site is organised

Every guide follows a book or a course:

- **`<slug>.html` — the guide's front page**: a short intro, then a **table of contents**. One ruled
  row per chapter with page range and a status tag: `[read]` (written, linked), `[draft]` (being
  written) or `[todo]` (planned). Rows open to show the chapter's sections.
- **`<slug>/01.html`, `<slug>/02.html`, … — one page per written chapter**, with previous / contents /
  next links at the bottom.
- The **home page** lists every guide with a progress bar. Guides are always open: what's
  missing shows up as `[todo]` rows in the contents, not as "coming soon" cards.

## Layout

```
main.typ                # entry point: home, about, style guide, and for each guide its contents + chapter pages
posts/_posts.typ        # registry of guides (order = order on the home page)
posts/<guide>/toc.typ   # a guide's parts and chapters: title, pages, status, sections, body
posts/<guide>/chNN.typ  # one file per chapter
posts/<guide>/figs/     # images shipped with a guide (listed in its `assets:`)
posts/about.typ         # the About page
posts/dummy.typ         # style guide: every feature next to its source (unlisted page at /dummy)
lib/site.typ            # this blog's name, tagline, author, nav links
lib/template.typ        # page shell: <head>, header, theme toggle, post header, footer        (shared)
lib/guides.typ          # table of contents, progress bar, chapter navigation               (shared)
lib/components.typ      # content blocks: callout, figure-box, fig, diagram                 (shared)
lib/art.typ             # this blog's line art: fluid line art (hero cylinder flow, card banners, wave divider)
assets/theme.css        # the Ruled Notebook theme                                          (shared)
assets/art.css          # this blog's brand mark and art styles
build.sh                # production build into dist/ (same as CI)
dev.sh                  # live preview with auto-reload + drafts, into dist-dev/
.github/workflows/deploy.yml   # CI: build + deploy on push to main
```

## Requirements

- Typst **0.15.1** (CI pins the same version, so keep them in sync).
- Network access on the first build: diagrams use the `@preview/fletcher` package, which Typst
  downloads and caches.

## Add a guide

1. Create `posts/<guide>/toc.typ` with its parts and chapters:

   ```typ
   #let parts = (
     (title: "Part I · Foundations", chapters: (
       (num: 1, title: "Introduction", pages: "1–20", status: "read",
        sections: (("1.1", "Why this matters"), ("1.2", "Notation")),
        body: include "ch01.typ"),
       (num: 2, title: "The second chapter", status: "todo"),
     )),
   )
   ```

   `pages` and `sections` are optional. `body` is needed for `read` and `draft`; `todo` chapters
   are only listed. A guide without parts can use a single part with `title: none`.

2. Register it in `posts/_posts.typ`:

   ```typ
   #import "my-guide/toc.typ" as my-guide
   (
     slug: "my-guide",                  // URL: /my-guide.html and /my-guide/01.html
     title: "My Guide",
     short: "Guide",                    // drawn in outline on the home-page card
     source: "Author & Author",         // shown on the card and in the page headers
     summary: "One line for the home-page card.",
     color: "sky",                      // coral | sun | mint | sky | grape
     intro: include "my-guide/intro.typ",   // optional: shown above the contents
     notes: include "my-guide/notes.typ",   // optional: shown below the contents
     parts: my-guide.parts,
     assets: (),                        // image files under posts/, e.g. ("my-guide/figs/a.png",)
   ),
   ```

## Write a chapter

Start from the style guide: `posts/dummy.typ` shows every feature (callouts, quick diagrams, maths,
figures, code, tables) next to its source, and renders unlisted at **/dummy**.

1. Write `posts/<guide>/chNN.typ`. Start it with `#import "../../lib/components.typ": *`. Don't put
   the chapter title at the top — the page header shows it. `=` makes a section heading.
2. In `toc.typ`, give the chapter `body: include "chNN.typ"` and `status: "draft"` while writing,
   then `"read"` when it's done. List its `sections` so the contents can show them.
3. Preview with `./dev.sh` (→ http://127.0.0.1:3000): rebuilds on save, reloads the browser, and
   also renders `draft` chapters. `./build.sh` builds exactly what will go live.
4. Publish: commit and push to `main`. The deploy takes about a minute (`gh run watch`).

### "My change didn't show up"

- **The build failed.** `./build.sh` stops at the first Typst error and prints `error: …` (easy to miss
  among the `warning:` lines).
- **It's a draft.** Production builds only render `read` chapters. Use `./dev.sh`.
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
| `#cylinder-flow()` | animated hero: potential flow past a cylinder, a vortex street and a sun |
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

## Theme: Ruled Notebook (`assets/theme.css`, shared)

- **Type**: Martian Mono (wide) for headings, JetBrains Mono for everything else.
- **Ruled lines**: every paragraph and list item draws its own notebook lines, one directly under each
  line of text, so they never cross text. Inline maths and code are kept from stretching a line.
  Boxes, figures, tables and display maths are not ruled.
- **Headings**: `h2` sits on a rule that starts with a short clay bar; no `#` markers.
- **Boxes**: square panels in the box's colour with the title tag on the top border; hard offset
  shadows on the post header, figures, code and cards.
- **Colours**: `coral`, `sun`, `mint`, `sky`, `grape` plus `clay` for numbers and accents. A guide's
  `color` sets its card and the accent of its pages.
- **Light/dark**: light is the default; the ☾/☀ button switches and remembers the choice. Dark mode
  is neutral grey (#212121), never blue-tinted.
- **Width**: the text column is about 80% of a laptop screen and stops at 1600px on ultra-wide
  screens.
- **Art**: fluid line art — the hero shows streamlines of potential flow past a cylinder (computed in
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
