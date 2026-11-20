// Contents of the What If guide: parts, chapters, statuses and chapter files.
// Status: "read" = published, "draft" = being written (only ./dev.sh shows it), "todo" = planned.
// To publish a chapter: write posts/what-if/chNN.typ, add `body: include "chNN.typ"`, set status "read".
// Format: see lib/guides.typ.

#let parts = (
  (title: "Part I · Causal inference without models", chapters: (
    (num: 1, title: "A definition of causal effect", pages: "3–12", status: "draft", body: include "ch01.typ"),
    (num: 2, title: "Randomized experiments", pages: "13–26", status: "todo"),
    (num: 3, title: "Observational studies", pages: "27–42", status: "todo"),
    (num: 4, title: "Effect modification", pages: "43–56", status: "todo"),
    (num: 5, title: "Interaction", pages: "57–70", status: "todo"),
    (num: 6, title: "Graphical representation of causal effects", pages: "71–84", status: "todo"),
    (num: 7, title: "Confounding", pages: "85–102", status: "todo"),
    (num: 8, title: "Selection bias", pages: "103–118", status: "todo"),
    (num: 9, title: "Measurement bias and “noncausal” diagrams", pages: "119–130", status: "todo"),
    (num: 10, title: "Random variability", pages: "131–144", status: "todo"),
  )),
  (title: "Part II · Causal inference with models", chapters: (
    (num: 11, title: "Why model?", status: "todo"),
    (num: 12, title: "IP weighting and marginal structural models", status: "todo"),
    (num: 13, title: "Standardization and the parametric g-formula", status: "todo"),
    (num: 14, title: "G-estimation of structural nested models", status: "todo"),
    (num: 15, title: "Outcome regression and propensity scores", status: "todo"),
    (num: 16, title: "Instrumental variable estimation", status: "todo"),
    (num: 17, title: "Causal survival analysis", status: "todo"),
    (num: 18, title: "Variable selection and high-dimensional data", status: "todo"),
  )),
  (title: "Part III · Causal inference from complex longitudinal data", chapters: (
    (num: 19, title: "Time-varying treatments", status: "todo"),
    (num: 20, title: "Treatment-confounder feedback", status: "todo"),
    (num: 21, title: "G-methods for time-varying treatments", status: "todo"),
    (num: 22, title: "Target trial emulation", status: "todo"),
  )),
)
