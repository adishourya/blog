// Mézard & Montanari, Information, Physics, and Computation (OUP 2009), as one outline.
// Chapter titles from the publisher's table of contents. Write under a == heading (or #include a
// chNN.typ file that starts with it); === headings become its sections. See lib/guides.typ.
#import "../../lib/components.typ": *

#callout(title: "Need for statistical mechanics for ML Engineers?", color:blue.lighten(20%))[
Most of the time we think the subject of analysis for statistical mechanics is
something like a solid state magnet. But that is not at all the case. Statistical
mechanics has built sophisticated methods to deal with situations where there
are very large number of candidates for a sollution. Just like in *Artificial
intellegence*.
]

#callout(title:"Quick Fact")[
Physicsts Geoffrey Hinton and John J. Hopfield won the 2024 Nobel
Prize in Physics for their contribution in the work of Boltzman machines. A
mostly computer science problem.
]

= Part 1 Background
== Basics of information theory
#include("chap1.typ")

== Introduction to combinatorial optimization
== Probabilistic toolbox

= Part2 Independence
== The random energy model
== Random code ensemble
== Number partitioning
== Introduction to replica theory

= Part 3 Models on Graphs
== Factor graphs and graph ensembles
== Satisfiability
== Low-density parity-check codes
== Spin glasses
== Bridges: inference and Monte Carlo

= Part 4 Short-Range Correlation
== Belief propagation
== Decoding with belief propagation
== The assignment problem
== Ising models on random graphs

= Part 5 Long Range Correlations
== Linear Boolean equations
== The 1RSB cavity method
== Random K-satisfiability
== Glassy states in coding theory
== An ongoing story
