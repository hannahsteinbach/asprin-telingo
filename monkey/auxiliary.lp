banana_aux :- finally, holds(hasBanana).
chocolate_aux :- finally, holds(hasChocolate).

always(p2_aux) :-
    eventually(holds(hasBanana)),
    eventually(holds(hasChocolate)),
    until(negation(holds(hasChocolate)), holds(hasBanana)).