Non-Deterministic Pushdown Automaton Simulator
==============================================

This is a ruby implementation of a [Non-Deterministic Pushdown Automaton](http://en.wikipedia.org/wiki/Pushdown_automaton)

This is the machine for palindromes:

    1:	(q0, a, Z) -> (q0, aZ)(q1, Z)
    2:	(q0, b, Z) -> (q0, bZ)(q1, Z)
    3:	(q0, a, a) -> (q0, aa)(q1, a)
    4:	(q0, b, a) -> (q0, ba)(q1, a)
    5:	(q0, a, b) -> (q0, ab)(q1, b)
    6:	(q0, b, b) -> (q0, bb)(q1, b)
    7:	(q0, , Z) -> (q1, Z)
    8:	(q0, , a) -> (q1, a)
    9:	(q0, , b) -> (q1, b)
    10:	(q1, a, a) -> (q1, )
    11:	(q1, b, b) -> (q1, )
    12:	(q1, , Z) -> (q2, Z)

We can print a derivation tree. This one is for "aba":

    (q0, aba, Z)
    rule  1 |-(q0, ba, aZ)
    rule  4  |-(q0, a, baZ)
    rule  5   |-(q0, , abaZ)
    rule  8    |-(q1, , abaZ)
    Crash! I couldn't find a rule for: state q1, input , stack abaZ
    rule  5   |-(q1, , baZ)
    Crash! I couldn't find a rule for: state q1, input , stack baZ
    rule  9   |-(q1, a, baZ)
    Crash! I couldn't find a rule for: state q1, input a, stack baZ
    rule  4  |-(q1, a, aZ)
    rule 10   |-(q1, , Z)
    rule 12    |-(q2, , Z)
    Accept
    rule  8  |-(q1, ba, aZ)
    Crash! I couldn't find a rule for: state q1, input ba, stack aZ
    rule  1 |-(q1, ba, Z)
    rule 12  |-(q2, ba, Z)
    Crash! I couldn't find a rule for: state q2, input ba, stack Z
    rule  7 |-(q1, aba, Z)
    rule 12  |-(q2, aba, Z)
    Crash! I couldn't find a rule for: state q2, input aba, stack Z
    
We can test whether certain strings accept:

    a                    true
    ab                   false
    bb                   true
    bbb                  true
                         true
    bbaabb               true

We can count the number of leaf nodes in the derivation tree (crashes plus accept, if any):

    a                    3
    ab                   5
    bb                   5
    aab                  7
    aba                  7
    bbb                  7
    abba                 9
    abbab                11
    abbaba               13
    bbbbbb               13