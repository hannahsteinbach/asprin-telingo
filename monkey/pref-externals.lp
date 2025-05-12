%p1
#external finally.
#external holds(hasBanana).
#external holds(hasChocolate).
#external eventually(banana_aux).
#external eventually(chocolate_aux).


#external eventually(holds(hasBanana)).

%p2
#external eventually(holds(hasChocolate)).
#external until(negation(holds(hasChocolate)), holds(hasBanana)).
#external always(p2_aux).
#external negation(always(p2_aux)).

#external and(and(eventually(holds(hasBanana)),
    eventually(holds(hasChocolate))),
    until(negation(holds(hasChocolate)), holds(hasBanana))).
