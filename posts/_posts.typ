// Registry of guides. Drives the index page and the per-post documents in main.typ.
//
// To publish a guide: write posts/<slug>.typ, set `status: "published"`, a `date`,
// and `body: include "<slug>.typ"`. See posts/dummy.typ for a tour of everything a post can use.
//
// Fields:  slug, title, source, summary, color (coral | sun | mint | sky | grape),
//          short (optional: name drawn on the card banner, defaults to title),
//          status ("published" | "ongoing" | "planned"), date + body (published only).

#let guides = (
  (
    slug: "statistical-physics-information-computation",
    color: "coral",          // coral | sun | mint | sky | grape
    title: "Information, Physics, and Computation",
    short: "Mézard",
    source: "Mézard & Montanari",
    summary: "Getting started with Statistical Mechanics for computation",
    status: "planned",
  ),
  // (
  //   slug: "statistical-physics-of-learning",
  //   color: "grape",          // coral | sun | mint | sky | grape
  //   title: "Statistical Mechanics of Neural Networks",
  //   source: "Haiping Huang",
  //   summary: "Replicas, perceptrons and mean-field theory as a lens on modern AI.",
  //   status: "planned",
  // ),
  //
  // (
  //   slug: "deep-hopfield-networks",
  //   color: "sky",          // coral | sun | mint | sky | grape
  //   title: "Deep Hopfield Networks",
  //   source: "Associative memory, revisited",
  //   summary: "From energy-based attractors to modern Hopfield layers and attention.",
  //   status: "planned",
  // ),
  //
  // (
  //   slug: "diffusion-models-computation",
  //   color: "mint",          // coral | sun | mint | sky | grape
  //   title: "Computation for Diffusion Models",
  //   source: "Score-based generative modelling",
  //   summary: "SDEs, score matching and what it actually costs to sample.",
  //   status: "planned",
  // ),
  (
    slug: "causal-inference-what-if",
    color: "sun",          // coral | sun | mint | sky | grape
    title: "Causal Inference: What If",
    short: "What If?",
    source: "Hernán & Robins",
    summary: "Causality is messy on medical data",
    status: "published",
    date: datetime(year: 2026, month: 11, day: 17),
    body: include "what_if.typ",
  ),
)

#let published = guides.filter(g => g.status == "published")
