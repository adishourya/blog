// Registry of articles. Each one is an outline (posts/<article>/index.typ): its headings become
// the contents page (<slug>.html) and the chapter pages (<slug>/01.html, ...). See lib/guides.typ.
// Order here = order on the home page.


#let guides = (
  (
    slug: "statistical-physics-information-computation",
    title: "Information, Physics, and Computation",
    short: "Mézard",                   // drawn on the home-page card
    source: "Mézard & Montanari",
    summary: "Getting started with Statistical Mechanics for computation",
    color: "coral",                    // coral | sun | mint | sky | grape
    body: include "mezard/index.typ",
  ),
  (
    slug: "causal-inference-what-if",
    title: "Causal Inference: What If",
    short: "What If?",
    source: "Hernán & Robins",
    summary: "Causality is messy on medical data",
    color: "sun",
    body: include "what-if/index.typ",
  ),
)
