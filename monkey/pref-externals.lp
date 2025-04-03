%p1
#external eventually(holds(hasBanana)).
#external eventually(p1_aux).
#external negation(eventually(p1_aux)).

%p2
#external eventually(holds(hasChocolate)).
#external until(negation(holds(hasChocolate)), holds(hasBanana)).
#external always(p2_aux).
#external negation(always(p2_aux)).
