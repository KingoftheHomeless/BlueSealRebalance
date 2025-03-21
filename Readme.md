# BlueSealRebalance
A mod that attempts to rebalance blue seals in such a way to nerf it for High Card and Pairs in particular,
while keeping nearly as powerful for large-hand strategies.
I'm still evaluating this approach: it has not been extensively balance tested. Any testing and feedback would be
highly appreciated!

Blue seal now reads:
> If held in hand, 1 in 8 chance times the number of scoring cards to create the Planet card for played poker hand

For example, if you play a Pair (scoring two cards) with a blue seal in hand, you have a 25% chance to get
the Mercury. If you play a Flush, you have a 62.5% to get a Jupiter. An Oops can push the likelihood
to 100%, but you can't get more than one Planet card without retriggers.

Unlike vanilla blue seal, you can get the planet card for any hand you play, not just the final one. This decision
was to lessen the already significant complexity of the current wording.

### Questions and Answers
To preemptively answer some possible questions:
### Wait, what's the problem with Blue Seal?

It's way too strong, **especially** so for pairs. Considering you'd buy a Jumbo
Celestial pack for a *chance* to get your preferred Planet card, and that still
costs 6 dollars, the value you get from a blue seal trigger is disproportionally
huge compared to the other seals.

The reason why it's so broken for pairs in particular is that pairs can
violently throw away hands and discards to dig for it, and still safely be able
to guarantee a win as pairs are so simple to assemble. Blue seals are so strong
for pairs that if manage to get one or two of them early on, then they can
very easily carry you through the entire game, even on gold stake.

### You've basically turned Blue Seal into Space Joker! Isn't that **more** broken?

More broken, no; at least not without a Joker that combos with it. I can say that with confidence.
Vanilla blue seal is **ridiculous**.

The key difference between this blue seal and Space Joker is that you have to actually draw up the blue seal,
and keep it in your hand, to benefit from it: you have to work to even start
getting the dice rolls going. Lets take a Pair strategy as an example: in order to maximize
value, you'd need to draw into the blue seal with the two discards you're given and then play all 4 pairs
without prematurely winning. _This is not trivial_, and even in this best case the expected value is still only
a single Mercury, and there's a 30% chance to not get one at all. If you only manage to play, say,
two Pairs with the blue seal in hand, then the expected value is only half of a Mercury instead.
Compare that to vanilla blue seal, where the only thing that matters is that you have it when you play your
winning hand, and you are guaranteed the Mercury.

With big-hand strategies, the math becomes more favorable, and with a single 5-card poker hand you have a 62.5%
chance to get the planet card for it. You'd think this would be broken, but it's usually still significantly weaker
than vanilla blue seal; big hands are difficult to find and play multiple of in a single round, especially as
once you've a good enough setup to win the early blinds you're very likely going to win from the first
big hand you play.

### Hold on, you can sell the planet card from any trash hands you play when digging. Isn't that too good?

Nah. Planet cards sell for a dollar, so at best you'll recoup the dollar lost from
spending the hand in the first place. Considering trash hands tend to be pairs and high cards, which
aren't likely to give you a planet card, I think this aspect of the blue seal is inconsequential.

### Isn't this **still** too powerful? Especially considering possible joker combos, or two pairs and flushes even without combos?

Maybe. I think this blue seal is on par with the other seals in a vacuum, but
it doesn't exist in a vacuum. Flushes and two pairs are rather easy to
set up while still having favorable likelihood for the blue seal to trigger. In particular,
this blue seal makes the checkered deck *rather broken*.
Oops is also extremely, extremely good with this, but it's uncommon so I'm letting it slide.
What's **not** uncommon is Splash, which upends the probability math and lets Pair and High Card strategies
pump out loads of planet cards from a Blue Seal. The novelty of having Splash
actually be an attractive joker is interesting enough that I'm willing to allow
that combo.

There are some alternate formulations I'm considering if it turns out to be necessary to reign in
the blue seal:

* Reintroduce the "final hand" clause (and adjust odds accordingly). The benefit of this is that it
  places an upper limit of 1 to how many Planet cards you can get from a blue seal in a single round,
  which helps curb its combo potential. The big downside of this is that it eliminates the strategic
  element of smaller hand strategies needing to find blue seal as early as possible and play multiple
  hands with it in order to compensate for the reduced odds of it triggering.
* If Splash in particular is too good, make the multiplier the base size of the poker hand instead of
  the number of scoring cards.
* If flushes and two pairs are too good, make the multiplier be based on the _+Mult_ the planet card gives. I.e:
  > If held in hand, 1 in 4 chance times the Mult of the Planet card for played poker hand to create that
  > Planet card.
  This makes Jupiter a 50% chance rather than 63%, and Uranus a 25% chance.

### Holy hell that blue seal description is way too long and complex

_Yeah._ It was the best I could do. I can't think of a good way to lessen it.
