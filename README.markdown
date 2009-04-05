Non-Deterministic Pushdown Automaton Simulator
==============================================

This is a ruby implementation of a [Non-Deterministic Pushdown Automaton](http://en.wikipedia.org/wiki/Pushdown_automaton)

This is the machine:

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

Here's some sample output:

    (q0, a, Z)
    rule  1 |-(q0, , aZ)
    rule  8  |-(q1, , aZ)
    Crash! I couldn't find a rule for: state q1, input , stack aZ
    rule  1 |-(q1, , Z)
    rule 12  |-(q2, , Z)
    Accept
    rule  7 |-(q1, a, Z)
    rule 12  |-(q2, a, Z)
    Crash! I couldn't find a rule for: state q2, input a, stack Z

    (q0, ab, Z)
    rule  1 |-(q0, b, aZ)
    rule  4  |-(q0, , baZ)
    rule  9   |-(q1, , baZ)
    Crash! I couldn't find a rule for: state q1, input , stack baZ
    rule  4  |-(q1, , aZ)
    Crash! I couldn't find a rule for: state q1, input , stack aZ
    rule  8  |-(q1, b, aZ)
    Crash! I couldn't find a rule for: state q1, input b, stack aZ
    rule  1 |-(q1, b, Z)
    rule 12  |-(q2, b, Z)
    Crash! I couldn't find a rule for: state q2, input b, stack Z
    rule  7 |-(q1, ab, Z)
    rule 12  |-(q2, ab, Z)
    Crash! I couldn't find a rule for: state q2, input ab, stack Z

    (q0, bb, Z)
    rule  2 |-(q0, b, bZ)
    rule  6  |-(q0, , bbZ)
    rule  9   |-(q1, , bbZ)
    Crash! I couldn't find a rule for: state q1, input , stack bbZ
    rule  6  |-(q1, , bZ)
    Crash! I couldn't find a rule for: state q1, input , stack bZ
    rule  9  |-(q1, b, bZ)
    rule 11   |-(q1, , Z)
    rule 12    |-(q2, , Z)
    Accept
    rule  2 |-(q1, b, Z)
    rule 12  |-(q2, b, Z)
    Crash! I couldn't find a rule for: state q2, input b, stack Z
    rule  7 |-(q1, bb, Z)
    rule 12  |-(q2, bb, Z)
    Crash! I couldn't find a rule for: state q2, input bb, stack Z

    (q0, bbb, Z)
    rule  2 |-(q0, bb, bZ)
    rule  6  |-(q0, b, bbZ)
    rule  6   |-(q0, , bbbZ)
    rule  9    |-(q1, , bbbZ)
    Crash! I couldn't find a rule for: state q1, input , stack bbbZ
    rule  6   |-(q1, , bbZ)
    Crash! I couldn't find a rule for: state q1, input , stack bbZ
    rule  9   |-(q1, b, bbZ)
    rule 11    |-(q1, , bZ)
    Crash! I couldn't find a rule for: state q1, input , stack bZ
    rule  6  |-(q1, b, bZ)
    rule 11   |-(q1, , Z)
    rule 12    |-(q2, , Z)
    Accept
    rule  9  |-(q1, bb, bZ)
    rule 11   |-(q1, b, Z)
    rule 12    |-(q2, b, Z)
    Crash! I couldn't find a rule for: state q2, input b, stack Z
    rule  2 |-(q1, bb, Z)
    rule 12  |-(q2, bb, Z)
    Crash! I couldn't find a rule for: state q2, input bb, stack Z
    rule  7 |-(q1, bbb, Z)
    rule 12  |-(q2, bbb, Z)
    Crash! I couldn't find a rule for: state q2, input bbb, stack Z

    (q0, , Z)
    rule  7 |-(q1, , Z)
    rule 12  |-(q2, , Z)
    Accept