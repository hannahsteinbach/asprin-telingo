#external always(holds(at(home))).
#external finally.
#external initially.

% p1
#external and(initially, p1_aux).

% p2
#external and(p2_aux, initially).
#external always(knowsHowToMake(spaghetti)).

% p3
#external eventually(p3_aux).

% p4
#external always(p4_aux).

% p5
#external eventually(p5_aux).


% p6
#external eventually(p6_aux).

% p7
#external eventually(p7_aux).

% p8
#external always(negation(and(occurs(drive), holds(isSnowing)))).
#external always(p8_aux).

% p9
#external always(p9_aux).
#external always(negation(occurs(eatChinese))).

% p10
#external eventually(occurs(eat(spaghetti))).
#external eventually(occurs(eat(pizza))).
#external eventually(occurs(eat(crepes))).
#external and(negation(eventually(occurs(eat(crepes)))),
                            and(negation(eventually(occurs(eat(spaghetti)))), negation(eventually(occurs(eat(pizza)))))).


% p11
#external and(eventually(p5_aux), always(p4_aux)).
#external and(eventually(p5_aux), negation(always(p4_aux))).

% p12
#external if(and(p2_aux, initially), and(eventually(p5_aux), always(p4_aux))).

%#show show(p1_aux).
%#show show(p2_aux).
%#show show(p3_aux).
%#show show(p4_aux).
%#show show(p5_aux).
%#show show(p6_aux).
%#show show(p8_aux).
%#show show(p9_aux).
%#show show(p10_aux).
%#show show(p11_aux).
%#show show(p12_aux).
%#show show(p13_aux).
%#show show(p14_aux).

#external eventually(occurs(cook(X))) : meal(X).
#external eventually(occurs(orderTakeout(X,Y))) : meal(X), takeOutRest(Y).
#external eventually(occurs(orderRestaurant(X,Y))) : meal(X), dineInRest(Y).