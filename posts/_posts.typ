// Registry of guides. Each guide is a table-of-contents page (<slug>.html) plus one page per
// written chapter (<slug>/01.html, ...). Format: see lib/guides.typ. Order here = order on the home page.

#import "what-if/toc.typ" as what-if
#import "mezard/toc.typ" as mezard

#let guides = (
  (
    slug: "statistical-physics-information-computation",
    title: "Information, Physics, and Computation",
    short: "Mézard",                   // drawn on the home-page card
    source: "Mézard & Montanari",
    summary: "Getting started with Statistical Mechanics for computation",
    color: "coral",                    // coral | sun | mint | sky | grape
    parts: mezard.parts,
  ),
  (
    slug: "causal-inference-what-if",
    title: "Causal Inference: What If",
    short: "What If?",
    source: "Hernán & Robins",
    summary: "Causality is messy on medical data",
    color: "sun",
    parts: what-if.parts,
  ),
)
