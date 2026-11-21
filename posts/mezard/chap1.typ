#import "../../lib/components.typ": *

#callout(title: "Takeaway of the section", color: olive)[
Before we move ahead with the section. #link("https://www.inference.org.uk/mackay/itila/")[Information Theory by David J. C MacKay] is a highly suggested read if you ever get interested in information theory and its applications. We will only go over quick instincts of information theory; which i believe is replete for the book.
]

===  Entropy and Information Content
==== Entropy
*Entropy is a measure of uncertainity*. The higher the uncertainity of an experiment; the higher the entropy.

#callout(title: "definition", color: blue)[
Entropy is defined as:

#math.equation(
  block: true,
  $"Entropy =" sum_x ( p(X=x) * log_2 (1/p(X=x) ) ) $,
)


]
Its important to note how Entropy is an expected quantity. Its an average of all the information content of all the events $x$.

==== Information Content
An information content is defined for a particular event $x$. and $log_2(x)$ is
its information content. The base of the log depends on the convenience of the operation. For an example if your loss function is an entropy function and the last layer does softmax you're better off using log with base exp in your loss function as that would undo the exponentiation of softmax. But the most common unit of information is called a 'bit' if the base of the log is 2.

#callout(title:"alert", color:red)[
*Note "1 bit of information" is very much different than a binary digit which we also call bit, so for the rest of the article we will never iterchangably call a binary digit a bit.*
]

==== Exemplars of calculating Entropy and Information Content.
+ A fair coin toss has 2 equally probable outcomes, i.e a toss of a coin has 1 bit of information. And observing either 'heads' or a 'tails' has 1 bit of information content.

+ A deck of playing cards has 40 pip (number) cards including the aces, and 12 (face) cards. If the set of events be observing a face card or observing a pip card. Then the entropy of that event would be = (40/52)\*log2(52/40) + (12/52)\*log2(52/12) = 0.78 Bits.


=== Mutual Information
The most important endowment of Claude Shannon's work on information theory was to telecom companies. (Read his 1948 paper, _A Mathematical Theory of Communication_, #link("https://people.math.harvard.edu/~ctm/home/text/others/shannon/entropy/entropy.pdf")[here].) People communicated over noisy channels long before Shannon: telegraph, radio. But maybe only reliably through pigeons. What Shannon showed is that we can communicate *reliably* over a noisy channel, as long as you send below a certain rate (the channel's _capacity_ ). A noisy channel is a medium where the input, or a transformed input, can be corrupted mid-transmission.

For example, imagine using the old Nokia phone to type a message as shown in @old_nokia.
#figure(
  image("assets/old_nokia.png"),
  caption: [Notice how you sometimes have to press a key multiple times to get to the character of your choice.],
) <old_nokia>

Now suppose the keypad is faulty: every so often a single press registers two or three times. You press `2` once, meaning `a`, and the phone shows `b` or `c`. How would you communicate reliably with this phone?

The answer is simple: don't use all 27 characters (26 letters and a space). Make up a smaller language that uses only the first letter on each key, so the receiver only has to read which key was pressed. Such a degenerate (many-to-one) mapping, where `a`, `b` and `c` all decode to "key 2", solves our problem: extra presses no longer matter.


You pay for this in rate: each press now carries $log_2 9 approx 3.17$ bits instead of $log_2 27 approx 4.75$. Shannon's work makes this precise for any noisy channel, and _mutual information_ is the quantity that measures how much of the input survives the channel.
