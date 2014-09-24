Lab 2: Manual Rules something
======================
Report by ***Yoav Zimmerman*** for EDAN20 Fall 2014

Lab Setup
---------

For this lab, the tagged and annotated CONLL 2000 data set was used. The data set was split up into a training set of roughly 600,000 words and a test set of roughly 150,000 words. The prolog interpreter used was, SWI Prolog, one of the standard prolog implementations. A number of prolog scripts were given to students at the beginning of the lab. Theseincluded `conll_io.pl` and `group_detector.pl`, scripts that automatically parsed the text file and chunked the data set based on rules defined in `ng.pl`. In addition, a perl script was given to evaluate how well our rules did by generating an F1 score (combination of precision and recall).

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

The POS rules at the bottom describe the ***Terminal Rules*** while the rest of the rules are the Nonterminal Rules. Notice that there is no left recursion in the Nonterminal rules; if one was included, prolog would run out of stack space when attempting to parse the word set. 

The rules above are enough to achieve an F1 score of approximately 50, a reasonable baseline to begin at. But of course, we can do better.

Improving Noun Groups
---------------------

Firstly, not all the part of speech tags were represented in the given ruleset. By adding some...

```prolog
added part of speech
``` 

Next, we can also do conjunctions
```prolog
conjuctions...
```
but this didn't help much...

Do more...

Verb Groups
-----------

Using what we learned from improving noun groups, we can now experiment with rules to chunk verb groups. First, we define some rules for our Terminal symbols.

```prolog
terminal rules..
````

Next, we write some basic rules for verbs 

```prolog
basic verb rules no adverbs.
```

That helps us achieve an F1 score of X. Let's add in some rules for adverbs and see how much better we can do.

```prolog
adverb rules
```

alright! an f1 score of 77! that's good shit.
