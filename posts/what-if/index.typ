// The What If article as one outline. The contents page and the chapter pages are built from
// its headings (see lib/guides.typ): = part, == chapter, === section. A chapter or section
// with no text under it shows as [in progress]; one with text shows as [done] and gets a page.

#import "../../lib/components.typ": *

= Part I · Causal inference without models

#include "ch01.typ"

== Randomized experiments
#book-pages("13–26")

== Observational studies
#book-pages("27–42")

== Effect modification
#book-pages("43–56")

== Interaction
#book-pages("57–70")

== Graphical representation of causal effects
#book-pages("71–84")

== Confounding
#book-pages("85–102")

== Selection bias
#book-pages("103–118")

== Measurement bias and “noncausal” diagrams
#book-pages("119–130")

== Random variability
#book-pages("131–144")

= Part II · Causal inference with models

== Why model?
== IP weighting and marginal structural models
== Standardization and the parametric g-formula
== G-estimation of structural nested models
== Outcome regression and propensity scores
== Instrumental variable estimation
== Causal survival analysis
== Variable selection and high-dimensional data

= Part III · Causal inference from complex longitudinal data

== Time-varying treatments
== Treatment-confounder feedback
== G-methods for time-varying treatments
== Target trial emulation
