// Registry of guides. Drives the index page and the per-post documents in main.typ.
//
// To publish a guide: write posts/<slug>.typ, set `status: "published"`, a `date`,
// and `body: include "<slug>.typ"`. Planned guides show up on the index as "coming soon".

#let guides = (
  (
    slug: "statistical-physics-information-computation",
    color: "coral",          // coral | sun | mint | sky | grape
    glyph: "∑",          // big symbol on the card
    title: "Information, Physics, and Computation",
    source: "Mézard & Montanari",
    summary: "Spin glasses, the cavity method, and why random constraint satisfaction problems freeze.",
    status: "planned",
  ),
  (
    slug: "statistical-physics-of-learning",
    color: "grape",          // coral | sun | mint | sky | grape
    glyph: "β",          // big symbol on the card
    title: "Statistical Mechanics of Neural Networks",
    source: "Haiping Huang",
    summary: "Replicas, perceptrons and mean-field theory as a lens on modern AI.",
    status: "planned",
  ),
  (
    slug: "deep-hopfield-networks",
    color: "sky",          // coral | sun | mint | sky | grape
    glyph: "∇",          // big symbol on the card
    title: "Deep Hopfield Networks",
    source: "Associative memory, revisited",
    summary: "From energy-based attractors to modern Hopfield layers and attention.",
    status: "planned",
  ),
  (
    slug: "diffusion-models-computation",
    color: "mint",          // coral | sun | mint | sky | grape
    glyph: "∂",          // big symbol on the card
    title: "Computation for Diffusion Models",
    source: "Score-based generative modelling",
    summary: "SDEs, score matching and what it actually costs to sample.",
    status: "planned",
  ),
  (
    slug: "causal-inference-what-if",
    color: "sun",          // coral | sun | mint | sky | grape
    glyph: "⫫",          // big symbol on the card
    title: "Causal Inference: What If",
    source: "Hernán & Robins",
    summary: "Counterfactuals, confounding, and the g-methods without the panic.",
    status: "planned",
  ),
)

#let published = guides.filter(g => g.status == "published")
