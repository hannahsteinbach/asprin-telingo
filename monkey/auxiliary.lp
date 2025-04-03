eventually(p1_aux) :- eventually(holds(hasBanana)).


always(p2_aux) :-
    eventually(holds(hasBanana)),
    eventually(holds(hasChocolate)),
    until(negation(holds(hasChocolate)), holds(hasBanana)).