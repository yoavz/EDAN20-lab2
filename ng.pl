% Author Pierre Nugues
% Rules describing noun groups

% verb_group(-VerbGroup)

verb_group(VG) -->
    verbimal(V1), to(TO), verbimal(V2),
    {append(V1, [TO | V2], VG)}.
verb_group(VG) --> verbimal(VG).

verbimal(VG) -->
    pre_adverb(PRE), verb(V),
    {append([PRE], [V], VG)}.
verbimal(VG) -->
    verb(V), post_adverb(POST),    
    {append([V], [POST], VG)}.
verbimal([V | VG]) --> verb(V), verbimal(VG).
verbimal([V]) --> verb(V).

pre_adverb(PADV) --> adv(PADV).

post_adverb(PADV) --> adv(PADV).
post_adverb(PADV) --> adv_comparitive(PADV).
post_adverb(PADV) --> adv_superlative(PADV).

verb(V) --> base_verb(V).
verb(V) --> past_verb(V).
verb(V) --> past_participle(V).
verb(V) --> present_verb(V).

% noun_group(-NounGroup)
% detects a list of words making a noun group and 
% unifies NounGroup with it
noun_group(NG) -->
    nominal(NOM1), conjunction(CC), nominal(NOM2),
    {append(NOM1, [CC | NOM2], NG)}.
noun_group([D | N]) --> det(D), nominal(N).
noun_group(N) --> nominal(N).

noun_group([PN]) --> proper_noun(PN).
noun_group([PRO]) --> pronoun(PRO).

noun_group(NG) -->
	det(D), adj_group(AG), nominal(NOM),
	{append([D | AG], NOM, NG)}.
noun_group(NG) -->
	adj_group(AG), nominal(NOM),
	{append(AG, NOM, NG)}.

noun_group(NG) -->
    pronoun_special(PRP), adj_group(AG), nominal(NOM),
	{append([PRP | AG], NOM, NG)}.
noun_group(NG) -->
    pronoun_special(PRP), nominal(NOM),
	{append([PRP], NOM, NG)}.

% Nominal expressions
nominal([NOUN | NOM]) --> noun(NOUN), nominal(NOM).
nominal([N]) --> noun(N).

% Nouns divide into common and proper nouns
noun(N) --> common_noun(N).
noun(N) --> proper_noun(N).
noun(N) --> plural_common_noun(N).
noun(N) --> plural_proper_noun(N).
noun(N) --> numerical_cardinal(N).

% adj_group(-AdjGroup)
% detects a list of words making an adjective
% group and unifies AdjGroup with it

adj_group_x([RB, A]) --> adv(RB), adj(A).
adj_group_x([RB, A]) --> adv_comparitive(RB), adj(A).
adj_group_x([RB, A]) --> adv_superlative(RB), adj(A).
adj_group_x([A]) --> adj(A).

adj_group(AG) --> adj_group_x(AG).
adj_group(AG) -->
	adj_group_x(AGX),
	adj_group(AGR),
	{append(AGX, AGR, AG)}.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The POS rules

det(Pair) --> [Pair], { Pair = (_, 'DT') }.

common_noun(Pair) --> [Pair], { Pair = (_, 'NN') }.

proper_noun(Pair) --> [Pair], { Pair = (_, 'NNP') }.

plural_common_noun(Pair) --> [Pair], { Pair = (_, 'NNS') }.

plural_proper_noun(Pair) --> [Pair], { Pair = (_, 'NNPS') }.

numerical_cardinal(Pair) --> [Pair], { Pair = (_, 'CD') }.

pronoun(Pair) --> [Pair], { Pair = (_, 'PRP') }.

pronoun_special(Pair) --> [Pair], { Pair = (_, 'PRP$') }.

genitive(Pair) --> [Pair], { Pair = (_, 'POS') }.

adv(Pair) --> [Pair], { Pair = (_, 'RB') }.

adv_comparitive(Pair) --> [Pair], { Pair = (_, 'RBR') }.

adv_superlative(Pair) --> [Pair], { Pair = (_, 'RBS') }.

adj(Pair) --> [Pair], { Pair = (_, 'JJ') }.

adj(A) --> past_participle(A).
adj(A) --> gerund(A).

conjunction(Pair) --> [Pair], { Pair = (_, 'CC') }.

past_participle(Pair) --> [Pair], { Pair = (_, 'VBN') }.

gerund(Pair) --> [Pair], { Pair = (_, 'VBG') }.

base_verb(Pair) --> [Pair], { Pair = (_, 'VB') }.

past_verb(Pair) --> [Pair], { Pair = (_, 'VBD') }.

present_verb(Pair) --> [Pair], { Pair = (_, 'VBP') }.

present_verb(Pair) --> [Pair], { Pair = (_, 'VBZ') }.

to(Pair) --> [Pair], { Pair = (_, 'TO') }.

preposition(Pair) --> [Pair], { Pair = (_, 'IN') }.
