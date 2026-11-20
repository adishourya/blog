#import "../../lib/components.typ": *

#callout(title: "Takeaway of the section", color: olive)[
Before we move ahead with the section. #link("Information Theory, Inference and Learning Algorithms")[Information Theory by David J. C MacKay] is a highly suggested read if you ever get interested in information theory and its applications. We will only go over quick instincts of information theory; which i believe is replete for the book.
]

===  Entropy and Information Content
*Entropy is a measure of uncertainity*. The higher the uncertainity of an event; the higher the entropy of the event.

#callout(title: "definition", color: blue)[
Entropy is defined as:

#math.equation(
  block: true,
  $"Entropy =" sum_x ( p(X=x) * log_2 (1/p(X=x) ) ) $,
)

]
Notice that it is obviously inversely proportional to the probability of the
event. Some events can be incredibly rare.. so we soften it with a $log$. Its
important to note how Entropy is an expected quantity. Its an average of all
the inforrmation conntent of all the events $x$.

An information content is defined for a particular event $x$. and $log_2(x)$ is
its information content. The base of the log depends on the convenience of the
discussion. But the most common unit of information is called a 'bit' if the base of the log is 2.

#callout(title:"alert", color:red)[
*Note "1 bit of information" is very much different than a binary digit which we also call bit,
for the rest of the article we will never iterchangably call a binary digit a bit*
]

==== Exemplars of calculating Entropy and Information Content.
+ A fair coin toss has 2 equally probable outcomes, i.e a toss of a coin has 1 bit of information. And observing either 'heads' or a 'tails' has 1 bit of information content.

+ A deck of playing cards has 36 pip (number) cards and 12 (face) cards. If the set of events be observing a face card or observing a pip card. Then the entropy of that event would be = $log_2(1)$

