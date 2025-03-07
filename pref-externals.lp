#external always(holds(at(home))).
#external holds(finalkitchenClean).
#external holds(isSnowing) : isSnowing.
#external finally.
#external initially.
#external chinese(sweetsourpork).

#external holds(hasIngredients(spaghetti)).

#external and(initially, p1_aux).
#external and(initially, p2_aux).
#external and(finally, p3_aux).
#external always_before(p3_aux).
#external always(p4_aux).
#external eventually(p5_aux).
#external eventually(p6_aux).
#external eventually(p7_aux).

#external and(eventually(p5_aux), always(p4_aux)).
#external negation(and(eventually(p5_aux), always(p4_aux))).
#external and(eventually(p5_aux), negation(always(p4_aux))).

#external always(p8_aux).
#external always(negation(and(isSnowing), occurs(drive(X,Y)))) : location(X), location(Y).

#external eventually(occurs(eat(pizza))).
#external eventually(occurs(eat(spaghetti))).
#external eventually(occurs(eat(crepes))).

#external negation(always(p2_aux)).

#external always(p9_aux).

#external always(negation(occurs(eatChinese))).
%#show show(p1_aux).
%#show show(p2_aux).
%#show show(p3_aux).
%#show show(p4_aux).
%#show show(p5_aux).

#external knowsHowToMake(spaghetti).
#external hasknowsSpaghetti.
#external hasknowsmeal.

#external negation(eventually(occurs(cook))) .

#external eventually(occurs(cook(X))) : meal(X).
#external always(occurs(drive(X,Y))) : drive(X,Y).
#external eventually(occurs(orderTakeout(X,Y))) : meal(X), takeOutRest(Y).
#external eventually(occurs(orderRestaurant(X,Y))) : meal(X), dineInRest(Y).
#external eventually(occurs(eat(X))): meal(X).
#external chinese(X): meal(X).
#external knowsHowToMake(X) : meal(X).
#external hasIngredients(X) : meal(X).

#external eventually(occurs(orderTakeout)).
#external eventually(occurs(orderRestaurant)).
#external finalkitchenClean.
#external and(always(holds(at(home))),eventually(occurs(cook))).
#external negation(and(always(holds(at(home))),eventually(occurs(cook)))).
#external and(eventually(occurs(eat(pizza))), negation(eventually(occurs(eat(spaghetti))))).
#external and(negation(always(holds(at(home)))),eventually(occurs(cook))).
#external and(negation(always(holds(at(home)))), and(negation(eventually(occurs(orderRestaurant))), negation(eventually(occurs(cook))))).
#external and(eventually(occurs(eat(crepes))), and(negation(eventually(occurs(eat(spaghetti)))), negation(eventually(occurs(eat(pizza)))))).
#external and(negation(eventually(occurs(eat(crepes)))), and(negation(eventually(occurs(eat(spaghetti)))), negation(eventually(occurs(eat(pizza)))))).