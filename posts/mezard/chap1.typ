#import "../../lib/components.typ": *

#callout(title: "Further reading", color: olive)[
Before we move ahead with the section. #link("https://www.inference.org.uk/mackay/itila/")[Information Theory by David J. C MacKay] is a highly suggested read if you ever get interested in information theory and its applications. We will only go over quick instincts of information theory; which i believe is a poor substitute for the book, but is still replete for our current needs.
]

===  Entropy and Information Content
==== Entropy
*Entropy is a measure of uncertainty*. The higher the uncertainty of an experiment; the higher the entropy.

#callout(title: "definition", color: blue)[
Entropy is defined as:

#math.equation(
  block: true,
  $H(X) = sum_x p(X=x) log_2 1/p(X=x)$,
)


]
Its important to note how Entropy is an expected quantity. Its an average of all the information content of all the events $x$.

==== Information Content
An information content is defined for a particular event $x$, and $h(x) = log_2 (1\/p(x))$ is
its information content. The base of the log depends on the convenience of the operation. For an example if your loss function is an entropy function and the last layer does softmax you're better off using the natural log (base $e$) in your loss function, as that would undo the exponentiation of softmax; information measured with base $e$ is in _nats_. But the most common unit of information is called a 'bit' if the base of the log is 2.

#callout(title:"alert", color:red)[
*Note "1 bit of information" is very much different than a binary digit which we also call bit, so for the rest of the article we will never interchangeably call a binary digit a bit.*
]

==== Exemplars of calculating Entropy and Information Content.
+ A fair coin toss has 2 equally probable outcomes, i.e a toss of a coin has 1 bit of entropy. And observing either 'heads' or a 'tails' has 1 bit of information content.

+ A deck of playing cards has 40 pip (number) cards including the aces, and 12 face cards. If the experiment is observing a face card or observing a pip card, then the entropy of that experiment would be = (40/52)\*log2(52/40) + (12/52)\*log2(52/12) = 0.78 bits.


=== The typical set
So far we have looked at one coin toss at a time. The real power of entropy shows up when we look at long _sequences_. Take a bent coin that lands heads with probability $p = 0.1$, and toss it $n = 100$ times. A single coin toss has an entropy of $H(x) = 0.469$. The event with "no heads at all" has a probability $0.9^100 approx 2^(-15)$. That is you would almost never see it. What you would see is a sequence with number of heads equal to its expectation. i.e around 10 heads. And any sequence with 10 heads has a probability of :
  $ = 0.1^10 dot 0.9^90 $
  $ = 2^(log_2( 0.1^10 dot 0.9^90 )) $
  $ = 2^(10 dot log_2(0.1) + 90 dot log_2(0.9)) $
  $ = 2^(-(10 log_2 10 + 90 log_2 (10\/9))) = 2^(-1 * n * H(x) ) $
  $ = 2^(-46.9) $
  // notice how this is just exp2(-1 \* number of trials \* entropy of trial).
  // so probability of one of the typical sequence is just $1/2^(n dot H(x)) $

So a long sequence is almost certainly one whose information content is close to $n H(X)$. MacKay calls these sequences the _typical set_.

#callout(title: "Definition", color: blue)[
  The typical set $T_(n beta)$ holds the sequences $bold(x) = (x_1, ..., x_n)$ whose information content per symbol is within $beta$ of the entropy (i.e roughly around $n dot H(x)$):
  $ T_(n beta) = { bold(x) : |1/n log_2 1/P(bold(x)) - H(X)| < beta } $

  For large $n$ (the _asymptotic equipartition property_):
  + the sequence you observe is in $T_(n beta)$ with probability close to 1, i.e the probability distribution is condensed over only the typical sequences; and not sequences like all heads.
  + every typical sequence has probability about $2^(-n H(X))$, so they are all uniformly likely.
  + and there are about $2^(n H(X))$ of them.
]

Shanon says:
+ To store the result of an experiment with 100 coin tosses as 100 binary digits will have on average 47 Bits of information. And that can be represented with only 47 Binary digits. This is commonly called *Shannon's source coding theorem*. And you cannot do better than this on average.

+ For long sequences entropy can also be seen as the log of the number of configurations that are typical to that experiment. This would come up with Boltzmann's distribution which we will see in subsequent chapters.

#callout(title: "Further Reading", color: yellow)[
  The typical set tells you that compressing to $n H(X)$ binary digits is possible, but numbering $2^47$ sequences in a lookup table is not practical. Read about _arithmetic coding_, a practical way to compress a sequence to about $n H(X)$ binary digits, i.e. to a fractional number of binary digits per symbol.
]


=== Mutual Information
The most important endowment of Claude Shannon's work on information theory was to telecom companies. (Read his 1948 paper, _A Mathematical Theory of Communication_, #link("https://people.math.harvard.edu/~ctm/home/text/others/shannon/entropy/entropy.pdf")[here].) People communicated over noisy channels long before Shannon: telegraph, radio. But maybe only reliably through pigeons. What Shannon showed is that we can communicate *reliably* over a noisy channel, as long as you send information below a certain rate called the channel's _capacity_  (we will look into this in a minute) . A noisy channel is a medium where the input, or a transformed input, can be corrupted mid-transmission.

==== Example of communication through corrupted channel
For example, imagine using the old Nokia phone to type a message as shown in @old_nokia.
#figure(
  image("assets/old_nokia.png"),
  caption: [Notice how you sometimes have to press a key multiple times to get to the character of your choice.],
) <old_nokia>

Now suppose the keypad is sticky and faulty: ever so often a single press registers two or three times. You press `2` once, meaning `a`, and the phone shows `b` or `c`. To keep the maths simple, say the fault is as bad as it can be: whatever letter you meant, the phone shows any of the letters on that key with equal probability. How would you communicate reliably with this phone?

The answer is simple: don't use your language which needs all the 27 characters (26 letters and a space) to communicate. Make up a new and smaller language that uses only the first letter on each key, so the receiver only has to read which key was pressed. Such a degenerate mapping, where `a`, `b` and `c` all decode to "key 2", solves our sticky key problem.

If the keys were not sticky you could transmit (log2(27)) 4.75 bits per character. But now you're only transmitting (log2(9)) 3.17 bits, one of 9 keys (eight letter keys and the space key). Shannon's work formalizes this for any noisy channel, and _mutual information_ is the quantity that measures how much of the input survives the channel.


#callout(title:"Definition", color:blue)[
  Mutual Information is defined as $I(X;Y) = H(X) - H(X|Y)$
  - where $X$ is the input and $Y$ is the output.
  - This tells us how much uncertainty of the message was removed after observing the output. For a perfect channel $H(X|Y)$ would be equal to 0.
]

==== Alphabet size of new language
From our previous example, if we were communicating with the 27 char language over sticky keys, using every character equally often, the uncertainty of the source $H(X)$ would be log2(27) = 4.75 bits. After receiving one output we still don't know which letter on that key was meant, so $H(X|Y)$ is log2(3) = 1.58 for most keys. (Note not exactly since: `pqrs` and `wxyz` have 4 letters and space is alone on key 0, which makes $H(X|Y)$ = 1.65 bits on average) So the mutual information of the experiment is about 3.10 bits. And the communcation needs post processing since $H(X|Y)$ is non zero.

If instead we use only our new language, the 9 keys equally often, then $H(X)$ = log2(9) and the output tells us exactly which key was pressed, so $H(X|Y)$ = 0 and the mutual information is log2(9) = 3.17 bits. That is more than the 3.11 bits we got from typing every letter equally often, and no other way of choosing what to send does better. $2^(I(X;Y))$ = 9 is another way of finding out the alphabet size of your new language; with which you could reliably communicate.

==== Channel Capacity
Shannon tells us that the maximum rate of reliable communication that you could achieve is the largest mutual information you can get by choosing the probability distribution of the input, and we call this the channel's capacity:

$ C = max_(p(x)) I(X;Y) $

The distribution that achieves it is the _optimal input distribution_ (for the Nokia, "every key equally often"). For any rate below $C$ you can communicate with as small a probability of error as you like including 0. Lets look at another example to go through this.

#callout(title:"How do we achieve fractional bit per symbol")[
Imagine a wire that can send binary messages. But it flips the voltage ever so often with probability 0.1. Since the message alphabet was already binary we can no longer reduce the alphabet size to communicate. That is if this were a perfect channel we would have been able to communicate with 1 bit of information per received symbol. But now we could only communicate with the channel's capacity which is: 1 - (0.9\*log2(10/9) + 0.1\*log2(10)) = 1 - 0.469 = 0.531 bits of information per received symbol (that is 1 - H2(0.1), where H2(0.1) = 0.469 is the uncertainty that still remains after observing an output). What do we do now?
]

==== Adding redundancy
*First try: repeated codes.* Send every bit odd number of times say three times, `0` → `000` and `1` → `111`, and let the receiver take a majority vote. This is called the repetition code $R_3$.

#figure-box(caption: [The repetition code $R_3$: the decoder is only wrong when 2 or 3 of the 3 copies flip.])[
  #diagram(
    node((0, 0), [`1`]),
    edge("-|>", [encode]),
    node((2, 0), [`111`]),
    edge("-|>", [noisy wire]),
    node((4, 0), [`101`], fill: rgb("#fde2e2")),
    edge("-|>", [majority vote]),
    node((6, 0), [`1`]),
  )
]

The decoder is wrong only if at least two of the three copies flip, which happens with probability $3 f^2 (1 - f) + f^3 = 0.028$ (down from $f = 0.1$). Five copies ($R_5$) bring it down to $0.0086$. The reliability increases but we pay for it: $R_3$ sends $1\/3$ of a bit of information per use of the wire, $R_5$ only $1\/5$. Pushing the error to zero this way pushes the rate to zero too.

*Shannon's surprise.* But repeating to get reliability does not converge to 0 fast enough. And Shannon says we don't have to give up the communication rate. Any rate below $C = 0.531$ bits per use can be sent with an error as small as we like including 0. The trick is the Nokia trick again. The typical set of a code word from new language was a,b,c -> a , d,e,f ->d and so on. This can also be applied to long _blocks_ instead of single symbols, and the typical set tells us how big the new language can be.

+ Send blocks of $n$ binary digits. The wire flips expected number of them i.e about $0.1 n$ of them, and the pattern of flips is (almost surely) one of the typical noise patterns, of which there are about $2^(n H_2(0.1)) = 2^(0.469 n)$.

+ so a code word once sent can be corrupted into one of the $2^(0.469 dot n)$ of them.
+ so what if reserve all of the $2 ^ (0.469 dot n)$ for that single code. This would reduce the alphabet size of the input language but will solve the reliability of communication. we will call this the count of this typical set as the band of the keyword.

+ There are $2^n$ possible received strings. If the band of any of the two codewords overlap, the receiver can confuse them and the message would no longer be reliable; if they don't, it can always tell them apart. So the number of codes that we can reliably tell apart would be:

  $  =  2^n / 2^(0.469 n) = 2^(n(1 - 0.469)) = 2^(0.531 n) = 2^(I(x;y)) $
  bands can fit without overlapping.
+ So our new language has $2^(0.531 n)$ "symbols", one per block of input message. And now its trivial to see how we can communicate near the channels capacity.

#figure-box(caption: [Block coding: pick codewords whose noise bands don't overlap. The receiver decodes to the codeword whose bands the received string lands in.The width of the band unfortunately only depends on the physical qualities of the channel; which is not often optimized. Here we can pick orange and blue codes but not yellow since it overlaps. We would want to pick as many non overlapping bands as we can to increase the rate of communication.
])[
  #diagram(
    node((0, 0), [band of $c_1$], shape: rect, width: 10em, name: <b1>, fill: orange),
    node((0.7, 0), [band of $c_2$], shape: rect, width: 10em, name: <b2>, fill:yellow),
    node((1.5, 0), [band of $c_3$], shape: rect, width: 10em, name: <b3>, fill:blue),
    node((2.2, 0), [........], stroke: none, name: <b4>),
    node((2.9, 0), [band of $c_n$], shape: rect, width: 10em, name: <b5>),
    // node((3, 0), [...], stroke: none, name: <b4>),
    node(enclose: (<b1>, <b2>, <b3>, <b4>, <b5>), [], stroke: (dash: "dashed"), inset: 14pt),
  )
]

Note, The longer the block, the closer the noise sticks to its typical number of flips, and the smaller the error when generating input vocubulary.
