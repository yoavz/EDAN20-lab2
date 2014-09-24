Lab 2: Manual Rules something
======================
Report by ***Yoav Zimmerman*** for EDAN20 Fall 2014

Lab Setup
---------

For this lab, the tagged and annotated CONLL 2000 data set was used. The data set was split up into a training set of roughly 600,000 words and a test set of roughly 150,000 words. The prolog interpreter used was SWI Prolog, one of the standard prolog implementations. A number of prolog scripts were given to students at the beginning of the lab. These included `conll_io.pl` and `group_detector.pl`, scripts that automatically parsed the text file and chunked the data set based on rules defined in `ng.pl`. In addition, a perl script was given to evaluate how well our rules did by generating an F1 score (combination of precision and recall).

Noun Groups
-----------

Several rules defining noun groups were given to students as a starting basis to improve on. The following are a few:

```prolog
noun_group([D | N]) --> det(D), nominal(N).
noun_group(N) --> nominal(N).

noun_group([PN]) --> proper_noun(PN).
noun_group([PRO]) --> pronoun(PRO).

% Nominal expressions
nominal([NOUN | NOM]) --> noun(NOUN), nominal(NOM).
nominal([N]) --> noun(N).

% Nouns divide into common and proper nouns
noun(N) --> common_noun(N).
noun(N) --> proper_noun(N).

% POS rules
det(Pair) --> [Pair], { Pair = (_, 'DT') }.
common_noun(Pair) --> [Pair], { Pair = (_, 'NN') }.
proper_noun(Pair) --> [Pair], { Pair = (_, 'NNP') }.
```

The POS rules at the bottom describe the _Terminal Rules_ while the rest of the rules are the _Nonterminal Rules_. Notice that there are no left recursion cases in the Nonterminal rules; if one was included, prolog would run out of stack space when attempting to parse the word set. 

The rules above are enough to achieve an F1 score of approximately 50, a reasonable baseline to begin at. But of course, we can do better.

Improving Noun Groups
---------------------

Not all of the part of speech tags are represented in the above ruleset. By adding some of the following terminal rules and linking them to nouns, we are able to increase our F1 score by a few points.

```prolog
noun(N) --> plural_common_noun(N).
noun(N) --> plural_proper_noun(N).
noun(N) --> numerical_cardinal(N).

plural_common_noun(Pair) --> [Pair], { Pair = (_, 'NNS') }.
plural_proper_noun(Pair) --> [Pair], { Pair = (_, 'NNPS') }.
numerical_cardinal(Pair) --> [Pair], { Pair = (_, 'CD') }.
``` 

By manually examining the output, we can also see that we are missing an essential part of speech tag: the possesive pronoun. Some examples of these are "his", "her", or "mine". Similar to determinants, they are usually used together with a noun group (e.g. "his house", "her lazy dog"), so we create some rules for them:

```prolog
noun_group(NG) -->
    pronoun_possessive(PRP), adj_group(AG), nominal(NOM),
	{append([PRP | AG], NOM, NG)}.
noun_group(NG) -->
    pronoun_possessive(PRP), nominal(NOM),
	{append([PRP], NOM, NG)}.

...

pronoun_possessive(Pair) --> [Pair], { Pair = (_, 'PRP$') }.
```

We will add one more improvement, adding superlative and comparitive adjectives to the given rules of adjective groups.

```prolog
adj_group_x([RB, A]) --> adv(RB), adj(A).
adj_group_x([RB, A]) --> adv_comparitive(RB), adj(A).
adj_group_x([RB, A]) --> adv_superlative(RB), adj(A).
adj_group_x([A]) --> adj(A).

adj_group(AG) --> adj_group_x(AG).
adj_group(AG) -->
	adj_group_x(AGX),
	adj_group(AGR),
	{append(AGX, AGR, AG)}.

...

adv_comparitive(Pair) --> [Pair], { Pair = (_, 'RBR') }.
adv_superlative(Pair) --> [Pair], { Pair = (_, 'RBS') }.
```

By running the evaluation script again, we see that we have achieved an F1 score for noun groups of **77.45**. This is a great improvement over the baseline. One could continue tinkering with different rules and continue pushing that score up, but for now we are satisfied. 

Verb Groups
-----------

Using what we learned from improving noun groups, we can now experiment with rules to chunk verb groups. First, we define some rules for our Terminal symbols.

```prolog
base_verb(Pair) --> [Pair], { Pair = (_, 'VB') }.
past_verb(Pair) --> [Pair], { Pair = (_, 'VBD') }.
present_verb(Pair) --> [Pair], { Pair = (_, 'VBP') }.
present_verb(Pair) --> [Pair], { Pair = (_, 'VBZ') }.
```

Next, we write some basic rules for verbs.

```prolog
verb_group(VG) --> verbimal(VG).
verbimal([V | VG]) --> verb(V), verbimal(VG).
verbimal([V]) --> verb(V).

verb(V) --> base_verb(V).
verb(V) --> past_verb(V).
verb(V) --> past_participle(V).
verb(V) --> present_verb(V).
```

That helps us achieve an F1 score of around 40. But we can do even better by including some rules for adverbs. We observe that there are three different types of adverbs: 

* adverb: occasionally, unabatingly, maddeningly
* adverb, comparitive: further, gloomier, grander
* adverb, superlative: best, biggest, bluntest

We further observe that the first type of adverb can come before or after a verb (e.g. maddeningly run), while comparitive and superlative adverbs, _in most cases_, come after a verb (e.g. ran further). We use this insight to define two nonterminal symbols, `pre_adverb` and `post_adverb`, and define rules around them:

```prolog
verbimal(VG) -->
    pre_adverb(PRE), verb(V),
    {append([PRE], [V], VG)}.
verbimal(VG) -->
    verb(V), post_adverb(POST),    
    {append([V], [POST], VG)}.

pre_adverb(PADV) --> adv(PADV).
post_adverb(PADV) --> adv(PADV).
post_adverb(PADV) --> adv_comparitive(PADV).
post_adverb(PADV) --> adv_superlative(PADV).

adv(Pair) --> [Pair], { Pair = (_, 'RB') }.
adv_comparitive(Pair) --> [Pair], { Pair = (_, 'RBR') }.
adv_superlative(Pair) --> [Pair], { Pair = (_, 'RBS') }.
```

With these rules in place, we run the evaluation script once more and achieve a final F1 score of **55.19** for verb groups. This is satisfactory for this lab, but reminds us that the method of manually setting and testing rules is cumbersome and noneffecient if we ever want to achieve near-human precision and recall. Next week, we will use much more effective machine learning techniques to chunk the CoNLL2000 dataset.
